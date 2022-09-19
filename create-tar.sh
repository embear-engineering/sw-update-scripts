#!/bin/bash

if [ "$1" == "" -o "$1" == "-h" ]; then
	echo -e "create-tar.sh [-h] output base overlay1 overlay2 ..."
	echo -e ""
	echo -e "positional arguments:"
	echo -e "\toutput:   The generated tar.zst file"
	echo -e "\tbase:     The base rootfs"
	echo -e "\toverlayX: The overlays to apply to the base"
	exit 0
fi

if [ "$(id -u)" != "0" ]; then
	echo "Run as root or fakeroot"
	exit 1
fi

OUTPUT=$1
shift

rm -f $OUTPUT

rm -rf merge
mkdir merge

for directory in $@; do cp -f -P -r --link $directory/* merge/; done

tar -cC merge . | zstd > $OUTPUT
