#!/bin/bash
#
# Armbian Image Config Tool
#
# This file is licensed under the terms of the GNU General Public
# License version 2. This program is licensed "as is" without any
# warranty of any kind, whether express or implied.
#
# This file is a part of the Armbian Image Config Tool
# https://github.com/botfap/armbian-image-config/
#
# Copyright (c) 2018 botfap, botfap@faphq.icu
#

mount_image () {
	mkdir -p $AIC_MNT
	
	if [ "$AIC_IMG" != "template" ]; then
		IMG_DEV=`losetup -f --show -P $AIC_IMG`
		IMG_PART="$IMG_DEV"p1
		mount -t ext4 "$IMG_PART" "$AIC_MNT"
	fi
}

unmount_image () {
	sync
	
	if [ "$AIC_IMG" != "template" ]; then
		sleep 2
		fuser -k -9 "$AIC_MNT"
		umount -f "$AIC_MNT"
		losetup -d "$IMG_DEV"
	fi
}

template_package () {

	cd "$AIC_MNT"
	tar -cvzpf ../aic-template.tgz *
	echo "Template package aic-template.tgz has been created"
}

template_apply () {
	mount_image
	
	tar -xvf "$AIC_ARG1" -C "$AIC_MNT"
	echo "Template package $AIC_ARG1 has been applied to image: $AIC_IMG"
	
	unmount_image
}

set_hostname () {
	mount_image
	
	mkdir -p "$AIC_MNT"/etc
	CURH=`cat "$AIC_MNT"/etc/hostname`
	echo "$AIC_ARG1" > "$AIC_MNT"/etc/hostname
	NEWH=`cat "$AIC_MNT"/etc/hostname`
	
	echo "hostname changed from $CURH to $NEWH for image: $AIC_IMG"
	
	unmount_image
}


