#! /bin/bash
#
# Creates a binary installation of ruby with nokogiri
#
# Test with env -i bash --noprofile --norc
#
# Point the GEM_PATH to include nokogiri:
#
#   export GEM_PATH=/gnu/tmp/ruby-test/ruby-nokogiri-1.6.7.2-cgz3dmbmmddx9m722px04n1m/lib/ruby/gems/2.3.0/

if [ "$1" == "--debug" ]; then
    DEBUG=-debug
fi

CWD=`pwd`
BIN=$(readlink -f ~/.guix-profile/bin/ruby)
NOKOGIRI=/gnu/store/cgz3dmbmmddx9m722px04n1mjvj5phzf-ruby-nokogiri-1.6.7.2/lib/ruby/gems/2.3.0/gems/nokogiri-1.6.7.2/lib/nokogiri/nokogiri.so
HASH=$(basename $(dirname $(dirname $BIN)))

TARBALL=`pwd`/$HASH$DEBUG-x86_64.tar
tar cvf $TARBALL -h -C ../gnu-install-bin install.sh installer/
./bin/list-shared-libs $BIN $NOKOGIRI 2>/dev/null |xargs tar -rvf $TARBALL
tar rvf $TARBALL /gnu/store/$HASH/ /gnu/store/cgz3dmbmmddx9m722px04n1mjvj5phzf-ruby-nokogiri-1.6.7.2/ $(readlink ~/.guix-profile/lib/ruby/gems/2.3.0/gems/mini_portile2-2.1.0)

if [ ! -z $DEBUG ]; then
    cd $HOME/.guix-profile/lib/debug
    tar rvf $TARBALL -h gnu/store/*-ruby-*/bin/*
fi

exit 1
echo "Compressing..."
bzip2 -f $TARBALL
