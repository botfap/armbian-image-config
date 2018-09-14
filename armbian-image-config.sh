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

IFS=
AIC_VER="0.1"
AIC_MNT="tmproot"
AIC_IMG="$1"
AIC_FUNC="$2"
AIC_ARG1="$3"
AIC_ARG2="$4"
AIC_ARG3="$5"
AIC_ARG4="$6"
AIC_ARG5="$7"
AIC_ARG6="$8"
AIC_ARG7="$9"
AIC_ARG8="$10"
AIC_ARG9="$11"

helpme () {
	echo "amrbian-image-config armbian-image.img module [options]"
	echo "    n|hostname"
	echo "        name"
	echo "    e|ethernet"
	echo "        d|dhcp"
	echo "        s|static"
	echo "            ipaddr mask [gw] [dns] [search]"
	echo "    w|wifi"
	echo "        d|dhcp"
	echo "            ssid crypto key"
	echo "        s|static"
	echo "            ssid crypto key ip mask [gw] [dns] [search]"
	echo "        s6|staticipv6"
	echo "            ssid crypto key ip6 mask6 [gw6] [dns6] [search]"
	echo "    a|apmode"
	echo "            ssid crypto key"
	echo "    u|user"
	echo "        name password"
	echo "    l|log2ram"
	echo "        e|enable"
	echo "        d|disable"
	echo "    r|remote"
	echo "        s|ssh"
	echo "            e|enable"
	echo "            d|disable"
	echo "        r|rdp"
	echo "            e|enable"
	echo "            d|disable"
	echo "    t|template"
	echo "        template.tgz"
	echo "    x|rootshell"
	echo "        chroot"                    
	echo "    h|help"
	echo "        print"
}

todo () {
	echo "$AIC_ARG1 not yet implemented"
}

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

set_hostname () {
	mount_image
	
	mkdir -p "$AIC_MNT"/etc
	CURH=`cat "$AIC_MNT"/etc/hostname`
	echo "$AIC_ARG1" > "$AIC_MNT"/etc/hostname
	NEWH=`cat "$AIC_MNT"/etc/hostname`
	
	echo "hostname changed from $CURH to $NEWH for image: $AIC_IMG"
	
	unmount_image
}

set_ethernet_dhcp () {
	mount_image
	
	mkdir -p "$AIC_MNT"/etc/NetworkManager/system-connections
	NMCONF=`cat lib/ethernet-dhcp.tmpl`
	echo $NMCONF > "$AIC_MNT"/etc/NetworkManager/system-connections/ethernet
	chmod 600 "$AIC_MNT"/etc/NetworkManager/system-connections/ethernet
	
	echo "ethernet network with dhcp active for image: $AIC_IMG"
	
	unmount_image
}

set_ethernet_static () {
	mount_image

	mkdir -p "$AIC_MNT"/etc/NetworkManager/system-connections
	NMCONF=`cat lib/ethernet-static.tmpl | sed -e "s/TMPLIP/$AIC_ARG2/g" -e "s/TMPLMASK/$AIC_ARG3/g" -e "s/TMPLGW/$AIC_ARG4/g" -e "s/TMPLDNS/$AIC_ARG5/g" -e "s/TMPLSEARCH/$AIC_ARG6/g"`
	echo $NMCONF > "$AIC_MNT"/etc/NetworkManager/system-connections/ethernet
	chmod 600 "$AIC_MNT"/etc/NetworkManager/system-connections/ethernet
	
	echo "ethernet network with ip $AIC_ARG2 active for image: $AIC_IMG"
	
	unmount_image
}

set_wifi_dhcp () {
	mount_image
	
	mkdir -p "$AIC_MNT"/etc/NetworkManager/system-connections
	NMCONF=`cat lib/wifi-dhcp.tmpl | sed -e "s/TMPLSSID/$AIC_ARG2/g" -e "s/TMPLCRYPTO/$AIC_ARG3/g" -e "s/TMPLKEY/$AIC_ARG4/g"`
	echo $NMCONF > "$AIC_MNT"/etc/NetworkManager/system-connections/wifi
	chmod 600 "$AIC_MNT"/etc/NetworkManager/system-connections/wifi
	
	echo "wifi network $AIC_ARG2 with dhcp active for image: $AIC_IMG"
	
	unmount_image
}

set_wifi_static () {
	mount_image

	mkdir -p "$AIC_MNT"/etc/NetworkManager/system-connections
	NMCONF=`cat lib/wifi-dhcp.tmpl | sed -e "s/TMPLSSID/$AIC_ARG2/g" -e "s/TMPLCRYPTO/$AIC_ARG3/g" -e "s/TMPLKEY/$AIC_ARG4/g" -e "s/TMPLIP/$AIC_ARG5/g" -e "s/TMPLMASK/$AIC_ARG6/g" -e "s/TMPLGW/$AIC_ARG7/g" -e "s/TMPLDNS/$AIC_ARG8/g" -e "s/TMPLSEARCH/$AIC_ARG9/g"`
	echo $NMCONF > "$AIC_MNT"/etc/NetworkManager/system-connections/wifi
	chmod 600 "$AIC_MNT"/etc/NetworkManager/system-connections/wifi
	
	echo "wifi network $AIC_ARG2 with ip $AIC_ARG5 active for image: $AIC_IMG"

	unmount_image
}

### start

case "$AIC_FUNC" in
    n|hostname)
    	set_hostname
        ;;
    e|ethernet)
    	if [ "$AIC_ARG1" = "static" ] || [ "$AIC_ARG1" = "s" ]; then
    		set_ethernet_static
    	else
    		set_ethernet_dhcp
    	fi
    	;;
    w|wifi)
    	if [ "$AIC_ARG1" = "static" ] || [ "$AIC_ARG1" = "s" ]; then
    		set_wifi_static
    	else
    		set_wifi_dhcp
    	fi
    	;;
    a|apmode)
    	todo
		;;
    u|user)
    	todo
		;;
    l|log2ram)
    	todo
		;;
    r|remote)
		todo
		;;
    s|skeleton)
		todo
		;;
    x|rootshell)
		todo
		;;
    h|help)
    	helpme
		;;
	*)
		helpme
		;;
esac





