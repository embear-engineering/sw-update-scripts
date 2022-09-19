#!/bin/bash

if [ "$1" == "" -o "$1" == "-h" ]; then
	echo -e "untar-image.sh [-h] image"
	echo -e "\tuntar a tar image output by Yocto"
	echo -e ""
	echo -e "positional arguments:"
	echo -e "\timage: The rootfs tar image which can be used as a base for new images"
	exit 0
fi

rm -rf rootfs
mkdir -p rootfs
fakeroot tar -xf $1 -C rootfs
