#!/bin/bash -vx

export PAGER=cat

DATE=$(date '+%s')
RELEASE=$(lsb_release --short --codename)
VIRTUALBOX_PKG=virtualbox-5.2
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

cat > /etc/apt/sources.list.d/virtualbox.list << EOF
# https://www.virtualbox.org/wiki/Linux_Downloads#Debian-basedLinuxdistributions
#	https://www.virtualbox.org/download/oracle_vbox_2016.asc
#	https://www.virtualbox.org/download/oracle_vbox.asc
deb https://download.virtualbox.org/virtualbox/debian ${RELEASE} contrib
EOF

wget -qc -O - 'https://www.virtualbox.org/download/oracle_vbox_2016.asc' | apt-key add -
wget -qc -O - 'https://www.virtualbox.org/download/oracle_vbox.asc' | apt-key add -

apt -y install apt-transport-https

apt update | grep -v '://'

apt search ${VIRTUALBOX_PKG}

apt -y install build-essential linux-headers-amd64 linux-headers-$(uname -r)
apt-mark auto linux-headers-$(uname -r)

apt -y install ${VIRTUALBOX_PKG}

w -hus | awk '{print $1}' | xargs -r -t -I {} adduser {} vboxusers

lsmod | grep vbox

systemctl list-units | grep vbox
systemctl list-unit-files | grep vbox
systemctl status vboxdrv vboxballoonctrl-service vboxautostart-service vboxweb-service

apt -y install virtualbox-ext-pack
