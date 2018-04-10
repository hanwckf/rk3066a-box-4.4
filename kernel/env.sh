#!/bin/sh
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
target_dts="rk3066a-marsboard"

mk(){
	make -j4 $*
}

mk_config(){
	mk rk3066a_box_defconfig
}

mk_zImage(){
	mk zImage
}

mk_dtb(){
	mk $target_dts.dtb
}

mk_zImage-dtb(){
	mk_zImage && mk_dtb && cp arch/arm/boot/zImage arch/arm/boot/zImage.orig && cat arch/arm/boot/dts/$target_dts.dtb >> arch/arm/boot/zImage
}
