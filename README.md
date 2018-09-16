## Armbian Image Config Tool - Ver. 0.3

Tool to pre-configure basic system settings on Armbian images. Each module can be used independently on an image but using the same module twice will overwrite not combine any changes. This tool needs superuser permissions to mount and write to system files on disk images, you will need to run it with sudo or in a root shell

### Simple Usage
```
sudo armbian-image-config armbian-image.img module [options]

modules:
    n|hostname [mynewhostname]
    e|ethernet [dhcp|static] [ipaddr mask] [gw] [dns] [search]
    w|wifi [dhcp|static] ssid key [ipaddr mask] [gw] [dns] [search]
    u|user [uusername] [password]
    l|log2ram [enabled|disabled]
    r|remote [ssh|xrdp] [enabled|disabled]
    t|template [package|template.tgz]
    x|rootshell
    h|help
```

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
            ssid key
        s|static
            ssid key ip mask [gw] [dns] [search]
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
        package|template.tgz
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
armbian-image-config armbian-image.img h|hostname [mynewhostname]
    n|hostname
        name

armbian-image-config armbian-image.img h myserver"
```
#### ethernet or e
Sets up ethernet networking for the first detected card for either DHCP or static IP addressing
```
armbian-image-config armbian-image.img e|ethenet [dhcp|static] [ipaddr mask] [gw] [dns]
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
armbian-image-config armbian-image.img w|wifi [dhcp|static] ssid key [ipaddr mask] [gw] [dns] [search]
    w|wifi
        d|dhcp
            ssid key
        s|static
            ssid key ip mask [gw] [dns] [search]
        s6|staticipv6
            ssid crypto key ip6 mask6 [gw6] [dns6] [search]
	
armbian-image-config armbian-image.img w d MyWifiAP MySecret
armbian-image-config armbian-image.img w s MyWifiAP MySecret 10.0.0.51 255.255.255.0 10.0.0.254 9.9.9.9 mynet.lan
```
#### user or u
Sets the username and password of the primary system user
```
armbian-image-config armbian-image.img u [username] [password]
```
#### log2ram or l
Enable or disable log2ram for troubleshooting startup issues
```
armbian-image-config armbian-image.img l [enabled|disabled]
```
#### remote or r
Enable or disable remote access via ssh and rdp
```
armbian-image-config armbian-image.img r [ssh|xrdp] [enabled|disabled]
```

#### template or t
Inject a config template into the image. Can be any files in a compressed tar archive which is extracted at root (/) on the image root file system. See also Creating templates below
```
armbian-image-config armbian-image.img t|template [package|template.tgz]
    t|template
        package|template.tgz

e.g. armbian-image-config armbian-image.img t aic-template.tgz
```
#### rootshell or x
Mount the image and start a chroot shell
```
armbian-image-config armbian-image.img rootshell
```
#### help
Prints usage help

### Creating templates
To create a config template, consisting of the config of 1 or more modules, use the keyword "template" instead of an image file name. This will populate the "tmproot" folder with the generated config files ready for packaging. To create a package use the command "armbian-image-config template package" and a config packaged named aic-template.tgz will be created
```
armbian-image-config template n tvbox
armbian-image-config template w d MyWiFi wpa-psk MySecret
armbian-image-config template package
```

### Development Status
Active

#### Module Progress
- hostname - done, needs testing
- ethernet - done, needs testing
- wifi - done, needs testing
- user #TODO
- log2ram #TODO
- template done, needs testing
- rootshell #TODO
- help - done, needs testing


### License
This software is licensed under the terms of the GNU General Public License version 2. This program is licensed "as is" without any warranty of any kind, whether express or implied.

This file is a part of the Armbian Image Config Tool
https://github.com/botfap/armbian-image-config/

***
armbian-image-config-0.3 - Copyright (c) 2018 botfap, botfap@faphq.icu


