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

helpme () {
	echo "Armbian Image Config Tool - Ver. $AIC_VER"
	echo "armbian-image-config armbian-image.img module [options]"
	echo "modules:"
	echo "    n|hostname [mynewhostname]"
	echo "    e|ethernet [dhcp|static] [ipaddr mask] [gw] [dns] [search]"
	echo "    w|wifi [dhcp|static] ssid key [ipaddr mask] [gw] [dns] [search]"
	echo "    u|user [username] [password]"
	echo "    l|log2ram [enabled|disabled]"
	echo "    r|remote [ssh|xrdp] [enabled|disabled]"
	echo "    t|template [package|template.tgz]"
	echo "    x|rootshell"
	echo "    h|help"
	echo ""
	echo "armbian-image-config help modulename for module specific help"
}

helpme_hostname () {
	echo "armbian-image-config armbian-image.img h|hostname [hostname]"
	echo "    n|hostname"
	echo "        name"
	echo ""
	echo "e.g. armbian-image-config armbian-image.img h myserver"
}

helpme_ethernet () {
	echo "armbian-image-config armbian-image.img e|ethenet [dhcp|static] [ipaddr mask] [gw] [dns] [search]"
	echo "    e|ethernet"
	echo "        d|dhcp"
	echo "        s|static"
	echo "            ipaddr mask [gw] [dns] [search]"
	echo ""
	echo "e.g. armbian-image-config armbian-image.img e d"
	echo "e.g. armbian-image-config armbian-image.img e s 10.0.0.50 255.255.255.0 10.0.0.254 9.9.9.9 mynet.lan"
}

helpme_wifi () {
	echo "armbian-image-config armbian-image.img w|wifi [dhcp|static] ssid key [ipaddr mask] [gw] [dns] [search]"
	echo "    w|wifi"
	echo "        d|dhcp"
	echo "            ssid key"
	echo "        s|static"
	echo "            ssid key ip mask [gw] [dns] [search]"
	echo "        s6|staticipv6"
	echo "            ssid key ip6 mask6 [gw6] [dns6] [search]"
	echo ""
	echo "e.g. armbian-image-config armbian-image.img w d MyWifiAP wpa-psk MySecret"
	echo "e.g. armbian-image-config armbian-image.img w s MyWifiAP wpa-psk MySecret 10.0.0.51 255.255.255.0 10.0.0.254 9.9.9.9 mynet.lan"
}

helpme_template () {
	echo "armbian-image-config armbian-image.img t|template [package|template.tgz]"
	echo "    t|template"
	echo "        package|template.tgz"
	echo ""
	echo "e.g. armbian-image-config armbian-image.img t aic-template.tgz"
}

todo () {
	echo "$AIC_ARG1 not yet implemented"
}
