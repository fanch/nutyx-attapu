export QTDIR=/usr/
if [ -d $QTDIR ]; then
export PATH=$QTDIR/bin:$PATH
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$QTDIR/lib/pkgconfig
fi
