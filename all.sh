#!bin/bash
set -e

source .env 

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo $1 1>&2
}


infecho "Downloading image"

bash download-image.sh

infecho "Umount loop device"

bash umount-image.sh

infecho "Mounting the image"

bash mount-image.sh

infecho "Creating Boot Image"

bash bootloader.sh 

infecho "Cleaning all temporal files and dirs"

bash umount-image.sh

infecho "Creating RootFS Image"

bash extract-rootfs.sh

infecho "Now you can install in your device"
infecho "Put your device in fastboot mode, and execute:"
infecho "  fastboot flash boot openSUSE-Tumbleweed-ARM-PHOSH-<device><variant>.aarch64.boot.img"
infecho "  fastboot -S 100M flash userdata openSUSE-Tumbleweed-ARM-PHOSH-<device>.aarch64.root.img"
infecho "  fastboot erase dtbo"
