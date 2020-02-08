<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


# What Is This Directory For?
You need to download or purchase your Windows ISO images
and place them in this directory.

## Purchased Windows 10 Produce (i.e. Licensed)
I purchased from [Microsoft Company Store][01]
(Order # 1005131590, Order Date: 1/10/2020)
a boxed version of the Windows 10 Operating System.
It contains a USB thumb drive with a mountable filesystem.
From this, I needed to create an ISO file to instantiate my Vagrant/VirtualBox VM.

The Windows 10 product box USB thumb drive has a top level directory structure of:

```
WINDOWS10/
    'System Volume Information'/
    boot/
    efi/
    x64/
    x86/
    83561421-11f5-4e09-8a59-933aks71366.ini
    autorun.inf
    bootmgr
    bootmgr.efi
    setup.exe*
```

This top level directory `WINDOWS10` is bootable but
it appears that the sub-directories `x64/` is my real target for creating my ISO file:

```
WINDOWS10/
    x64/
        boot/
        efi/
        sources/
        support/
        autorun.inf
        bootmgr
        bootmgr.efi
        setup.exe*
```

>**NOTE:** I concluded this via these articles:
>
>* [Difference between x64 and x86](http://net-informations.com/q/mis/x86.html)
>* [What is x86 vs x64](https://forums.tomshardware.com/threads/what-is-x86-vs-x64.1220690/)
>* [x86 vs x64 - Why is 32-bit called x86?](https://superuser.com/questions/179919/x86-vs-x64-why-is-32-bit-called-x86)

### Creating My ISO File
With the purchased physical version of MS Windows 10 Pro,
and now understanding the file structure on the USB drive,
I needed to create my own [ISO 9660 filesystem image][04].
To do this, I used [`genisoimage`][05] & some advice from [here][06].
`genisoimage` is a command-line tool for creating ISO file.

To create the ISO image for my MS Windows 10 ISO file destine for my VirtualBox vagrant box,
I used the following command:

```bash
# create iso image suitable for ms-windows from the usb drive filesystem
genisoimage -no-emul-boot -b boot/etfsboot.com -boot-load-seg 0x07C0 -boot-load-size 8 -iso-level 2 -udf -joliet -R -D -N -V "VirtualBox-CD" -relaxed-filenames -o ./iso/windows-10-pro-020120.iso /media/jeff/WINDOWS10/x64
```

Now lets checkout the newly create ISO file to make sure it is in good working order:

```bash
# create a mount point and mount the iso file
mkdir /media/jeff/VirtualBox-CD
sudo mount -o loop ~/src/vagrant-machines/ms-windows/iso/windows-10-pro-020120.iso /media/jeff/VirtualBox-CD

# verify the mounting
df -H
ls -l /media/jeff/VirtualBox-CD/

# to unmount the iso file
sudo umount /media/jeff/VirtualBox-CD/
```

### Office Professional and Visio
I also purchased Office Professional 2019 and Visio Standard 2019
and place the installation/setup files (they are not ISO files) in this directory.
I didn't include these applications in the Vagrant base box
but instead added them while building a box using Vagrant.

So the contents of this directory inlcude the Windows Operating System
and Microsoft application software as follows:

```
# Created Windows 10 Disk Image (i.e. Licensed)
windows-10-pro-020120.iso

# Office Professional 2019 (i.e. Licensed)
Setup.Def.en-US_Professional2019Retail_0d3ef3f9-ae67-4b97-a856-fff4d491ba2c_TX_PR_Platform_def_.exe

# Visio Standard 2019 (i.e. Licensed)
Setup.Def.en-US_VisioStd2019Retail_0738b055-a809-4718-9a19-bfc2ec63bb9f_TX_PR_Platform_def_.exe
```


----


## Alternatives

### Windows 10 Evaluation Copy (i.e. Unlicensed)
As an alternative,
you can download an evaluation copy of Windows 10 x64 Enterprise ([here][02]).
The ISO file was loaded into `~/src/vagrant-machines/ms-windows/iso-files`.
My file is:

```
# Windows 10 Evaluation Copy (i.e. Unlicensed)
18363.418.191007-0143.19h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso
```

>**NOTE:** Ultimately, you're going to need a purchase a licensed version of Windows 10
>but the evaluation copy gives you 90 days of free use.

### Windows Server Software (i.e. Licensed)
You might want to consider the following sources for Windows Server software:

* Windows Server 2008 R2 + SP1:
	* File Name: en_windows_server_2008_r2_with_sp1_x64_dvd_617601.iso
	* SHA1 Hash: D3FD7BF85EE1D5BDD72DE5B2C69A7B470733CD0A
	* Direct Download: http://msdn.microsoft.com/subscriptions/json/GetDownloadRequest?brand=MSDN&locale=en-us&fileId=44782&activexDisabled=true&akamaiDL=false

* Windows Server 2008 R2 + SP1 (Volume License):
	* File Name: en_windows_server_2008_r2_with_sp1_vl_build_x64_dvd_617403.iso
	* SHA1 Hash: 7E7E9425041B3328CCF723A0855C2BC4F462EC57
	* Direct Download: http://msdn.microsoft.com/subscriptions/json/GetDownloadRequest?brand=MSDN&locale=en-us&fileId=44783&activexDisabled=true&akamaiDL=false

* Windows Server 2012:
	* File Name: en_windows_server_2012_x64_dvd_915478.iso
	* SHA1 Hash: D09E752B1EE480BC7E93DFA7D5C3A9B8AAC477BA
	* Direct Download: http://msdn.microsoft.com/subscriptions/json/GetDownloadRequest?brand=MSDN&locale=en-us&fileId=50539&activexDisabled=true&akamaiDL=false

* Windows Server 2012 (Volume License):
	* File Name: en_windows_server_2012_vl_x64_dvd_917758.iso
	* SHA1 Hash: 063BC26ED45C50D3745CCAD52DD7B3F3CE13F36D
	* Direct Download: http://msdn.microsoft.com/subscriptions/json/GetDownloadRequest?brand=MSDN&locale=en-us&fileId=50573&activexDisabled=true&akamaiDL=false



[01]:https://store.ecompanystore.com/microsoft/Shop/#/
[02]:https://www.microsoft.com/en-us/software-download/windows10ISO
[04]:https://en.wikipedia.org/wiki/ISO_9660
[05]:http://www.tuxarena.com/static/tut_iso_cli.php
[06]:https://thomas-cokelaer.info/blog/2011/05/how-to-create-an-iso-image-from-a-folder-linux/

