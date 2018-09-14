## Armbian Image Config Tool

Tool to pre-configure basic system settings on Armbian images. Each module can be used independently on an image but using the same module twice will overwrite not combine any changes

### Simple Usage
```
sudo amrbian-image-config armbian-image.img module [options]
```

### Module List
hostname,ethernet,wifi,apmode,user,log2ram,remote,template,rootshell,help

### Full Usage
```
amrbian-image-config armbian-image.img function [options]
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
    a|apmode
            ssid crypto key
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
amrbian-image-config armbian-image.img hostname myserver
```
#### ethernet or e
Sets up ethernet networking for the first detected card for either DHCP or static IP addressing
```
amrbian-image-config armbian-image.img ethernet static 192.168.1.10 255.255.255.0
```
#### wifi or w
Sets up wifi networking for the first detected card for either DHCP or static IP addressing
```
amrbian-image-config armbian-image.img wifi dhcp wifiap wpa-psk mysecret
```
#### apmode or a
Sets up the first detected wifi card as a wifi access point
```
amrbian-image-config armbian-image.img apmode apname wpa-psk mysecret
```
#### user or u
Sets the username and password of the primary system user
```
amrbian-image-config armbian-image.img user myuser mypass
```
#### log2ram or l
Enable or disable log2ram for troubleshooting startup issues
```
amrbian-image-config armbian-image.img log2ram disable
```
#### remote or r
Enable or disable remote access via ssh and rdp
```
amrbian-image-config armbian-image.img remote ssh enable
```

#### template or t
Inject a config template into the image. Can be any files in a compressed tar archive which is extracted at root (/) on the image root file system
```
amrbian-image-config armbian-image.img template template.tgz
```
#### rootshell or x
Mount the image and start a chroot shell
```
amrbian-image-config armbian-image.img rootshell
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
amrbian-image-config-0.1 - Copyright (c) 2018 botfap, botfap@faphq.icu


