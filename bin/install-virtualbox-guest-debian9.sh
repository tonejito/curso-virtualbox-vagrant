#!/bin/bash -vx

export PAGER=cat

DATE=$(date '+%s')
RELEASE=$(lsb_release --short --codename)
SOURCES_LIST=/etc/apt/sources.list

tracker daemon --kill
tracker daemon --terminate

grep -q "${RELEASE}-backports" ${SOURCES_LIST}

if [ $? -eq 0 ]
then
  cp -v ${SOURCES_LIST} ~/.sources.list.${DATE}
  sed -i -e "s/#\(\(.*\)${RELEASE}-backports main\(.*\)\)/\1/g" ${SOURCES_LIST}
else
  cat > /etc/apt/sources.list.d/backports.list << EOF
# ${RELEASE}-backports, previously on backports.debian.org
deb	http://httpredir.debian.org/debian/ ${RELEASE}-backports main contrib non-free 
deb-src	http://httpredir.debian.org/debian/ ${RELEASE}-backports main contrib non-free 
EOF
fi

apt update | grep -v '://'

systemctl status gdm.service &>/dev/null

if [ $? -eq 0 ]
then
  VIRTUALBOX_PKG=virtualbox-guest-x11
else
  VIRTUALBOX_PKG=virtualbox-guest-utils
fi

apt search ${VIRTUALBOX_PKG}

apt -y install build-essential linux-headers-amd64 linux-headers-$(uname -r)
apt-mark auto linux-headers-$(uname -r)

apt -y install ${VIRTUALBOX_PKG}

w -hus | awk '{print $1}' | xargs -r -t -I {} adduser {} vboxsf
systemctl list-units | grep virtualbox
systemctl list-unit-files | grep virtualbox
systemctl restart virtualbox-guest-utils
systemctl status virtualbox-guest-utils

lsmod | grep vbox
