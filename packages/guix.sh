#! /bin/bash
#
# Creates a binary installation of guix and guix-daemon
#
# Test with env -i bash --noprofile --norc

if [ "$1" == "--debug" ]; then
    DEBUG=-debug
fi

CWD=`pwd`
BIN=$(readlink -f ~/.guix-profile/bin/guix-daemon)
HASH=$(basename $(dirname $(dirname $BIN)))

TARBALL=`pwd`/$HASH$DEBUG-x86_64.tar
tar cvf $TARBALL -h -C ../gnu-install-bin install.sh installer/
./bin/list-shared-libs $BIN /gnu/store/060piiiz4nmb51jc3wk01bgikajrnfjd-guile-2.0.13/bin/guile /gnu/store/gss5fk5yh86m6qm7avvnq06nv99pb4jr-pkg-config-0.29/bin/pkg-config 2>/dev/null |xargs tar --exclude=/lib --exclude=/lib64 -rvf $TARBALL
tar rvf $TARBALL /gnu/store/$HASH/ /gnu/store/rvgmixpmsq5lqr9qflhkm70kg7a4rys2-bash-static-4.4.0/ /gnu/store/746qlam162asffk4pw2linx53c4zn4ar-bash-4.4.A/ /gnu/store/060piiiz4nmb51jc3wk01bgikajrnfjd-guile-2.0.13/ /gnu/store/gss5fk5yh86m6qm7avvnq06nv99pb4jr-pkg-config-0.29/ /gnu/store/qbkd8nlw6nyscrphdigdxz9kyfba0l97-libatomic-ops-7.4.2/

if [ ! -z $DEBUG ]; then
    cd $HOME/.guix-profile/lib/debug
    tar rvf $TARBALL -h gnu/store/*-ldc-*/bin/*
fi

exit 1
echo "Compressing..."
bzip2 -f $TARBALL
