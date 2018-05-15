#!/bin/sh
set -e
#QuickArchInstallSrcip
printf '\e[1;34m%-6s\e[m' "###################### Arch Quick Install Script ########################"
printf "\n"
printf '\e[1;34m%-6s\e[m' "######Use GPT in cgdisk and size the following partitions as shown#######"
printf "\n"
printf '\e[1;34m%-6s\e[m' "### /dev/sda1    EF02    BIOS boot partition             +2MiB        ###"
printf "\n"
printf '\e[1;34m%-6s\e[m' "### /dev/sda2    8300            boot                    +500MiB      ###"
printf "\n"
printf '\e[1;34m%-6s\e[m' "### /dev/sda3    8300            root                    Rest of it   ###"
printf "\n"
printf '\e[1;34m%-6s\e[m' "#########################################################################"
printf "\n"
read -p "Press any key to continue"
cgdisk /dev/sda
mkfs.ext4 -L boot /dev/sda2
mkfs.ext4 -L root /dev/sda3
mount /dev/sda3 /mnt
mkdir /mnt/boot 
mount /dev/sda2 /mnt/boot
pacman -Sy --force
pacstrap -i /mnt base base-devel --force --noconfirm
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt sed -ie "168 s/^#//" /etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt echo LANG=en_US.UTF-8 > /etc/locale.conf
arch-chroot /mnt ls /usr/share/zoneinfo
arch-chroot /mnt ln -s /usr/share/zoneinfo/America/New_York > /etc/localtime
arch-chroot /mnt hwclock --systohc --utc
arch-chroot /mnt LANG=en_US.UTF-8
printf "\n\n"
printf '\e[1;34m%-6s\e[m' "What do you want your hostname to be: "
read HN
echo ${HN} > /mnt/etc/hostname
printf "\n\n"
printf '\e[1;34m%-6s\e[m' "Gonna set up dhcp for your nic, I'll print out your cards..."
printf "\n\n"
ip addr
printf "\n\n"
printf '\e[1;34m%-6s\e[m' "enter the nic you want to use dhcp on: "
read nic
arch-chroot /mnt systemctl enable dhcpcd@${nic}.service
arch-chroot /mnt pacman -S sudo bash-completion --noconfirm
arch-chroot /mnt mkinitcpio -p linux
arch-chroot /mnt pacman -S grub --force --noconfirm
arch-chroot /mnt grub-install /dev/sda
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
printf "\n\n"
printf '\e[1;34m%-6s\e[m' "Gonna run passwd for you. You can add a user later..."
printf "\n"
arch-chroot /mnt passwd
umount -R /mnt
printf "\n\n"
printf '\e[1;34m%-6s\e[m' "All Done, you can reboot now. Already did Unmount for you"
printf "\n\n"
