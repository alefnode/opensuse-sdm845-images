#!/bin/sh
set -e

source .env

DEVICE=pocof1
IMAGE=$(basename -s .raw.xz ${OPENSUSE_RAW_FILE})

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo $1 1>&2
}


[ "$IMAGE" ] || exit 1

# On an Android device, we can't simply flash a full bootable image: we can only
# flash one partition at a time using fastboot.

# Extract rootfs partition
PART_OFFSET=`/sbin/fdisk -lu $IMAGE.raw | tail -1 | awk '{ print $2; }'` &&
infecho "Extracting rootfs @ $PART_OFFSET"
dd if=$IMAGE.raw of=$IMAGE.root.img bs=512 skip=$PART_OFFSET && rm $IMAGE.raw

# Filesystem images need to be converted to Android sparse images first
infecho "Converting rootfs to sparse image"
img2simg $IMAGE.root.img $IMAGE.root.simg && mv $IMAGE.root.simg $IMAGE.root.img
