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
	NMCONF=`cat lib/wifi-dhcp.tmpl | sed -e "s/TMPLSSID/$AIC_ARG2/g" -e "s/TMPLKEY/$AIC_ARG3/g"`
	echo $NMCONF > "$AIC_MNT"/etc/NetworkManager/system-connections/wifi
	chmod 600 "$AIC_MNT"/etc/NetworkManager/system-connections/wifi
	
	echo "wifi network $AIC_ARG2 with dhcp active for image: $AIC_IMG"
	
	unmount_image
}

set_wifi_static () {
	mount_image

	mkdir -p "$AIC_MNT"/etc/NetworkManager/system-connections
	NMCONF=`cat lib/wifi-dhcp.tmpl | sed -e "s/TMPLSSID/$AIC_ARG2/g" -e "s/TMPLKEY/$AIC_ARG3/g" -e "s/TMPLIP/$AIC_ARG4/g" -e "s/TMPLMASK/$AIC_ARG5/g" -e "s/TMPLGW/$AIC_ARG6/g" -e "s/TMPLDNS/$AIC_ARG7/g" -e "s/TMPLSEARCH/$AIC_ARG8/g"`
	echo $NMCONF > "$AIC_MNT"/etc/NetworkManager/system-connections/wifi
	chmod 600 "$AIC_MNT"/etc/NetworkManager/system-connections/wifi
	
	echo "wifi network $AIC_ARG2 with ip $AIC_ARG5 active for image: $AIC_IMG"

	unmount_image
}

