#!/usr/bin/env bash
set -ex

mkdir -p build && cd build

if [[ -f Makefile ]];then
  make distclean
  rm -rf Makefile
fi

../configure --prefix=`pwd`/../install CFLAGS="-g3 -ggdb3 -gvariable-location-views -gdwarf-4 -grecord-gcc-switches -O1 -Werror"

make -j1 2>&1 | tee make-j1.log
# make -d --trace -j1 2>&1 | tee make-j1-debug.log
# make -j`nproc` 2>&1 | tee make-j`nproc`.log
# make -d --trace -j`nproc` 2>&1 | tee make-j`nproc`-debug.log
make install

# test
make test_elf_64
../test-driver --test-name `pwd`/x.log --log-file `pwd`/y.log --trs-file `pwd`/z.log `pwd`/test_elf_64

echo $?
