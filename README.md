# Stripts to generate IMG for SDM845 Phones

# How to use it

1. Configure vars in .env file
2. Execute "sudo bash all.sh"

This will generate bootimg and rootfs IMG files to flash it via fastboot

Put your device in fastboot mode, and execute:
   fastboot flash boot openSUSE-Tumbleweed-ARM-PHOSH-<device><variant>.aarch64.boot.img
   fastboot -S 100M flash userdata openSUSE-Tumbleweed-ARM-PHOSH-<device>.aarch64.root.img
   fastboot erase dtbo

