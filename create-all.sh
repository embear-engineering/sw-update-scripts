#!/bin/sh

# Fetch initial image
test -e embear-initial.tar.zst || (wget https://files.embear.ch/embear-initial.tar.zst && mkdir -p rootfs && tar -xf embear-initial.tar.zst -C rootfs)

# Create initial version without anything installed
fakeroot ./create-tar.sh embear-initial.tar.zst rootfs overlay_base
cp -l -f embear-initial.tar.zst swupdate/image.tar.zst
./create-swu.sh embear-initial 0.0.0

# Create version including swupdate
fakeroot ./create-tar.sh embear-image.tar.zst rootfs overlay_base overlay_swupdate
cp -l -f embear-image.tar.zst swupdate/image.tar.zst
./create-swu.sh embear-image 2.0.0

# Create version including qtota
fakeroot ./create-qt-image.sh embear-qtota.tar.zst 3.0.0 rootfs overlay_base overlay_qtota
cp -l -f embear-qtota.tar.zst swupdate/image.tar.zst
./create-swu.sh embear-qtota 3.0.0

# Create version with qtota and a different version
fakeroot ./create-qt-image.sh embear-qtota.tar.zst 4.0.0 rootfs overlay_base overlay_qtota

echo "The files are located under swupdate:"
find swupdate/ -name "*.swu"
