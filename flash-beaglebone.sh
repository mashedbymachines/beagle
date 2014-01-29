clear

echo "erasing BOOT"
cd /media/alexander/BEAGBOOT
rm -rf *

echo "erasing FILESYSTEM"
cd /media/alexander/beagroot1
rm -rf *

echo "flashing BOOT"
cd ~/poky/build/tmp/deploy/images/beaglebone
cp MLO /media/alexander/BEAGBOOT
cp u-boot.img /media/alexander/BEAGBOOT
cp zImage /media/alexander/BEAGBOOT
mkdir dtbs
cp zImage-am335x-bone.dtb /media/alexander/BEAGBOOT/dtbs/am335x-bone.dtb
cp uEnv.txt /media/alexander/BEAGBOOT

echo "flashing FILESYSTEM"
cd ~/poky/build/tmp/deploy/images/beaglebone
tar -x -C /media/alexander/beagroot1 -f core-image-minimal-beaglebone.tar.bz2
tar -x -C /media/alexander/beagroot1 -f modules-beaglebone.tgz
#cp zImage /media/alexander/beagroot1/boot

echo "SYNCING"
sync

echo "UNMOUNTING"
umount /media/alexander/BEAGBOOT
umount /media/alexander/beagroot1
umount /media/alexander/beagroot2
echo "DONE"


