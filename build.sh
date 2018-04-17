#!/bin/sh
rm -f boot.img
rktools/mkbootimg --kernel kernel/zImage --base 60800000 -o boot.img
