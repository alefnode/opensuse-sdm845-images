#!/bin/sh
set -e

source .env

MOUNTED_IMAGE_DIR="imgfs"
OFFSET=0

ROOTPART=$(grep -vE '^#' ${MOUNTED_IMAGE_DIR}/etc/fstab | grep -E '[[:space:]]/[[:space:]]' | awk '{ print $1; }')
ROOTPART=$(blkid -s PARTUUID -o value /dev/loop0p2)
echo "ROOTPART: PARTUUID=${ROOTPART}"
#KERNEL_VERSION=$(linux-version list)

case "${DEVICE}" in
    "oneplus6")
        DTB_VENDOR="oneplus"
        DTB_VARIANTS="enchilada fajita"
        ;;
    "pocof1")
        DTB_VENDOR="xiaomi"
        DTB_VARIANTS="beryllium-tianma beryllium-ebbg"
        ;;
    *)
        echo "ERROR: unsupported device ${DEVICE}"
        exit 1
        ;;
esac

kernel_version=$(ls ${MOUNTED_IMAGE_DIR}/usr/lib/modules/)
gzip -9 -k ${MOUNTED_IMAGE_DIR}/usr/lib/modules/${kernel_version}/Image

# Create a bootimg for each variant
for variant in ${DTB_VARIANTS}; do
    echo "Creating boot image for variant ${variant}"

    # Append DTB to kernel
    cat ${MOUNTED_IMAGE_DIR}/usr/lib/modules/${kernel_version}/Image.gz ${MOUNTED_IMAGE_DIR}/boot/dtb/qcom/sdm845-${DTB_VENDOR}-${variant}.dtb > /tmp/kernel-dtb

    # Create the bootimg as it's the only format recognized by the Android bootloader
    abootimg --create ./openSUSE-Tumbleweed-ARM-PHOSH-${DEVICE}${variant}.aarch64-$(date +"%Y.%m.%d").boot.img -c kerneladdr=0x8000 \
        -c ramdiskaddr=0x1000000 -c secondaddr=0x0 -c tagsaddr=0x100 -c pagesize=4096 \
        -c cmdline="root=LABEL=ROOT rootdelay=2 mobileroot=LABEL=ROOT loglevel=7 splash=silent console=ttyMSM0,115200 console=tty0 BOOT_IMAGE=/boot/Image luks" \
        -k /tmp/kernel-dtb -r ${MOUNTED_IMAGE_DIR}/boot/initrd-${kernel_version}
#	-c cmdline="root=${ROOTPART} rootdelay=2 mobileroot=${ROOTPART} loglevel=7 splash=silent console=ttyMSM0,115200 console=tty0 BOOT_IMAGE=/boot/Image" \
#        -k /tmp/kernel-dtb -r ${MOUNTED_IMAGE_DIR}/boot/initrd-${kernel_version}

    #mkbootimg --kernel /tmp/kernel-dtb --ramdisk ${initrd_file_path} --pagesize 4096 \
    #    --base 0x0 --kernel_offset 0x8000 --second_offset 0x0 --tags_offset 0x100 --ramdisk_offset 0x1000000 \
    #    --cmdline "BOOT_IMAGE=/boot/Image root=${ROOTPART} console=ttyMSM0,115200 loglevel=7" \
    #    --output openSUSE-Tumbleweed-ARM-PHOSH-${DEVICE}${variant}.aarch64.boot.img

done
