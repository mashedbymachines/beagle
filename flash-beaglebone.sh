#!/bin/bash

#Paths
BUILDPATH="/home/$LOGNAME/poky/build/tmp/deploy/images/beaglebone"
MOUNTPATH="/media/$LOGNAME"
SCRIPTPATH=$(pwd)


clear
cd $MOUNTPATH


# --- Find BOOTPATH
echo "ENTER NAME OF BOOT PARTITION. AVALIABLE MOUNTS:"
ls
read BOOTNAME

BOOTPATH="/media/$LOGNAME/$BOOTNAME"

if [ ! -d "$BOOTPATH" ]; then
  echo "$BOOTPATH does not exist. Aborting"
  exit 0
fi

echo -e "Boot path OK\n\n"


# --- Find ROOTPATH
echo "ENTER NAME OF ROOT PARTITION. AVALIABLE MOUNTS:"
ls
read ROOTNAME

ROOTPATH="/media/$LOGNAME/$ROOTNAME"

if [ ! -d "$ROOTPATH" ]; then
  echo "$ROOTPATH does not exist. Aborting"
  exit 0
fi

echo -e "Boot path OK\n\n"
cd $SCRIPTPATH
echo -e "----------------\n\n"
sudo echo ""

# --- FLASHING

echo "erasing BOOT"
sudo rm -rf  $BOOTPATH/*

echo "erasing FILESYSTEM"
sudo rm -rf  $ROOTPATH/*

echo "flashing BOOT"
sudo cp $BUILDPATH/MLO $BOOTPATH
sudo cp $BUILDPATH/u-boot.img $BOOTPATH
sudo cp $BUILDPATH/zImage $BOOTPATH
sudo cp uEnv.txt $BOOTPATH

sudo mkdir $BOOTPATH/dtbs
sudo cp $BUILDPATH/zImage-am335x-bone.dtb $BOOTPATH/dtbs/am335x-bone.dtb

echo "flashing FILESYSTEM"
sudo tar -x -C $ROOTPATH -f $BUILDPATH/core-image-minimal-beaglebone.tar.bz2
sudo tar -x -C $ROOTPATH -f $BUILDPATH/modules-beaglebone.tgz
sudo cp $BUILDPATH/zImage $ROOTPATH/boot

echo "SYNCING SDCARD WRITES"
sync

echo "UNMOUNTING SDCARD"
umount $BOOTPATH
umount $ROOTPATH
echo "DONE"


