"""Wrapper around command line xrandr (only 1.2 per output features supported)"""

import os
import subprocess
import warnings

from .auxiliary import BetterList, Size, Position, Geometry, FileLoadError, FileSyntaxError, InadequateConfiguration, Rotation, ROTATIONS, NORMAL

import gettext
gettext.install('arandr')

SHELLSHEBANG='#!/bin/sh'

class XRandR(object):
    DEFAULTTEMPLATE = [SHELLSHEBANG, '%(xrandr)s']

    def __init__(self, display=None, force_version=False):
        """Create proxy object and check for xrandr at `display`. Fail with
        untested versions unless `force_version` is True."""
        self.environ = dict(os.environ)
        if display:
            self.environ['DISPLAY'] = display

        version_output = self._output("--version")
        if not ("1.2" in version_output or "1.3" in version_output) and not force_version:
            raise Exception("XRandR 1.2/1.3 required.")

    def _get_outputs(self):
        assert self.state.outputs.keys() == self.configuration.outputs.keys()
        return self.state.outputs.keys()
    outputs = property(_get_outputs)

    #################### calling xrandr ####################

    def _output(self, *args):
        p = subprocess.Popen(("xrandr",)+args, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=self.environ)
        ret, err = p.communicate()
        status = p.wait()
        if status!=0:
            raise Exception("XRandR returned error code %d: %s"%(status,err))
        if err:
            warnings.warn("XRandR wrote to stderr, but did not report an error (Message was: %r)"%err)
        return ret

    def _run(self, *args):
        self._output(*args)

    #################### loading ####################

    def load_from_string(self, data):
        data = data.replace("%","%%")
        lines = data.split("\n")
        if lines[-1] == '': lines.pop() # don't create empty last line

        if lines[0] != SHELLSHEBANG:
            raise FileLoadError('Not a shell script.')

        xrandrlines = [i for i,l in enumerate(lines) if l.strip().startswith('xrandr ')]
        if len(xrandrlines)==0:
            raise FileLoadError('No recognized xrandr command in this shell script.')
        if len(xrandrlines)>1:
            raise FileLoadError('More than one xrandr line in this shell script.')
        self._load_from_commandlineargs(lines[xrandrlines[0]].strip())
        lines[xrandrlines[0]] = '%(xrandr)s'

        return lines

    def _load_from_commandlineargs(self, commandline):
        self.load_from_x()

        args = BetterList(commandline.split(" "))
        if args.pop(0) != 'xrandr':
            raise FileSyntaxError()
        options = dict((a[0], a[1:]) for a in args.split('--output') if a) # first part is empty, exclude empty parts

        for on,oa in options.items():
            o = self.configuration.outputs[on]
            if oa == ['--off']:
                o.active = False
            else:
                if len(oa)%2 != 0:
                    raise FileSyntaxError()
                parts = [(oa[2*i],oa[2*i+1]) for i in range(len(oa)//2)]
                for p in parts:
                    if p[0] == '--mode':
                        o.mode = Size(p[1])
                    elif p[0] == '--pos':
                        o.position = Position(p[1])
                    elif p[0] == '--rotate':
                        if p[1] not in ROTATIONS:
                            raise FileSyntaxError()
                        o.rotation = Rotation(p[1])
                    else:
                        raise FileSyntaxError()
                o.active = True

    def load_from_x(self): # FIXME -- use --verbose or, better, a library
        self.configuration = self.Configuration()
        self.state = self.State()

        screenline, items = self._load_raw_lines()

        self._load_parse_screenline(screenline)

        for headline,details in items:
            if headline.startswith("  "): continue # a currently disconnected part of the screen i can't currently get any info out of
            if headline == "": continue # noise

            hsplit = headline.split(" ")
            o = self.state.Output(hsplit[0])
            assert hsplit[1] in ("connected","disconnected")

            o.connected = (hsplit[1] == 'connected')

            if not hsplit[2].startswith("("):
                active = True

                geometry = Geometry(hsplit[2])

                if hsplit[3] in ROTATIONS: rotation = Rotation(hsplit[3])
                else: rotation = NORMAL
            else:
                active = False
                geometry = None
                rotation = None

            o.rotations = set()
            for r in ROTATIONS:
                if r in headline:
                    o.rotations.add(r)

            for d in details:
                o.modes.append(Size(int(a) for a in d.strip().split(" ")[0].split("x")))

            self.state.outputs[o.name] = o
            self.configuration.outputs[o.name] = self.configuration.OutputConfiguration(active, geometry, rotation)

    def _load_raw_lines(self):
        output = self._output("-q")
        items = []
        screenline = None
        for l in output.split('\n'):
            if l.startswith("Screen "):
                assert screenline is None
                screenline = l
            elif l.startswith("   "): # mode
                items[-1][1].append(l)
            else:
                items.append([l, []])
        return screenline, items

    def _load_parse_screenline(self, screenline):
        assert screenline is not None
        ssplit = screenline.split(" ")

        ssplit_expect = ["Screen",None,"minimum",None,"x",None,"current",None,"x",None,"maximum",None,"x",None]
        assert all(a==b for (a,b) in zip(ssplit,ssplit_expect) if b is not None)

        self.state.virtual = self.state.Virtual(
                min = Size((int(ssplit[3]),int(ssplit[5][:-1]))),
                max = Size((int(ssplit[11]),int(ssplit[13])))
                )
        self.configuration.virtual = Size((int(ssplit[7]),int(ssplit[9][:-1])))

    #################### saving ####################

    def save_to_shellscript_string(self, template=None, additional=None):
        """Return a shellscript that will set the current configuration. Output can be parsed by load_from_string.

        You may specify a template, which must contain a %(xrandr)s parameter and optionally others, which will be filled from the additional dictionary."""
        if not template:
            template = self.DEFAULTTEMPLATE
        template = '\n'.join(template)+'\n'

        d = {'xrandr': "xrandr "+" ".join(self.configuration.commandlineargs())}
        if additional:
            d.update(additional)

        return template%d

    def save_to_x(self):
        self.check_configuration()
        self._run(*self.configuration.commandlineargs())

    def check_configuration(self):
        vmax = self.state.virtual.max

        for on in self.outputs:
            oc = self.configuration.outputs[on]
            #os = self.state.outputs[on]

            if not oc.active:
                continue

            # we trust users to know what they are doing (e.g. widget: will accept current mode, but not offer to change it lacking knowledge of alternatives)
            #if oc.rotation not in os.rotations:
            #    raise InadequateConfiguration("Rotation not allowed.")
            #if oc.mode not in os.modes:
            #    raise InadequateConfiguration("Mode not allowed.")

            x = oc.position[0] + oc.size[0]
            y = oc.position[1] + oc.size[1]

            if x > vmax[0] or y > vmax[1]:
                raise InadequateConfiguration(_("A part of an output is outside the virtual screen."))

            if oc.position[0] < 0 or oc.position[1] < 0:
                raise InadequateConfiguration(_("An output is outside the virtual screen."))

    #################### sub objects ####################

    class State(object):
        """Represents everything that can not be set by xrandr."""
        def __init__(self):
            self.outputs = {}

        def __repr__(self):
            return '<%s for %d Outputs, %d connected>'%(type(self).__name__, len(self.outputs), len([x for x in self.outputs.values() if x.connected]))

        class Virtual(object):
            def __init__(self, min, max):
                self.min = min
                self.max = max

        class Output(object):
            def __init__(self, name):
                self.name = name
                self.modes = []

            def __repr__(self):
                return '<%s %r (%d modes)>'%(type(self).__name__, self.name, len(self.modes))

    class Configuration(object):
        """Represents everything that can be set by xrand (and is therefore subject to saving and loading from files)"""
        def __init__(self):
            self.outputs = {}

        def __repr__(self):
            return '<%s for %d Outputs, %d active>'%(type(self).__name__, len(self.outputs), len([x for x in self.outputs.values() if x.active]))

        def commandlineargs(self):
            args = []
            for on,o in self.outputs.items():
                args.append("--output")
                args.append(on)
                if not o.active:
                    args.append("--off")
                else:
                    args.append("--mode")
                    args.append(str(o.mode))
                    args.append("--pos")
                    args.append(str(o.position))
                    args.append("--rotate")
                    args.append(o.rotation)
            return args

        class OutputConfiguration(object):
            def __init__(self, active, geometry, rotation):
                self.active = active
                if active:
                    self.position = geometry.position
                    self.rotation = rotation
                    if rotation.is_odd:
                        self.mode = Size(reversed(geometry.size))
                    else:
                        self.mode = geometry.size
            size = property(lambda self: Size(reversed(self.mode)) if self.rotation.is_odd else self.mode)
