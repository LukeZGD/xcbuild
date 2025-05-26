#!/bin/bash

set -e
export JNUM="-j$(nproc)"

rm -rf tmp
mkdir tmp 2>/dev/null
cd tmp

export DIR=$(pwd)
echo "Setting up build location and permissions"
sudo chown -R $USER:$USER $DIR
sudo chown -R $USER:$USER /usr/local

git clone --filter=blob:none https://github.com/madler/zlib
git clone --filter=blob:none https://github.com/GNOME/libxml2

echo "Building zlib..."
cd $DIR/zlib
./configure --static
make $JNUM install LDFLAGS="-all-static"

echo "Building libxml2..."
cd $DIR/libxml2
git checkout v2.11.0
mkdir build
cd build
cmake .. -D BUILD_SHARED_LIBS=OFF -D LIBXML2_WITH_LZMA=OFF -D LIBXML2_WITH_ZLIB=OFF
make $JNUM
make $JNUM install

echo "Building xcbuild..."
cd $DIR/..
git submodule update --init --recursive
make

echo "Done!"
