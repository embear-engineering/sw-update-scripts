#!/bin/bash

if [ "$1" == "" -o "$1" == "-h" ]; then
	echo -e "create-swu.sh [-h] product-name version"
	echo -e "\tcreate a swupdate file with {product-name}_{version}.swu as output"
	echo -e ""
	echo -e "positional arguments:"
	echo -e "\tproduct-name: A product name which appears in the description and output file name"
	echo -e "\tversion:      The build version for the sw-description file and file name"
	exit 0
fi

PRODUCT_NAME="$1"
VERSION="$2"

cat << EOF > swupdate/sw-description
software =
{
	version = "$VERSION";
	description = "Embear Firmware Update for $PRODUCT_NAME";
	hardware-compatibility: [ "1.0", "1.2", "1.3"];
	files: (
		{
			filename = "image.tar.zst";
			type = "archive";
			compressed = "zstd";
			device = "/dev/update";
			filesystem = "ext4";
			path = "/";
		}
	);

	scripts: (
		{
			filename = "update.sh";
			type = "shellscript";
		}
	);
}
EOF

FILETYPE="tar.zst"
cd swupdate
FILES="sw-description image.$FILETYPE update.sh"
for i in $FILES;do
        echo $i; done | cpio -ov -H crc >  ${PRODUCT_NAME}_${VERSION}.swu
cd -
