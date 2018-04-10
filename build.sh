#!/bin/sh

rktools/mkbootimg --kernel kernel/zImage --base 60400000 -o boot.img
