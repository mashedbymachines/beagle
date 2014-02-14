#!/bin/bash

#Paths
BUILDPATH="/home/$LOGNAME/poky/build/tmp/deploy/images/beaglebone"
MOUNTPATH="/media/$LOGNAME"
SCRIPTPATH=$(pwd)
IMAGENAME="core-image-x11-beaglebone.tar.gz"
SERVERNAME="yocto"

clear
echo "Log in to yocto server with username: "
read SCPNAME

REMOTEPATH="/home/$SCPNAME/poky/build/tmp/deploy/images/beaglebone"

scp $SCPNAME@$SERVERNAME:"$REMOTEPATH/$IMAGENAME $REMOTEPATH/zImage-am335x-bone.dtb  $REMOTEPATH/modules-beaglebone.tgz  $REMOTEPATH/MLO  $REMOTEPATH/zImage $REMOTEPATH/u-boot.img" $SCRIPTPATH/download

echo "Download completed."


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
sudo cp $SCRIPTPATH/download/MLO $BOOTPATH
sudo cp $SCRIPTPATH/download/u-boot.img $BOOTPATH
sudo cp $SCRIPTPATH/download/zImage $BOOTPATH
sudo cp uEnv.txt $BOOTPATH

sudo mkdir $SCRIPTPATH/download/dtbs
sudo cp $SCRIPTPATH/download/zImage-am335x-bone.dtb $BOOTPATH/dtbs/am335x-bone.dtb

echo "flashing FILESYSTEM"
sudo tar -x -C $ROOTPATH -f $SCRIPTPATH/download/$IMAGENAME
sudo tar -x -C $ROOTPATH -f $SCRIPTPATH/download/modules-beaglebone.tgz
sudo cp $SCRIPTPATH/download/zImage $ROOTPATH/boot

echo "SYNCING SDCARD WRITES"
sudo sync

echo "UNMOUNTING SDCARD"
umount $BOOTPATH
umount $ROOTPATH
echo "DONE"


