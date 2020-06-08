---
title: "Thoughts on Kubernetes on SmartOS"
date: 2020-06-07T17:48:25+02:00
draft: false
categories:
  - virtualization
  - Kubernetes
  - Docker
  - SmartOS
  - 
tags:
  -  home automation
  -  Annoying
---

With this blog post I document the thoughts I had in  getting Ubuntu server running from scratch on [SmartOS](https://en.wikipedia.org/wiki/SmartOS) using [BHyve](https://bhyve.org/), the BSD Hypervisor. My final goal is getting [Kubernetes](https://kubernetes.io/) running on SmartOS.

<!--more-->

At home, I run SmartOS on a PC, that I use as a little NAS and for some server tasks.
It is low energy but has the power to run some virtualization tasks. Specifications:

* Intel I7 T series 35 Watt TDP, Passive cooled
* 32 Gb memory
* 2X 2 TB disks, [ZFS](https://en.wikipedia.org/wiki/ZFS), mirrored
* SSD as ZFS log device
* boot from USB stick
* Passive cooled CPU
* Big tower case with big slow turning fans

SmartOS is a free and open-source hypervisor platform supporting several flavours of virtualization. The typical light-weight zone is Solaris based, Light-weight, Linux based zones, LX zones are also possible. It is even possible to run single Docker images. KVM or the newer BHyve zones allows running arbitrary operating systems using hardware virtualization. To increase security, these run inside a zone too with minimal privileges. People use SmartOS to virtualize BSD, Linux, Windows and even BeOS or HaikuOS. A while ago I even saw some odd QEmu based virtualizations.

Nowadays the lingua franca of virtualization is [Kubernetes](https://kubernetes.io/). Kubernetes is a Linux based solution for automating deployment, scaling, and management of containerized applications. It runs in the cloud on Google, Azure and AWS. On your PC or Mac you can run it with [Docker Desktop](https://www.docker.com/products/docker-desktop) or [MiniKube](https://kubernetes.io/docs/tutorials/hello-minikube/).

SmartOS does not run Kubernetes natively. With [Triton](https://www.joyent.com/triton/compute), [Joyent](https://www.joyent.com/), now Samsung, tried/tries to offer a competing premium solution, on top of SmartOS. It never gained a lot of traction. Nowadays Triton can run Kubernetes, I know. You can run simple Docker containers in SmartOS after a conversion to an LX zone. However, a simple combination of docker images with configured _docker-compose_ is not possible.

Triton, formerly called SmartDC, is cool but requires way more hardware resources than I like to spend on managing containers. Currently, I do prefer not to wipe my current server for native Kubernetes, Triton or something else.

Earlier, I tried [Project Fifo](https://project-fifo.net/), a lighter Triton alternative, that runs on bare SmartOS. Fifo is way more than I need and still consumes too many resources for managing virtualization on my home server.

A couple of years ago, I tried virtualization of Windows and Linux on SmartOS KVM.
For whatever reason KVM needs a gigabyte of extra memory that cannot be used.
My server is maxed out with 32Gb of memory. Losing a gigabyte of ram for every virtual machine is not attractive. So far I stayed with single LX and SmartOS zones. I never used my server for something complex. I use one LX zone with SMB NAS and a few other services.

Last year, I saw [this video](https://shaner.life/deploying-kubernetes-on-smartos/) on the _Shaner's Life_ blog, explaining how to run Kubernetes on SmartOS using the Bhyve hypervisor. He used several Ubuntu based images to virtualize a Kubernetes cluster. This seemed exactly what I needed. However, in 2019 I had other priorities.

It is now June 2020 and I really have a few use cases to run more complex Docker loads and maybe even Kubernetes. In the before mentioned video an existing Ubuntu server image for SmartOS was used. Sadly the latest KVM/BHyve Ubuntu images are from 2018. For LX zones it is even worse. SmartOS is not dead, I still see regular updates for the boot sticks but since Samsung bought Joyent, development seems a bit more silent.  

I really fancy something newer than Ubuntu 2018 and maybe even lighter than a full-blown Ubuntu server. I decided to install Ubuntu from scratch and do a proof of concept with Kubernetes first. It is not that different from installing Windows on KVM or BHyve. If that works, I can look into using something lighter than Ubuntu. I did some experimenting and I can say that I was able to create an Ubuntu based server on BHyve using the Ubuntu server ISO. Main obstacles where, figuring out how to:

* mount a CD-ROM on a BHyve zone
* remove CD-ROM from a BHyve zone after install
* make the disk with Ubuntu bootable

I read a few blog posts, man pages and combined a few ideas. After some trial and error I made it work! When, I finally managed to boot from CD-ROM, I saw the typical Ubuntu-server command line installer. (On the SmartOS VNC console). I was offered to install my GitHub or Ubuntu public key for password-less login. It also offered to install a lot of services. I only choose SSH, since most of the services offered where based on [Snap packages](https://snapcraft.io/). I am not sure whether I like that complexity for a Kubernetes host. Kubernetes was one of the Snaps offered. I decided to call it a day and safe my history for further scripting the installation after removing errors.

```bash
hugo new post/ubuntu-server2020.04-on_SmartOS_with_BHyve.md
...
history >> post/ubuntu-server2020.04-on_SmartOS_with_BHyve.md
```

More in a next blog post after cleaning my history ;).
