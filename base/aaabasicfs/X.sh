export GNOME_PREFIX=/usr
export GNOME_LIBCONFIG_PATH=/usr/lib:$GNOME_PREFIX/lib
export LIBGLADE_MODULE_PATH=$GNOME_PREFIX/lib/libglade/2.0
export QTDIR=/opt/qt
export KDE3_PREFIX=/opt/kde3
export KDE_PREFIX=/opt/kde
export KDEDIR=$KDE_PREFIX
export KDE3DIR=$KDE3_PREFIX
export MANPATH=$MANPATH:$GNOME_PREFIX/man:$KDEDIR/man:$KDE3DIR/man
export PATH=$PATH:$GNOME_PREFIX/bin:$KDE_PREFIX/bin:$KDE3_PREFIX/bin
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$GNOME_PREFIX/lib/pkgconfig:\
$GNOME_PREFIX/share/pkgconfig:$KDE3_PREFIX/lib/pkgconfig:/opt/qt/lib/pkgconfig
export INFOPATH=/usr/share/info:$GNOME_PREFIX/share/info:$KDE_PREFIX/share/info:$KDE3_PREFIX/share/info
export PYTHONPATH=/usr/lib/python2.5/site-packages:\
$GNOME_PREFIX/lib/python2.5/site-packages:\
$GNOME_PREFIX/lib/python2.5/site-packages/GMenuSimpleEditor
if [ -x /usr/X11R6/bin/X ]; then
 pathappend /usr/X11R6/bin
 XDG_DATA_DIRS=/usr/share:$GNOME_PREFIX/share:$KDE_PREFIX/share:$KDE3_PREFIX/share:/usr/local/share
 XDG_CONFIG_DIRS=/etc/gnome/xdg:/etc/kde/xdg:/etc/kde3/xdg:/etc/xdg
 export XDG_DATA_DIRS XDG_CONFIG_DIRS
	
fi
if [ -d /usr/X11R6/lib/pkgconfig ] ; then
        pathappend /usr/X11R6/lib/pkgconfig PKG_CONFIG_PATH
fi
XORG_PREFIX="/usr"
XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --mandir=$XORG_PREFIX/share/man --localstatedir=/var"
export XORG_PREFIX XORG_CONFIG
