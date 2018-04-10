#!/bin/sh

/debootstrap/debootstrap --second-stage

for f in $(busybox --list-full | grep -v readlink); do [ -e $f ] || ln -s /bin/busybox $f; done

cat > etc/apt/sources.list << EOF
deb http://mirrors.ustc.edu.cn/debian/ jessie main contrib non-free
#deb http://mirrors.ustc.edu.cn/debian/ jessie-backports main contrib non-free
#deb http://mirrors.ustc.edu.cn/debian/ jessie-proposed-updates main contrib non-free
deb http://mirrors.ustc.edu.cn/debian-security/ jessie/updates main contrib non-free
EOF

cat > etc/default/locale << EOF
LC_ALL="en_US.UTF8"
LANG="en_US.UTF-8"
LANGUAGE="en_US:en"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
EOF

cat >> etc/bash.bashrc << EOF
alias df='df -Th'
alias free='free -h'
alias ls='ls -hF --color=auto'
alias ll='ls -AlhF --color=auto'
EOF

apt-get update -qq && apt-get -y upgrade
apt-get -y install net-tools
apt-get -y install ifupdown

cat >> etc/network/interfaces << EOF
auto lo eth0
iface lo inet loopback
iface eth0 inet dhcp
EOF

ln -sf /usr/share/zoneinfo/Asia/Shanghai etc/localtime
echo "Asia/Shanghai" > etc/timezone
echo "RK3066" > etc/hostname
echo "T0:123:respawn:/sbin/getty 115200 ttyS2" >> etc/inittab
sed -i '1 i\server ntp1.aliyun.com prefer' etc/ntp.conf
sed -i 's/id:2:initdefault:/id:3:initdefault:/' etc/inittab
sed -i '/^PermitRootLogin/cPermitRootLogin yes' etc/ssh/sshd_config
sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' etc/locale.gen
locale-gen en_US.UTF-8

echo "root:admin" | chpasswd

apt-get clean
