#!/bin/bash
#autor: AgileSoul

if [ $EUID -ne 0 ]; then
    echo -e "\e[31mExiting...\e[0m \e[36mAre you root?\e[0m"
    exit 1
fi

clear

echo "Showing partitions names"
fdisk -l
sleep 1

echo "Enter disk identifier"
read diskId
echo "Enter partition identifier"
read partitionId

mount /dev/$partitionId /mnt
mount --rbind /dev /mnt/dev 
mount --rbind /dev/pts /mnt/dev/pts 
mount --rbind /proc /mnt/proc 
mount --rbind /sys /mnt/sys

chroot /mnt
grub-install --recheck /dev/$diskId
update-grub2