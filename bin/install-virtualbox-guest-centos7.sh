#!/bin/bash -vx

#	https://wiki.centos.org/HowTos/Virtualization/VirtualBox/CentOSguest

export PAGER=cat

VIRTUALBOX_PKG=VirtualBox-5.2

yum -y install epel-release

yum -y groupinstall 'Development tools'

yum -y install dkms kernel-headers kernel-devel kernel-devel-$(uname -r)

echo "Insert Guest Additions ISO image and press any key..."
read

pushd .
#cd /run/media/*/VBOXADDITIONS*
umount /dev/sr0
mount /dev/sr0 /mnt
cd /mnt
/mnt/VBoxLinuxAdditions.run
umount /dev/sr0
popd

systemctl restart vboxadd
systemctl status  vboxadd

lsmod | grep vbox
