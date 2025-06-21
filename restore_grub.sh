#!/bin/bash
#autor: AgileSoul

if [ $EUID -ne 0 ]; then
    echo -e "\e[31mExiting...\e[0m \e[36mAre you root?\e[0m"
    exit 1
fi

clear

echo "Showing partitions names"
fdisk -l
sleep 0.5

read -p "Enter disk identifier" diskId
diskId=${diskId:-"nvme0n1"}
read -p "Enter EFI parition identifier" efiPartitionId
efiPartitionId=${efiPartitionId:-"nvme0n1p1"}
read -p "Enter partition identifier" partitionId
partitionId=${partitionId:-"nvme0n1p4"}

mount /dev/$partitionId /mnt
mkdir -p /mnt/boot/efi
mount /dev/$efiPartitionId /mnt/boot/efi
mount --rbind /dev /mnt/dev 
mount --rbind /dev/pts /mnt/dev/pts 
mount --rbind /proc /mnt/proc 
mount --rbind /sys /mnt/sys

chroot /mnt /bin/bash -c "grub-install --recheck /dev/$diskId && update-grub2"

