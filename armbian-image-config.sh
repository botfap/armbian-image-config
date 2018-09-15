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
	echo "Armbian Image Config Tool - Ver. $AIC_VER"
	echo "armbian-image-config armbian-image.img module [options]"
	echo "modules:"
	echo "    n|hostname"
	echo "    e|ethernet"
	echo "    w|wifi"
	echo "    a|apmode"
	echo "    u|user"
	echo "    l|log2ram"
	echo "    r|remote"
	echo "    t|template"
	echo "    x|rootshell"
	echo "    h|help"
	echo ""
	echo "armbian-image-config help module for module specific help"
}

helpme_hostname () {
	echo "armbian-image-config armbian-image.img h|hostname [hostname]"
	echo "    n|hostname"
	echo "        name"
	echo ""
	echo "e.g. armbian-image-config armbian-image.img h myserver"
}

helpme_ethernet () {
	echo "armbian-image-config armbian-image.img e|ethenet [dhcp|static] [options]"
	echo "    e|ethernet"
	echo "        d|dhcp"
	echo "        s|static"
	echo "            ipaddr mask [gw] [dns] [search]"
	echo ""
	echo "e.g. armbian-image-config armbian-image.img e d"
	echo "e.g. armbian-image-config armbian-image.img e s 10.0.0.50 255.255.255.0 10.0.0.254 9.9.9.9 mynet.lan"
}

helpme_wifi () {
	echo "armbian-image-config armbian-image.img w|wifi [dhcp|static] ssid crypto key [options]"
	echo "    w|wifi"
	echo "        d|dhcp"
	echo "            ssid crypto key"
	echo "        s|static"
	echo "            ssid crypto key ip mask [gw] [dns] [search]"
	echo "        s6|staticipv6"
	echo "            ssid crypto key ip6 mask6 [gw6] [dns6] [search]"
	echo ""
	echo "e.g. armbian-image-config armbian-image.img w d MyWifiAP wpa-psk MySecret"
	echo "e.g. armbian-image-config armbian-image.img w s MyWifiAP wpa-psk MySecret 10.0.0.51 255.255.255.0 10.0.0.254 9.9.9.9 mynet.lan"
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
    	if [ -n "$AIC_ARG1" ]; then
    		set_hostname
    	else
    		helpme_hostname
    	fi
        ;;
    e|ethernet)
    	case "$AIC_ARG1" in
    		s|static)
				set_ethernet_static
				;;
			d|dhcp)
				set_ethernet_dhcp
				;;
			*)
				helpme_ethernet
				;;
 		esac
    	;;
    w|wifi)
    	case "$AIC_ARG1" in
    		s|static)
				set_wifi_static
				;;
			d|dhcp)
				set_wifi_dhcp
				;;
			*)
				helpme_wifi
				;;
 		esac   		 
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





