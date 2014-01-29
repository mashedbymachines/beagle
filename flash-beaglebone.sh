clear

echo "erasing BOOT"
rm -rf  /media/alexander/BEAGBOOT1/*

echo "erasing FILESYSTEM"
rm -rf  /media/alexander/beagroot1/*

echo "flashing BOOT"
cd ~/poky/build/tmp/deploy/images/beaglebone
cp MLO /media/alexander/BEAGBOOT1
cp u-boot.img /media/alexander/BEAGBOOT1
cp zImage /media/alexander/BEAGBOOT1
cp uEnv.txt /media/alexander/BEAGBOOT1

mkdir /media/alexander/BEAGBOOT1/dtbs
cp zImage-am335x-bone.dtb /media/alexander/BEAGBOOT1/dtbs/am335x-bone.dtb


echo "flashing FILESYSTEM"
cd ~/poky/build/tmp/deploy/images/beaglebone
tar -x -C /media/alexander/beagroot1 -f core-image-minimal-beaglebone.tar.bz2
tar -x -C /media/alexander/beagroot1 -f modules-beaglebone.tgz
cp zImage /media/alexander/beagroot1/boot

echo "SYNCING"
sync

echo "UNMOUNTING"
umount /media/alexander/BEAGBOOT1
umount /media/alexander/beagroot1
umount /media/alexander/beagroot2
echo "DONE"


