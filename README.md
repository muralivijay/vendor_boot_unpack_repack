# Vendor_boot unpack and repack Tool for Recovery

This script helps to replace custom Recovery ramdisk from custom vendor_boot into stock vendor_boot.please make sure check 
your device supports recovery ramdisk on vendor_boot before use this script.

# Requirements
- Recovery ramdisk support on vendor_boot
- stock vendor_boot.img (from which rom are you using.ex: crdroid,lineage.)
- twrp vendor_boot.img (if you don,t have vendor_boot.img from twrp then compile it first).
- Linux PC

# How to use 
First clone it
```
git clone https://github.com/muralivijay/vendor_boot_unpack_repack.git
```
- then execute "replace_recovery.sh" script. by following
```
./replace_recovery.sh
```
- if you execute script for first time .it will create stock, twrp and our directory for vendor_boot extract setup. then it will exit.
- Next Rename your device stock vendor_boot.img into "stock-vb.img" . and copy it into stock folder.
- Rename twrp vendor_boot.img into "twrp-vb.img". and copy it into twrp folder.
- again execute the "replace_recovery.sh".
- Wait for few seconds it will replace custom recovery ramdisk into stock recovery ramdisk.
- after script finished . check "out" directory and flash it via fastboot.


# Credits
Magisk - for magiskboot
