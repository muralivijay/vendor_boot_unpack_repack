# This script helps to  replace recovery ramdisk from vendor_boot image.
# Script by muralivijay@github
#!/bin/bash

# Define color variables
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# setup stock,twrp and out directory if not exits
if [ ! -d "stock/" ] && [ ! -d "twrp/" ] && [ ! -d "out/" ]; then
    echo  -e "${RED}Error: stock, twrp and out directories not found..\n"
    echo  -e "${YELLOW}..creating ..${RESET}\n"
	mkdir -p stock/unpack
	mkdir -p twrp/unpack
	mkdir out
    echo -e  "${YELLOW}..done..now copy your stock and twrp vendor_boot images into stock and twrp directory and execute the script again${RESET}\n"
    exit 1
fi

# check vendor_boot.img
# Stock
echo -e "${YELLOW}Checking stock vendor_boot.img...${RESET}\n"
if [ ! -f "stock/stock-vb.img" ]; then
    echo  -e "${RED}Error: stock vendor_boot.img not found in stock folder. please add vendor_boot.img from ROM and rename it into 'stock-vb.img'.\n"
    exit 1
fi

# TWRP
echo -e "${YELLOW}Checking TWRP vendor_boot.img...${RESET}\n"
if [ ! -f "twrp/twrp-vb.img" ]; then
    echo -e "${RED}Error: TWRP vendor_boot.img not found in twrp folder. please compile it from source then add it into twrp folder with 'twrp-vb.img' named.\n"
    exit 1
fi

echo -e "${YELLOW}Stock And TWRP vendor_boot image present great..!${RESET}\n"
echo -e "${YELLOW}Its Time to unpack and repack process..${RESET}\n"

# Unpack stock vendor_boot.img
echo -e "${YELLOW}Unpacking stock-vb.img...${RESET}\n"
cd stock/unpack || exit
../../bin/magiskboot unpack ../stock-vb.img
cd ../../

# Unpack TWRP vendor_boot.img
echo -e "${YELLOW}Unpacking twrp-vb.img...${RESET}\n"
cd twrp/unpack || exit
../../bin/magiskboot unpack ../twrp-vb.img
cd ../../

# Replace vendor_ramdisk_recovery.cpio (TWRP > Stock) and repack
echo -e "${YELLOW}Replacing vendor_ramdisk_recovery.cpio and repacking it into stock vendor_boot.img...\n"
mv twrp/unpack/vendor_ramdisk_recovery.cpio stock/unpack/
cd stock/unpack || exit
# Prompt the user for confirmation to proceed edit recovery ramdisk
echo -e "Do you want edit recovery ramdisk? (y/n):${RESET}"
read -p "" confirm

# Check if the user answered yes/no
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    mkdir extracted_vendor_ramdisk_recovery
    cd extracted_vendor_ramdisk_recovery
    cpio -idmv < ../vendor_ramdisk_recovery.cpio
    echo -e "${YELLOW}please check extracted_vendor_ramdisk_recovery directory and modify your changes. now opening sub bash shell for edit purpose...\n"
    # Wait for the user to edit
        echo "Type 'exit' when you are done to continue repack..."
        bash  # Opens a new shell for editing
    echo -e "${YELLOW}Repacking recovery ramdisk ${RESET}..\n"
    find . | cpio -o -H newc > ../modified_vendor_ramdisk_recovery.cpio
    cd  ../
    rm -rf vendor_ramdisk_recovery.cpio
    rm -rf extracted_vendor_ramdisk_recovery
    mv modified_vendor_ramdisk_recovery.cpio vendor_ramdisk_recovery.cpio
else
    echo -e "${YELLOW}Ok skipped. edit recovery ramdisk. now repacking..${RESET}\n"
fi

# Final Repack
../../bin/magiskboot repack ../stock-vb.img ../../out/vendor_boot-new.img
cd ../../

echo -e "${YELLOW}Done !! Check Out directory and flash it via fastboot${RESET}\n"
