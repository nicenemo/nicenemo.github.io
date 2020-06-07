---
title: "Ubuntu_from_scratch_on_smartOS_BHyve"
date: 2020-06-07T21:44:13+02:00
draft: true
categories:
  - SmartOS
  - Kubernetes
  - Ubuntu
  - Docker
tags:
  -  annoying
  -  home automation
---

**Insert Lead paragraph here.**

### 2020 Ubuntu Server images are outdated

```bash
imgadm avail|grep ubuntu
```

### Getting ubuntu 2020.04 LTS server

```bash
cd /opt/metadata/isos
curl https://releases.ubuntu.com/20.04/ubuntu-20.04-live-server-amd64.iso> ubuntu-20.04-lever-server-amd64.iso --insecure
cd ../zones/other
```

### ubuntu_2020_04.json

TODO:

* fixed VNC-port
* 80 GB disk is too much
* 4 Gb memory maybe too much too.
* Explore BHyve extra opts
* Possible to set CD-ROM via extra opts on first boot only to simply
* Setting the right model for disk and CD-ROM was the hardest. I Managed by trial and error
* This configuration might be useful for installing Windows too!

```json
{
  "brand": "bhyve",
  "bhyve_extra_opts": "-c sockets=1,cores=2,threads=2",  
  "vcpus": 4,
  "autoboot": false,
  "alias": "ubuntu",
  "hostname": "ubuntu",
  "bootrom": "uefi",
  "ram": 4096,
  "vnc_port": 15910,
  "resolvers": [ "192.1.1.1","8.8.8.8","8.8.4.4"],
  "disks": [
    {
      "boot": false,
      "model": "virtio",
      "size": 81920
    },
    {
      "boot": true,
      "model": "ahci",
      "media": "cdrom",
      "path":"/ubuntu-20.04-server-amd64.iso"
    }

  ],
  "nics": [
    {
      "nic_tag": "admin",
      "model": "virtio",
      "ip": "192.1.1.42",
      "netmask": "255.255.255.0",
      "gateway": "192.1.1.1",
      "primary": true
    }
  ]
}
```

TODO: set vm UUID in variable

```bash
vmadm create -f ubuntu_2020_04.json  t
cp /zones/media/ubuntu-20.04-server-amd64.iso  /zones/872495de-ecbf-e2a4-b6cc-d274f170dcb3/root/
vmadm start 872495de-ecbf-e2a4-b6cc-d274f170dcb3
```

### Install via VNC

...

### Remove CD-ROM and make disk bootable

```bash
vmadm stop 872495de-ecbf-e2a4-b6cc-d274f170dcb3 -f
vmadm get 872495de-ecbf-e2a4-b6cc-d274f170dcb3
```

```bash
echo '{"remove_disks": ["/ubuntu-20.04-server-amd64.iso"]}' | vmadm update 872495de-ecbf-e2a4-b6cc-d274f170dcb3
vmadm get 872495de-ecbf-e2a4-b6cc-d274f170dcb3
```

```bash  
echo '{"update_disks": [{"path":"/dev/zvol/rdsk/zones/872495de-ecbf-e2a4-b6cc-d274f170dcb3/disk0","boot":true}]}' | vmadm update \
872495de-ecbf-e2a4-b6cc-d274f170dcb3
```

```bash
vmadm start 872495de-ecbf-e2a4-b6cc-d274f170dcb3
exit
```

I did not bother automating the installation further since I am not sure yet whether I like to stick with Ubuntu.
Next install and run Kubernetes. Probably via a snap first.
