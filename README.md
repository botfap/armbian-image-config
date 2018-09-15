## Armbian Image Config Tool

Tool to pre-configure basic system settings on Armbian images. Each module can be used independently on an image but using the same module twice will overwrite not combine any changes

### Simple Usage
```
sudo armbian-image-config armbian-image.img module [options]
```

### Module List
hostname,ethernet,wifi,user,log2ram,remote,template,rootshell,help

### Full Usage
```
armbian-image-config armbian-image.img function [options]
    n|hostname
        name
    e|ethernet
        d|dhcp
        s|static
            ipaddr mask [gw] [dns] [search]
    w|wifi
        d|dhcp
            ssid crypto key
        s|static
            ssid crypto key ip mask [gw] [dns] [search]
        s6|staticipv6
            ssid crypto key ip6 mask6 [gw6] [dns6] [search]
    u|user
        name password
    l|log2ram
        e|enable
        d|disable
    r|remote
        s|ssh
            e|enable
            d|disable
        r|rdp
            e|enable
            d|disable
    t|template
        template.tgz
    x|rootshell
        chroot                    
    h|help
        print
```

### Image Info
Image file can be any stadard Armbian image. Either self built or downloaded

Replace image name with keyword "template" to generate just the config files ready to make a template package

### Module Help and Examples
#### hostname or n
Sets the system hostname for the image
```
armbian-image-config armbian-image.img h|hostname [hostname]
    n|hostname
        name

armbian-image-config armbian-image.img h myserver"
```
#### ethernet or e
Sets up ethernet networking for the first detected card for either DHCP or static IP addressing
```
armbian-image-config armbian-image.img e|ethenet [dhcp|static] [options]
    e|ethernet
        d|dhcp
        s|static
            ipaddr mask [gw] [dns] [search]

armbian-image-config armbian-image.img e d
armbian-image-config armbian-image.img e s 10.0.0.50 255.255.255.0 10.0.0.254 9.9.9.9 mynet.lan
```
#### wifi or w
Sets up wifi networking for the first detected card for either DHCP or static IP addressing
```
armbian-image-config armbian-image.img w|wifi [dhcp|static] ssid crypto key [options]
    w|wifi
        d|dhcp
            ssid crypto key
        s|static
            ssid crypto key ip mask [gw] [dns] [search]
        s6|staticipv6
            ssid crypto key ip6 mask6 [gw6] [dns6] [search]
	
armbian-image-config armbian-image.img w d MyWifiAP wpa-psk MySecret
armbian-image-config armbian-image.img w s MyWifiAP wpa-psk MySecret 10.0.0.51 255.255.255.0 10.0.0.254 9.9.9.9 mynet.lan
```
#### user or u
Sets the username and password of the primary system user
```
armbian-image-config armbian-image.img user myuser mypass
```
#### log2ram or l
Enable or disable log2ram for troubleshooting startup issues
```
armbian-image-config armbian-image.img log2ram disable
```
#### remote or r
Enable or disable remote access via ssh and rdp
```
armbian-image-config armbian-image.img remote ssh enable
```

#### template or t
Inject a config template into the image. Can be any files in a compressed tar archive which is extracted at root (/) on the image root file system
```
armbian-image-config armbian-image.img template template.tgz
```
#### rootshell or x
Mount the image and start a chroot shell
```
armbian-image-config armbian-image.img rootshell
```
#### help
Prints usage help

### Development Status
Almost Started

#### Module Progress
- hostname - done
- ethernet - done, needs testing #TODO
- wifi - done, needs testing #TODO
- apmode #TODO
- user #TODO
- log2ram #TODO
- template #TODO
- rootshell #TODO
- help - started


### License
This software is licensed under the terms of the GNU General Public License version 2. This program is licensed "as is" without any warranty of any kind, whether express or implied.

This file is a part of the Armbian Image Config Tool
https://github.com/botfap/armbian-image-config/

***
armbian-image-config-0.1 - Copyright (c) 2018 botfap, botfap@faphq.icu


