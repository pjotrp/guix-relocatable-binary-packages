#! /bin/bash
#
# Creates a binary installation of ldc2 and ldmd2
#
# Test with env -i bash --noprofile --norc

if [ "$1" == "--debug" ]; then
    DEBUG=-debug
fi

CWD=`pwd`
BIN=$(readlink -f ~/.guix-profile/bin/ldc2)
HASH=$(basename $(dirname $(dirname $BIN)))

TARBALL=`pwd`/$HASH$DEBUG-x86_64.tar
tar cvf $TARBALL -h -C ../gnu-install-bin install.sh installer/
./bin/list-shared-libs $BIN ~/.guix-profile/bin/ldmd2 2>/dev/null |xargs tar -rvf $TARBALL
tar rvf $TARBALL /gnu/store/$HASH/

if [ ! -z $DEBUG ]; then
    cd $HOME/.guix-profile/lib/debug
    tar rvf $TARBALL -h gnu/store/*-ldc-*/bin/*
fi

exit 1
echo "Compressing..."
bzip2 -f $TARBALL
