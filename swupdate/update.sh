#!/bin/sh

if [ $# -lt 1 ]; then
	exit 0;
fi

function get_current_root_device
{
	PARTUUID=$(cat /proc/cmdline | sed 's/root=PARTUUID=\([^ ]*\).*/\1/')
	CURRENT_ROOT=$(readlink -f /dev/disk/by-partuuid/$PARTUUID)
}

function get_update_part
{
	CURRENT_PART="${CURRENT_ROOT: -1}"
	if [ $CURRENT_PART = "1" ]; then
		UPDATE_PART="2";
	else
		UPDATE_PART="1";
	fi
}

function get_update_device
{
	UPDATE_ROOT=${CURRENT_ROOT%?}${UPDATE_PART}
}

function format_update_device
{
	umount -q $UPDATE_ROOT
	mkfs.ext4 -q $UPDATE_ROOT -L RFS${UPDATE_PART} -E nodiscard
}

if [ $1 == "preinst" ]; then
	# get the current root device
	get_current_root_device

	# get the device to be updated
	get_update_part
	get_update_device

	# format the device to be updated
	format_update_device

	# create a symlink for the update process
	ln -sf $UPDATE_ROOT /dev/update
fi

if [ $1 == "postinst" ]; then
	get_current_root_device

	get_update_part

	mmcdev=${CURRENT_ROOT::-2}

	# eMMC needs to have reliable write on
	parted $mmcdev set $UPDATE_PART boot on &> /dev/null
	parted $mmcdev set $CURRENT_PART boot off &> /dev/null
fi
