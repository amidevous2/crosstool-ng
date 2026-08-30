#!/bin/bash
export LANG=fr_FR.UTF-8
export LANGUAGE=fr_FR
sudo yum -y install @development wget zlib-devel glibc.i686 glibc-devel glibc-devel.i686 glibc-headers texinfo ncurses-devel gperf
sudo yum -y install gcc-gnat gcc-objc gcc-objc++ p7zip p7zip-plugins help2man
PREFIX="$HOME/.local"
SRC="$HOME/src"
if [ "$(uname -m)" = "x86_64" ]; then
    PREFIXLIBDIR=$PREFIX/lib64
    LIBDIR=lib64
    LIBDIR2=lib
else
    PREFIXLIBDIR=$PREFIX/lib
    LIBDIR=lib
    LIBDIR2=lib
fi
mkdir -p "$PREFIX"
mkdir -p "$PREFIX/bin"
mkdir -p "$PREFIXLIBDIR"
mkdir -p "$PREFIX/include"
mkdir -p "$PREFIX/share"
mkdir -p "$PREFIX/etc"
mkdir -p "$SRC"
cd "$SRC"
rm -rf $SRC/crosstool-ng "$HOME/ctng-$(uname -m)" $HOME/ct-ng $PREFIX $HOME/.local $HOME/gcc-4.4.7*
git clone --branch 1.15 https://github.com/crosstool-ng/crosstool-ng.git
cd $SRC/crosstool-ng
wget https://raw.githubusercontent.com/amidevous2/crosstool-ng/refs/heads/install/crosstools-ng-1.15.3-gcc-4.4.7.patch -O amidevous2-crosstool-ng-1.15.3.nopatch.patch
patch -p1 < amidevous2-crosstool-ng-1.15.3.nopatch.patch
chmod +x configure
./configure --prefix="$HOME/ct-ng"
make
make install
export PATH="$HOME/ct-ng/bin:$PATH"
mkdir -p "$HOME/ctng-$(uname -m)"
cd "$HOME/ctng-$(uname -m)"
chmod +x configure
./configure --prefix="$HOME/ct-ng"
make
make install
export PATH="$HOME/ct-ng/bin:$PATH"
mkdir -p "$HOME/ctng-$(uname -m)"
cd "$HOME/ctng-$(uname -m)"
wget https://raw.githubusercontent.com/amidevous2/crosstool-ng/refs/heads/install/config-centos-6-gcc-4.4.7-i686 -O .config-i686
wget https://raw.githubusercontent.com/amidevous2/crosstool-ng/refs/heads/install/config-centos-6-gcc-4.4.7-x86_64-multilib -O .config-x86_64
cp .config-$(uname -m) .config
ct-ng build
if [[ -f "$HOME/.local/gcc32/i686-unknown-linux-gnu/sysroot/lib/ld-2.12.2.so" ]]; then
7z a -t7z -y -mx9 -mmt -v26214400 $HOME/gcc-4.4.7-i686.7z $HOME/.local/gcc32-4.4.7-i686
fi
if [[ -f "$HOME/.local/gcc64/x86_64-unknown-linux-gnu/sysroot/lib/ld-2.12.2.so" ]]; then
7z a -t7z -y -mx9 -mmt -v26214400 $HOME/gcc-4.4.7-multilib-x86_64.7z $HOME/.local/gcc64-multilib-4.4.7
fi
