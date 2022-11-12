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
umount /dev/loop1p2 || true
losetup -d /dev/loop1 || true

infecho "Deleting unused directories"
rmdir imgfs || true
