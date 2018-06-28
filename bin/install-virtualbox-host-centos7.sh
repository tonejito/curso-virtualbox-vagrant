#!/bin/bash -vx

#	https://www.virtualbox.org/wiki/Linux_Downloads#RPM-basedLinuxdistributions

export PAGER=cat

VIRTUALBOX_PKG=VirtualBox-5.2

yum -y install epel-release

wget -cq https://www.virtualbox.org/download/oracle_vbox.asc
rpm --import oracle_vbox.asc
wget -cq https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo
cp -v virtualbox.repo /etc/yum.repos.d/

yum -y makecache fast

yum search ${VIRTUALBOX_PKG}

yum -y groupinstall 'Development tools'

yum -y install dkms kernel-headers kernel-devel kernel-devel-$(uname -r)

yum -y install ${VIRTUALBOX_PKG}

systemctl restart vboxdrv
systemctl status  vboxdrv

lsmod | grep vbox

#	https://unix.stackexchange.com/a/289686
