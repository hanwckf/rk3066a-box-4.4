#!/bin/bash
rootfs="debian-rootfs"
[ -d "$rootfs" ] && echo "dir exists" && exit 0

sudo debootstrap --components=main,contrib,non-free \
--include=nano,openssh-server,busybox-syslogd,dialog,sysvinit-core,locales,htop,mtd-utils,iptables,ipset,ntp,usbutils \
--arch=armhf --variant=minbase --foreign --verbose jessie $rootfs http://mirrors.ustc.edu.cn/debian/

if [ "$?" = "0" ]; then
	sudo sed -i -e 's/systemd systemd-sysv //g' $rootfs/debootstrap/required
	sudo cp /usr/bin/qemu-arm-static $rootfs/usr/bin/qemu-arm-static
	chmod +x init.sh && sudo cp -f init.sh $rootfs/ && sudo chroot $rootfs /init.sh

	sudo rm -f $rootfs/usr/bin/qemu-arm-static
	sudo rm -f $rootfs/init.sh
	sudo rm -rf $rootfs/var/lib/apt/*

	echo "debian rootfs size: $(sudo du -sh $rootfs |cut -f1)"
else
	echo "debootstrap failed!"
fi