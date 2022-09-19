#!/usr/bin/bash

if [ "$1" == "" -o "$1" == "-h" ]; then
	echo -e "create-qt-image.sh [-h] output version base overlay1 overlay2 ..."
	echo -e "\tcreate an ostree image for qt-ota https://code.qt.io/cgit/qt/qtotaupdate.git/"
	echo -e ""
	echo -e "positional arguments:"
	echo -e "\toutput:   The output tar.zst image"
	echo -e "\tversion:  The version of the image which is used by qt-ostree"
	exit 0
fi


if [ "$(id -u)" != "0" ]; then
	echo "Run as root or fakeroot"
	exit 1
fi

OUTPUT=$1
shift

VERSION=$1
shift

rm -rf merge
mkdir merge

for directory in $@; do cp -f -P -r --link $directory/* merge/; done

# Remove unneeded files
rm -f merge/home/weston/.bashrc
rm -f merge/home/weston/.profile
rm -rf merge/opt/*

sed -i "s/\"version\": .*/\"version\": \"$VERSION\"/" version.json

echo "Convert merge dir to qtota"
test -d ostree-repo && FLAGS=--create-self-contained-package
./qt-ostree $FLAGS --sysroot-image-path merge/ --create-ota-sysroot --ota-json version.json --uboot-script boot.script

echo "Create zstd image"
# Ignore error regarding too many levels of symbolic links
tar -cC sysroot --zstd -f $OUTPUT . 2>/dev/null || true
