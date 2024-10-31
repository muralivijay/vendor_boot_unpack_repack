# This script helps to  replace recovery ramdisk from vendor_boot image.
# Script by muralivijay@github
#!/bin/bash

# Define color variables
RED='\033[0;31m'
YELLOW='\033[1;33m'

# setup stock,twrp and out directory if not exits
if [ ! -d "stock/" ] && [ ! -d "twrp/" ] && [ ! -d "out/" ]; then
    echo  -e "${RED}Error: stock, twrp and out directories not found..\n"
    echo  -e "${YELLOW}..creating ..\n"
	mkdir -p stock/unpack
	mkdir -p twrp/unpack
	mkdir out
    echo -e  "..done..now copy your stock and twrp vendor_boot images into stock and twrp directory and execute the script again\n"
    exit 1
fi

# check vendor_boot.img
# Stock
echo -e "Checking stock vendor_boot.img...\n"
if [ ! -f "stock/stock-vb.img" ]; then
    echo  -e "${RED}Error: stock vendor_boot.img not found in stock folder. please add vendor_boot.img from ROM and rename it into 'stock-vb.img'.\n"
    exit 1
fi

# TWRP
echo -e "Checking TWRP vendor_boot.img...\n"
if [ ! -f "twrp/twrp-vb.img" ]; then
    echo -e "${RED}Error: TWRP vendor_boot.img not found in twrp folder. please compile it from source then add it into twrp folder with 'twrp-vb.img' named.\n"
    exit 1
fi

echo -e "Stock And TWRP vendor_boot image present great..!\n"
echo -e "Its Time to unpack and repack process..\n"

# Unpack stock vendor_boot.img
echo -e "Unpacking stock-vb.img...\n"
cd stock/unpack || exit
../../bin/magiskboot unpack ../stock-vb.img
cd ../../

# Unpack TWRP vendor_boot.img
echo -e "Unpacking twrp-vb.img...\n"
cd twrp/unpack || exit
../../bin/magiskboot unpack ../twrp-vb.img
cd ../../

# Replace vendor_ramdisk_recovery.cpio (TWRP > Stock) and repack
echo -e "Replacing vendor_ramdisk_recovery.cpio and repacking it into stock vendor_boot.img...\n"
mv twrp/unpack/vendor_ramdisk_recovery.cpio stock/unpack/
cd stock/unpack || exit
../../bin/magiskboot repack ../stock-vb.img ../../out/vendor_boot-new.img
cd ../../

echo -e "${YELLOW}Done !! Check Out directory and flash it via fastboot\n"
