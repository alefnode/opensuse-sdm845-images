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

infecho "Uncompressing image to mount"

if test -f "$OPENSUSE_RAW_FILE"; then
    extension=$(basename $OPENSUSE_RAW_FILE | rev | cut -d'.' -f1 | rev)
    if [[ "$extension" == "xz" ]]; then
        xz -d ${OPENSUSE_RAW_FILE}
    fi
fi

infecho "Mounting the image to loop..."
losetup /dev/loop0 $( basename -s .xz ${OPENSUSE_RAW_FILE})
partprobe -s /dev/loop0

mkdir imgfs
if sudo cryptsetup isLuks /dev/loop0p2; then
    echo -n "linux" | sudo cryptsetup luksOpen /dev/loop0p2 imgfs_decrypted
    mount /dev/mapper/imgfs_decrypted imgfs
else
    mount /dev/loop0p2 imgfs
fi

#FIXME: We extract rootfs partition from RAW image to convert to sparse image, so we need to edit fstab
infecho "Change fstab to avoid EFI partition"
sed -i "/efi/d" imgfs/etc/fstab

