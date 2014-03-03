#!/bin/bash

#Paths
MOUNTPATH="/dev"
SCRIPTPATH=$(pwd)
IMAGENAME="core-image-x11-raspberrypi.rpi-sdimg"
SERVERNAME="yocto.tritech.se"

clear


read -p "Do you want to download new files to flash? (Y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "Log in to yocto server with username: "
	read SCPNAME

	REMOTEPATH="/home/$SCPNAME/poky/raspberrypi/tmp/deploy/images/raspberrypi"
	echo "Fetching files from" $REMOTEPATH

    	scp $SCPNAME@$SERVERNAME:$REMOTEPATH/$IMAGENAME $SCRIPTPATH/download/pi

echo "Download completed."
fi

cd $MOUNTPATH


# --- Find BOOTPATH
echo "ENTER NAME OF SDCARD (typically sdb or sdc, NOT sda!!!)"
echo ""
echo "IMPORTANT: the entire device will be overwritten. Make sure that you know the name of the sdcart device"
echo "AVALIABLE DEVICES:"
ls | grep sd
read BOOTNAME

BOOTPATH="/dev/$BOOTNAME"

# --- FLASHING

echo "flashing SDCARD (This takes a long time)"
sudo dd if=$SCRIPTPATH/download/pi/$IMAGENAME of=$BOOTPATH

echo "SYNCING SDCARD WRITES"
sudo sync

echo "UNMOUNTING SDCARD"
umount $BOOTPATH
echo "DONE"


