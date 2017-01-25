#! /bin/bash

BIN=$(readlink -f ~/.guix-profile/bin/sambamba)
HASH=$(basename $(dirname $(dirname $BIN)))

if [ "$1" == "--debug" ]; then
    DEBUG=-debug
fi

TARBALL=`pwd`/$HASH$DEBUG-x86_64.tar
tar cvf $TARBALL -h -C ../gnu-install-bin install.sh installer/
./bin/list-shared-libs ~/.guix-profile/bin/sambamba 2>/dev/null |xargs tar -rvf $TARBALL

if [ ! -z $DEBUG ]; then
    cd $HOME/.guix-profile/lib/debug
    tar rvf $TARBALL -h gnu/store/*sam*/bin/samba*
fi

echo "Compressing..."
bzip2 -f $TARBALL
