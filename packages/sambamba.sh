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
    cd $HOME/.guix-profile/lib/debug
    tar rvf $TARBALL -h gnu/store/*sam*/bin/sambamba.debug
    cd $CWD
    tar rvf $TARBALL /gnu/store/nkmjq0z2bhsfm8ii85xvdil24zd0h59k-sambamba-0.6.5-5a33d57-checkout /gnu/store/164pirrwiciv9msg67qk7223x9j23bp6-ldc-1.1.0-beta6 /gnu/store/ykzwykkvr2c80rw4l1qh3mvfdkl7jibi-bash-4.3.42 /gnu/store/0mkxmwcykgz7dknap50wn4nfhh0kl8j4-tzdata-2015g
fi

echo "Compressing..."
bzip2 -f $TARBALL
