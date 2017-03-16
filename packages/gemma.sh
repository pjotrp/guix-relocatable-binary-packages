#! /bin/bash
#
# Test with env -i bash --noprofile --norc

if [ "$1" == "--debug" ]; then
    DEBUG=-debug
fi

BIN=$(readlink -f ~/.guix-profile/bin/gemma)
HASH=$(basename $(dirname $(dirname $BIN)))
CWD=`pwd`

TARBALL=$CWD/$HASH$DEBUG-x86_64.tar
tar cvf $TARBALL -h -C ../gnu-install-bin install.sh installer/
./bin/list-shared-libs $BIN|xargs tar -rvf $TARBALL

if [ -z $DEBUG ]; then
    echo "Compressing..."
    bzip2 -f $TARBALL
fi
