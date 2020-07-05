---
title: "Throw away WSL environments"
date: 2020-07-04T23:31:09+02:00
draft: false
categories:
  - testing
tags:
  - WSL
  - Debian
  - PowerShell
  - Ansible
  - No snowflake
  - Dev box
  - Yak shaving
---

A rainy weekend is a perfect opportunity to do some yak shaving and learn a few things. I created
a [WSL Debian boxes](https://github.com/nicenemo/wsl-debian-boxes), a collection of PowerShell and Bash scripts
that enable you to spin up fresh updated and Ansible enabled [WSL](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) 2, based machines at lightning speed. Create an environment to test software. Yak shave your development environment and more.

<!--more-->

The last few weeks I have been automating virtual environment creation as part of my job,
using [Ansible](https://www.ansible.com/).
I used [Jef Geerling's](https://www.jeffgeerling.com/) excellent book
[Ansible for Devops](https://leanpub.com/ansible-for-devops)
and the related [Ansible 101](https://www.youtube.com/playlist?list=PL2_OBreMn7FqZkvMYt6ATmgC0KAGGJNAN) YouTube video series.

One of terms Jeff coined was _snowflake server_, a machine that is (partially),
configured and updated by hand. Some changes are not documented and it is not possible to recreate the machine in case of disaster. My development machine, is very similar to a snowflake server. How about your development machine?
I cannot recreate my machine on fresh hardware without lots of manual steps. Installing it takes a day.  Next it takes days for all the things I forgot. Change is needed. Perhaps Ansible is part of a solution.

I tried automating the installation of a Windows machine before, by using [Box Starter](https://boxstarter.org/)
and the [Choclatey](https://chocolatey.org/). I did not get it stable or complete.
By using Ansible and with a bit more experience I think I can finally manage.
Unfortunately Ansible does not really run on Windows.
You can manage Windows machines using Ansible from Linux.
That is exactly what I plan to do: a self-contained automated installation of my development machine, using WSL and Ansible.

After an initial Windows install, I have an automated mechanism to bootstrap a WSL environment.
The WSL environment then configures the rest of the machine using Ansible. The same Ansible based solution can then be used to:

* Run Windows updates
* Update Installed software on Windows using Chocolatey
* Update apps installed via the Windows store.
* If possible run the Lenovo Vantage updater from my laptop.
* Update WSL Linux environments on the machine.

As a first step, I automate the creation of a clean and fresh minimal WSL Linux environment.
My current WSL environment is a snowflake, so that is an unstable basis. I need to be able to create, configure and destroy a fresh WSL Linux environment at lightning speed. No manual steps are allowed.

I am currently using [Pengwin](https://github.com/WhitewaterFoundry) Linux from White Water Foundry.
A very comfortable WSL environment with all the bells and whistles. It has to go because:

* On initial startup it asks you to configure several aspects using a menu system.
* I did not directly see a way to automate that.
* I think a more minimal Linux suits my needs, since I am ready and willing to take more control again.

I am most comfortable with Debian based Linux environments and decided to go with the real thing. The WSL
Debian image is very minimal. Perfect for my needs. Sadly it is based on the older Debian 9, _Stretch_. I explain in a moment on how to upgrade it to Debian 10, _Buster_ and Debian 11, _Bullseye_.

WSL Linux distributions can be downloaded and install from the store.
This is slow and you cannot install multiple instances of the same app.
For this use case Microsoft suggests doing a
[direct download](https://docs.microsoft.com/en-us/windows/wsl/install-manual)
of your favourite distribution. The initial download is still slow but every install can be done faster from a local file. This still does allow yo to install multiple instances of the same _Linux app_. For this you can use WSL's `wsl --export` and `wsl --import` options. This allows you to import and export a so-called tar archive, often called tar ball, from your installed _Linux app_. A tar ball can be installed multiple times to create multiple virtual machines.

I created two PowerShell scripts. I have [bootstrap-debian-images.PS1](https://github.com/nicenemo/wsl-debian-boxes/blob/develop/bootstrap-debian-images.PS1) This does the following:

1. Download the _WSL Debian Linux App_
2. Install the app
3. Do the post install without installing a normal user. No questions are asked and if you start the app you will be logged in as root. Perfect for automation.
4. Copy an apt sources.list into the image. This allows me to use a broader package selection and also allows me to use a local mirror.
5. Upgrade the software installed in the image. Since the image was made, quite a few updates where released. This will speed up fresh installation.
6. Create a tar ball for Debian Stretch.
7. Copy an apt sources.list for Debian Buster into the image. This again allows me to use a broader package selection and also allows me to use a local mirror.
8. Upgrade the machine
9. Create a tar ball for Debian Buster.
10. Copy an apt sources.list for Debian Bullseye into the image. This again allows me to use a broader package selection and also allows me to use a local mirror.
11. Upgrade the machine
12. Create a tar ball for Debian Bullseye.
13. Remove the WSL Debian machine
14. Uninstall the Debian Windows store app.
15. Remove the downloaded Windows store app.

You now how 3 freshly baked tar balls for Stretch, Buster and Bullseye.
These can be used with my [create-machine.PS1] script. This script performs the following:

1. Create a WSL virtual machine with the tar ball of your choice
2. Upgrades the software, since it might have been a while since the last time you created the tar balls.
3. Install Python3 and Pip3.
4. Create a user
5. Give the created user sudo rights
6. Make the user the default user for use with WSL. You no longer get a root prompt.
7. Make a _winhome_ soft link to your Windows home directory in your Linux user's home directory.
8. Add ~/.local/bin to the path of the user.
9. Try to update _pip_ as the user. Because, sudo is not used, this will result in an updated pip in the user's `~/.local/bin` directory.
10. Install _Ansible_ as the user. Since sudo is not used this will result in Ansible being installed in the user's `~/.local/bin`

I did no further updates This is for creating a base image.
Further updates and customization should be done using Ansible.
Ansible is declarative and in general more readable and easier to maintain than Shell scripts.

If you look into the scripts you will notice that I use a few Bash scripts and shell commands to upgrade and install the software. I did not use Ansible, because Ansible running on the machine that you update does break because of Python upgrades.

I thought of running an all Linux solution instead of PowerShell. That would mean I need to have a WSL machine first. I think the amount of PowerShell needed for bootstrapping is limited. 

The machines are not installed with an SSH server yet. They are intended as something to use Ansible from, not, as something to administer with Ansible from the outside for now. 

Networking in WSL is a bit complicated. Every WSL machine is in its own isolated subnet and ports are only accessible via port forwarding on the host. From within WSL, the host is available on the default route IP address. Sadly after reboot the network addresses used changed. So administering the windows host from within WSL using Ansible will be an extra challenge besides installing an SSH server on the host first.

If you used [Vagrant](https://www.vagrantup.com/) and or [Packer](https://www.packer.io/) before, then the approach taken should look familiar. These tools abstract and or simplify the creation and deployment of virtual machine images and environments on various virtualization solutions. Perhaps they will support WSL one day, and I can retire these scripts. 

The scripts still need some maturing.
Please do read the [README](https://github.com/nicenemo/wsl-debian-boxes/blob/develop/README.md)
if you use it.
You currently need to navigate to the directory of the scripts to use them.
For me they are already quite useable for creating test environments and
Yak shaving the ultimate development machine.

