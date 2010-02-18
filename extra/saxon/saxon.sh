<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
    <head>
       <title>
            Arch Linux Repositories
               - packages
                  - R&eacute;vision 51173
               - /saxon/repos/extra-any/saxon.sh
        </title>
        <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
        <meta http-equiv="generator" content="WebSVN 2.2.1" /> <!-- leave this for stats -->
        <link rel="stylesheet" href="http://www.archlinux.org/media/arch.css" />
        <link rel="stylesheet" href="/templates/arch/styles.css" />
        <link rel="icon" href="http://www.archlinux.org/media/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" href="http://www.archlinux.org/media/favicon.ico" type="image/x-icon" />
        <!--[if gte IE 5.5000]>
        <script type="text/javascript" src="/templates/arch/png.js"></script>
        <style type="text/css" media="screen">
        tbody tr td { padding:1px 0 }
        #wrap h2 { padding:10px 5px 0 5px; margin-bottom:-8px }
        </style>
        <![endif]-->
    <script type="text/javascript">
    //<![CDATA[
         function getPath()
         {
                return '';
         }

         function checkCB(chBox)
         {
            count = 0
            first = null
            f = chBox.form
            for (i = 0 ; i < f.elements.length ; i++)
            if (f.elements[i].type == 'checkbox' && f.elements[i].checked)
            {
               if (first == null && f.elements[i] != chBox)
                  first = f.elements[i]
               count += 1
            }

            if (count > 2)
            {
               first.checked = false
               count -= 1
            }
         }
    //]]>
    </script>
    <script type="text/javascript" src="/templates/arch/collapse.js"></script>
        
    </head>
    <body>
        <div id="head_container">
            <div id="title">
              <div id="logo"><h1 id="archtitle"><a href="http://www.archlinux.org" title="Arch Linux (Home)">Arch Linux</a></h1></div>
            </div>
            <div id="main_nav">

                <ul>
                    <li><a href="/download/">Download</a></li>
                    <li class="selected"><a href="/">Repositories</a></li>
                    <li><a href="http://aur.archlinux.org">AUR</a></li>
                    <li><a href="http://bugs.archlinux.org">Bugs</a></li>
                    <li><a href="http://wiki.archlinux.org">Wiki</a></li>
                    <li><a href="http://bbs.archlinux.org">Forums</a></li>
                    <li><a href="http://www.archlinux.org">Home</a></li>
                </ul>
            </div>
        </div>
        <div id="content">
<div id="select"><form action="/wsvn?" method="post" id="projectform"><div><input type="hidden" name="selectproj" value="1" /><input type="hidden" name="op" value="form" /><select name="repname" onchange="javascript:this.form.submit();"><option value="packages" selected="selected">packages</option><option value="community">community</option></select><span class="submit"><input type="submit" value="Go" /></span></div></form></div>
<h1><a href="/wsvn/?" title="D&eacute;p&ocirc;ts&nbsp;Subversion">D&eacute;p&ocirc;ts&nbsp;Subversion</a> <span><a href="/wsvn/packages?">packages</a></span></h1>

<h2 class="path" style="margin:0 2% 15px 2%;">[<a href="/wsvn/packages/?rev=0">/</a>] [<a href="/wsvn/packages/saxon/?rev=0">saxon/</a>] [<a href="/wsvn/packages/saxon/repos/?rev=0">repos/</a>] [<a href="/wsvn/packages/saxon/repos/extra-any/?rev=0">extra-any/</a>] [<b>saxon.sh</b>] - R&eacute;vision 51173</h2>
<p>
<span class="diff"><a href="/wsvn/packages/saxon/repos/extra-any/saxon.sh?op=diff&amp;rev=0">Diff&eacute;rence avec la pr&eacute;c&eacute;dente</a></span> &#124;
<span class="blame"><a href="/wsvn/packages/saxon/repos/extra-any/saxon.sh?op=blame&amp;rev=0">Responsabilit&eacute;</a></span> &#124;
<span class="compress"><a href="/wsvn/packages/saxon/repos/extra-any/saxon.sh?op=dl&amp;rev=0">Download</a></span> &#124;
<span class="log"><a href="/wsvn/packages/saxon/repos/extra-any/saxon.sh?op=log&amp;rev=0&amp;isdir=0">Afficher&nbsp;le&nbsp;Journal</a></span>
</p>
    <div class="listing">
<code><PRE>
</code><code><B><FONT COLOR="#5F9EA0">#!/bin/sh
</code><code></FONT></B><B><FONT COLOR="#BC8F8F">&quot;$JAVA_HOME/bin/java&quot;</FONT></B> -jar /usr/share/java/saxon/saxon9he.jar <B><FONT COLOR="#BC8F8F">&quot;$@&quot;</FONT></B>;
</code><code></PRE>
</code><code></code>    </div>
<p>
<span class="diff"><a href="/wsvn/packages/saxon/repos/extra-any/saxon.sh?op=diff&amp;rev=0">Diff&eacute;rence avec la pr&eacute;c&eacute;dente</a></span> &#124;
<span class="blame"><a href="/wsvn/packages/saxon/repos/extra-any/saxon.sh?op=blame&amp;rev=0">Responsabilit&eacute;</a></span> &#124;
<span class="compress"><a href="/wsvn/packages/saxon/repos/extra-any/saxon.sh?op=dl&amp;rev=0">Download</a></span> &#124;
<span class="log"><a href="/wsvn/packages/saxon/repos/extra-any/saxon.sh?op=log&amp;rev=0&amp;isdir=0">Afficher&nbsp;le&nbsp;Journal</a></span>
</p>
        </div>
        <div class="foot">
          Copyright &copy; 2002-2009 <a href="mailto:jvinet@zeroflux.org" title="contact Judd Vinet">Judd Vinet</a> and <a href="mailto:aaron@archlinux.org" title="contact Aaron Griffin">Aaron Griffin</a>.<br />
          The Arch Linux name and logo are recognized trademarks. Some rights
          reserved.<br />

          The registered trademark Linux® is used pursuant to a sublicense from LMI, the exclusive licensee of Linus Torvalds, owner of the mark on a world-wide basis.
        </div>
    </body>
</html>
