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

git clone --filter=blob:none https://github.com/GNOME/libxml2
echo "Building libxml2..."
cd libxml2
git checkout v2.11.0
mkdir build
cd build
cmake .. -D BUILD_SHARED_LIBS=OFF -D LIBXML2_WITH_LZMA=OFF
make $JNUM
make $JNUM install

cd $DIR
cd ..
git submodule update --init --recursive
export CFLAGS=$(xml2-config --cflags)
export LIBS=$(xml2-config --libs)
make

echo "Done!"
