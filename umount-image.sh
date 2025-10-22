#!/bin/bash
set -e

source .env

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo $1 1>&2
}


infecho "Umounting image"
if sudo cryptsetup isLuks /dev/loop0p2; then
        umount /dev/mapper/imgfs_decrypted
    	echo -n "linux" | sudo cryptsetup luksClose imgfs_decrypted
else
    umount /dev/loop0p2
fi

losetup -d /dev/loop0

infecho "Deleting unused directories"
rmdir imgfs
