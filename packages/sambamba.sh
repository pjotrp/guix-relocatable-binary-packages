#! /bin/bash

BIN=$(readlink -f ~/.guix-profile/bin/sambamba)
HASH=$(basename $(dirname $(dirname $BIN)))
CWD=`pwd`

if [ "$1" == "--debug" ]; then
    DEBUG=-debug
fi

TARBALL=$CWD/$HASH$DEBUG-x86_64.tar
tar cvf $TARBALL -h -C ../gnu-install-bin install.sh installer/
./bin/list-shared-libs ~/.guix-profile/bin/sambamba|xargs tar -rvf $TARBALL

if [ ! -z $DEBUG ]; then
    This version creates a debug dir, but that is maybe not the best idea - need
    to test with a working build and check whether the binary contains a route to
    the debug symbols. Also the sources need to be loaded somehow.
    TDIR=`mktemp --directory`
    echo $TDIR
    cd $HOME/.guix-profile/lib/debug
    # tar rvf $TARBALL -h gnu/store/*sam*/bin/sambamba.debug
    DEBUG_PATH=$(dirname $(dirname gnu/store/*sam*/bin/sambamba.debug))
    mkdir $TDIR/debug/gnu/store -p
    cp -vau $DEBUG_PATH $TDIR/debug/gnu/store
    mkdir $TDIR/source -p
    cp -vau /gnu/store/nkmjq0z2bhsfm8ii85xvdil24zd0h59k-sambamba-0.6.5-5a33d57-checkout $TDIR/source
    cd $TDIR
    tar rvf $TARBALL -h .
    cd $CWD
    tar rvf $TARBALL /gnu/store/164pirrwiciv9msg67qk7223x9j23bp6-ldc-1.1.0-beta6 /gnu/store/ykzwykkvr2c80rw4l1qh3mvfdkl7jibi-bash-4.3.42 /gnu/store/0mkxmwcykgz7dknap50wn4nfhh0kl8j4-tzdata-2015g
fi

echo "Compressing..."
bzip2 -f $TARBALL
