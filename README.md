# Stripts to generate IMG for SDM845 Phones

# How to use it

1. Configure vars in .env file
   * `DEVICE`: one of `oneplus6`, `pocof1`, `shift6mq`
   * `DESKTOP`: one of `PHOSH` (Phosh) or `PLAMO` (Plamo Mobile) - both are published by the openSUSE SDM845 repo
2. Execute "sudo bash all.sh"

This will generate bootimg and rootfs IMG files to flash it via fastboot

Put your device in fastboot mode, and execute (PHOSH shown, adjust the name to your `DESKTOP`):

   * fastboot flash boot openSUSE-Tumbleweed-ARM-PHOSH-<device><variant>.aarch64.boot.img
   
   * fastboot -S 100M flash userdata openSUSE-Tumbleweed-ARM-PHOSH-<device>.aarch64.root.img
   
   * fastboot erase dtbo
   

