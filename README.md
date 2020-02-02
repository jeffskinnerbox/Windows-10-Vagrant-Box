<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->

<p style="text-align: center;">
![work-in-progress](http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg "These materials require additional work and are not ready for general use.")
</p>

----

# Vagrant Box for Windows 10
Vagrant boxes for all the variants of Linux are plentiful since
it is (generally) open source but a product like MS Windows is different.
Microsoft doesn't generally give you Vagrant boxes for its product.
So I decided to create my own Windows 10 base box for Vagrant,
then on top of this base, create a Windows OS box with the Office Suite & Visio pre-installed.

I read a few articles about creating Windows 10 base boxes for Vagrant.

Vagrant's documentation seems to discourse you from creating your own base boxes.
I suspect this is because box creation is really a task done with your virtual machine tool kit,
which is a non-trivial process to perform,
and you can save a lot of time simply using a base box someone else has created.

You'll need a virtual machine ([Virtualbox][01] in my case),
[Vagrant][02] and a Windows 10 ISO file or disc.
I purchased mine from Microsoft but you can use an [Windows 10 evaluation version][03].

The basic steps in creating your Windows 10 base box is:

* Prerequisites: installed VirtualBox and Vagrant
* Microsoft 10 OS image

Sources:

* [Vagrant - 9 - Windows boxes with Vagrant and Packer](https://www.youtube.com/watch?v=EgqQMDw4T4Q)
* [How to Build a Vagrant Box from Scratch](https://www.youtube.com/watch?v=edoDx8bzU4M)
* [Create Windows 10 Vagrant Base Box](https://softwaretester.info/create-windows-10-vagrant-base-box/)
* [Reusable Windows VMs with Vagrant](https://rendered-obsolete.github.io/2019/02/04/vagrant.html)
* [Creating a Windows 10 Base Box for Vagrant with VirtualBox](https://huestones.co.uk/2015/08/creating-a-windows-10-base-box-for-vagrant-with-virtualbox/)
* [First steps with Windows on Vagrant](https://akrabat.com/first-steps-with-windows-on-vagrant/)
* [Create a Vagrant Base Box (VirtualBox)](https://oracle-base.com/articles/vm/create-a-vagrant-base-box-virtualbox)
* [Create a Vagrant Base Box (VirtualBox)](https://oracle-base.com/articles/vm/create-a-vagrant-base-box-virtualbox)
* [How to create you own vagrant base boxes](http://kamalim.github.io/blogs/how-to-create-you-own-vagrant-base-boxes/)

* https://www.packer.io/intro/getting-started/build-image.html#a-windows-example
* Packer-Windows10 - https://github.com/luciusbono/Packer-Windows10
* [Create Windows Machine Builds With Packer](https://blog.ipswitch.com/create-windows-machine-builds-with-packer)

* [Creating a Windows 10 Base Box for Vagrant with VirtualBox](https://huestones.co.uk/2015/08/creating-a-windows-10-base-box-for-vagrant-with-virtualbox/)
* [Create Windows 10 Vagrant Base Box](https://softwaretester.info/create-windows-10-vagrant-base-box/)

* [Create Vagrant boxes with Packer for rapid IT environment builds](https://searchitoperations.techtarget.com/tutorial/Create-Vagrant-boxes-with-Packer-for-rapid-IT-environment-builds)

Ubuntu example - https://github.com/geerlingguy/packer-boxes/blob/master/README.md


-----


# Tools Being Used

## VirtualBox
[VirtualBox][09] is a [full virtualization][07] x86 / AMD64 / Intel64 hardware architecture
(contrast this with [hardware-assisted virtualization][08]).
It creates a [virtual machine (VM)][06], aka an emulation of a computer system.
Virtual machines (VM) behave like a separate computer system,
complete with virtual hardware devices.
The VM runs as a process in a window on your current operating system.
You can boot an operating system installer disc (or live CD) inside the virtual machine,
and the operating system will be “tricked” into thinking it’s running on a real computer.
It will install and run just as it would on a real, physical machine.

## Vagrant
[Vagrant][20] is a tool that offers a simple and easy to use
command-line client for managing virtual environments created by the most popular
virtualization platforms like VirtualBox, VMWare, etc.
Its great for standup new software solutions for testing without disrupting my working system.
You can build and manage virtual machine environments in a single workflow.
Vagrant has an easy-to-use workflow, makes automation easy, and lowers development environment setup time.
Machines are provisioned on top of VirtualBox, VMware, AWS, or any other provider.
Then, industry-standard provisioning tools such as
shell scripts, Chef, or Puppet, can automatically install
and configure software on the virtual machine.

## Packer
The creation of a Vagrant box starts with the creation of VM using virtualization tool like VirtualBox.
This is often a manual process, using a GUI or CLI,
and is very different for all the virtualization tools on the market (e.g. VitrualBox, VMWare, etc.).
Unfortunately, this doesn't fit the modern paradigm of [infrastructure as code][14].

To overcome this, the creates of Vagrant, [HasiCorp][15], offer a tool called [Packer][16].
[Why Use Packer][11]?
Packer embraces modern configuration management automates the creation of any type of machine image.
Packer is an open source tool for creating identical 'machine images'
for multiple virtualization tools from a single source configuration.
Packer runs on every major operating system, and creates machine images for multiple platforms in parallel.
Packer does not replace [configuration management][17] tools like Ansible, Chef, or Puppet.
In fact, when building images,
Packer is able to use configuration management tools to install software onto the image.
Packer lets you build Virtual Machine images for different providers from one JSON file.
You can use the same file and commands to build an image on AWS, Digital Ocean VirtualBox and Vagrant.
This makes it possible to use exactly the same system for development which you then create in production.

>**NOTE:** A 'machine image' is a single static unit that contains a pre-configured operating system
>and installed software which is used to quickly create new running machines.
>Machine image formats change for each platform.
>Some examples include AMIs for an AWS EC2,VMDK/VMX files for VMware, OVF exports for VirtualBox, etc.

## Installing Packer
Packer may be installed from a precompiled binary or from source.
The easy and recommended method for all users is binary installation method.
Check the latest release of Packer on the [Downloads page][04].
Then download the recent version for your platform.
In my case:

```bash
# downlaod version 1.5.1  for ubuntu
cd ~/tmp
export VER="1.5.1"
wget https://releases.hashicorp.com/packer/${VER}/packer_${VER}_linux_amd64.zip

# uncompress the download file
unzip packer_${VER}_linux_amd64.zip

# move the packer binary into your path
sudo mv packer /usr/local/bin

# verify the install is working
$ packer --help
Usage: packer [--version] [--help] <command> [<args>]

Available commands are:
    build       build image(s) from template
    console     creates a console for testing variable interpolation
    fix         fixes templates from old versions of packer
    inspect     see components of a template
    validate    check that a template is valid
    version     Prints the Packer version
```

## How to Use Packer
Packer uses builders to generate images and create machines for various platforms from templates.
A template is a configuration file used to define what image is built and its format is JSON.
You can see a [full list of suppported builders and their templates][05].
A template has the following three main parts.

1. **variables** – Where you define custom variables.
2. **builders** – Where you mention all the required builder parameters.
3. **provisioners** – Where you can integrate a shell script,
ansible play or a chef cookbook for configuring a required application.

In my example, I will use [VirtualBox Builder][06] to create an
Ubuntu 19.04 VirtualBox Virtual Machine.
[This VirtualBox Packer builder][10] is able to create VirtualBox virtual machines
and export them in the OVF format,
starting from an existing OVF/OVA (exported virtual machine image).

>**NOTE:** When exporting from VirtualBox make sure to choose OVF Version 2,
>since Version 1 is not compatible and will generate errors.

The builder builds a virtual machine by importing an existing OVF or OVA file.
It then boots this image, runs provisioners on this new VM,
and exports that VM to create the image.
The imported machine is deleted prior to finishing the build.

### Step 1:
Here is a basic build template
https://computingforgeeks.com/how-to-install-and-use-packer/
https://devopscube.com/packer-tutorial-for-beginners/


----


# MS-Windows Guest on Linux Host with Vagrant
* [How to Install and use Packer on Ubuntu 18.04](https://computingforgeeks.com/how-to-install-and-use-packer/)
* [Creating a Windows 10 Base Box for Vagrant with VirtualBox](https://huestones.co.uk/2015/08/creating-a-windows-10-base-box-for-vagrant-with-virtualbox/)

vagrant init StefanScherer/windows_10
vagrant up

* [Create Windows Machine Builds With Packer](https://blog.ipswitch.com/create-windows-machine-builds-with-packer)
* https://github.com/StefanScherer/packer-windows

Here are the steps you need to do:

1. Prerequisites: Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads),
[Vagrant](https://www.vagrantup.com/docs/installation/),
[Packer](https://www.packer.io/intro/getting-started/install.html),
and install RDP Client [Remmina](https://www.ubuntupit.com/how-to-install-remmina-remote-desktop-client-in-ubuntu-linux/)
2. Download [Windows 10 ISO file][03] for Vagrant Base Box
3. [Create Windows 10 VirtualBox VM](https://softwaretester.info/create-windows-10-virtualbox-vm/)

# Step 1: Install the Prerequisites - DONE
Install VirtualBox, Vagrant, and Packer.
You can find instructions for this at
`/home/jeff/blogging/content/ideas/using-vagrant-docker-and-ansible.md`.
You'll also need to install an RDP client but procedures for that are included below.

# Step 2: Install RDP Client - DONE
Vagrant will not SSH into a Windows VM, but instead,
needs to use Microsoft's Remote Desktop Protocol (RDP).
Vagrant requires either the RDP client's `xfreerdp` or `rdesktop`
in order to connect into the Vagrant environment.

```bash
# install vagrant supported rdp client xfreerdp
sudo apt-get -y install freerdp2-x11
```

>**NOTE:** [Remmina][12] is Ubuntu's default remote desktop client but Vagrant can't use it.
>Remmina supports multiple network protocols in an integrated & consistent user interface.
>The protocols currently supported are:
>RDP (Remote Desktop Protocol), VNC (Virtual Network Computing),
>NX (NoMachine NX / FreeNX), XDMCP (X Display Manager Control Protocol)
>and SSH (Secure Shell / Open SSH).

# Step 3: Create Packer Template for Windows 10 - DONE
The [Stefan Scherer][13] [packer-window GitHub repository][21]
contains Packer templates that can be used to create a wide verity of Windows boxes for Vagrant.
Stefan uses this repository to generate a
[Vagrant boxes for multiple Windows OS][23] on [Vagrant Cloud][24].

We'll clone Stefan's GitHub repository,
and then strip-out the things we don't need for our Windows 10 Vagrant box.

```bash
# change to your target dirctory
cd ~/src/vagrant-machines

# clone the repository
git clone https://github.com/StefanScherer/packer-windows.git ms-windows
cd ~/src/vagrant-machines/ms-windows

# remove what you don't need for windows 10
rm -f *windows_[7-8]* *windows_20*
rm -f *windows_server* *insider* *docker*
rm -f make_unattend_iso.ps1 Dockerfile CHANGELOG.md appveyor.yml AZURE.md build_windows_10.ps1 README-ami.md test.ps1 upload-vhd.ps1 fix.sh
rm -r -f ansible bin nested test

# remove unneeded answer files
rm -r -f ./answer_files/20* ./answer_files/8* ./answer_files/7* ./answer_files/server*
rm -r -f 10_insider 10_insider_uefi

# modify the README.md file
mv README.md README-stefanscherer.md

# modify the packer template for windows 10
sed -i 's/vagrant-windows-10-preview/Windows 10 Base Box/' vagrantfile-windows_10.template
sed -i 's/windows_10_preview/windows10base/' vagrantfile-windows_10.template

# modify the build script for windows 10
cat <<'EOF' > build_windows_10.sh
#!/bin/bash
packer build --only=virtualbox-iso --var iso_url=./iso/windows-10-pro-012020.iso windows_10.json
EOF

# validate the packer template
packer validate --only=vmware-iso --only=virtualbox-iso windows_10.json
# OR
./validate.sh
```

Now make these modifications your starting point for your
version of this repository:

```bash
# destroy the old repository, but not .gitignore
rm -r -f .git .gitattributes

# create a new repository and check in the changes
git init
git add --all
git commit -m"jeffskinnerbox version of StefanScherer GitHub repository"
```

>**NOTE:**The Packer scripts will install all Windows updates during Windows Setup.
>This is a very time consuming process and you might want to disable this.
>The [StefanScherer GitHub repository][18] shows how to do this.

>**NOTE:** Using StefanScherer's GitHub scripts,
>StefanScherer maintains a[Windows 10 Vagant box on the HashiCorp Vagrant Cloud][22].
>If you prefer, you could use StefanScherer's instead of building your own Vagrant box,
>but this box doesn't have a Microsoft license.

# Step 4: Download Microsoft Provided ISO File - DONE
################################################################################
* [How to Create Bootable Windows 10 image in Debian?](https://unix.stackexchange.com/questions/312488/how-to-create-bootable-windows-10-image-in-debian)
* [How to create a Windows bootable CD with mkisofs](http://www.g-loaded.eu/2007/04/25/how-to-create-a-windows-bootable-cd-with-mkisofs/)
* [How-To: Create ISO Images from Command-Line](http://www.tuxarena.com/static/tut_iso_cli.php)
* [Step by Step Guide to Make ISO Images in Ubuntu](http://www.tuxarena.com/static/tut_iso_ubuntu.php)
* [How to Make a Bootable CD/DVD/USB to Install Windows](https://www.makeuseof.com/tag/make-bootable-usb-cd-dvd-install-windows-using-iso-file/)
################################################################################
################################################################################
# http://www.g-loaded.eu/2007/04/25/how-to-create-a-windows-bootable-cd-with-mkisofs/
genisoimage -b boot/etfsboot.com -no-emul-boot -boot-load-seg 1984 -boot-load-size 4 -iso-level 2 -J -l -D -N -R -joliet-long -relaxed-filenames -V "VIRTUALBOX-CD" -o ~/src/vagrant-machines/ms-windows/iso/test-windows.iso /media/jeff/WINDOWS10/x64

$ sha256sum iso/test-windows.iso
bddc85d98971324821a6222d5bec1e7256f0ef4893fa0882d29e2910a7b3b162  iso/test-windows.iso

packer build --only=virtualbox-iso -var 'iso_url=./iso/test-windows.iso' -var 'iso_checksum=bddc85d98971324821a6222d5bec1e7256f0ef4893fa0882d29e2910a7b3b162' windows_10.json
################################################################################
################################################################################
# https://unix.stackexchange.com/questions/312488/how-to-create-bootable-windows-10-image-in-debian
genisoimage -no-emul-boot -b boot/etfsboot.com -boot-load-seg 0x07C0 -boot-load-size 8 -iso-level 2 -udf -joliet -R -D -N -relaxed-filenames -o iso/test-windows.iso /media/jeff/WINDOWS10/x64

$ sha256sum iso/test-windows.iso
437801a052e8c91425f69f39eae5b6053c1a74991eb2cd8b9819dbf32d2f077d  iso/test-windows.iso

packer build --only=virtualbox-iso -var 'iso_url=./iso/test-windows.iso' -var 'iso_checksum=437801a052e8c91425f69f39eae5b6053c1a74991eb2cd8b9819dbf32d2f077d' windows_10.json
################################################################################
################################################################################
```bash
# generate a checksum for purchased physical version of ms windows 10 pro
cd ~/src/vagrant-machines/ms-windows/iso
$ sha256sum windows-10-pro-020120.iso
07a055219c89f20ec5a5edf50399d09c0fbbe7c9cae173363c8f96cbb6f803e1 windows-10-pro-012020.iso

# generate a checksum for downloaded evaluation copy of windows 10 x64 enterprise
cd ~/src/vagrant-machines/ms-windows/iso
$ sha256sum 18363.418.191007-0143.19h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso
9ef81b6a101afd57b2dbfa44d5c8f7bc94ff45b51b82c5a1f9267ce2e63e9f53  18363.418.191007-0143.19h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso

# generate a checksum for downloaded windows 10 disk image
cd ~/src/vagrant-machines/ms-windows/iso
$ sha256sum Win10_1909_English_x64.iso
01bf1eb643f7e50d0438f4f74fb91468d35cde2c82b07abc1390d47fc6a356be Win10_1909_English_x64.iso
```
################################################################################


You'll need to place a ISO file in `~/src/vagrant-machines/ms-windows/iso`
containing your MS Windows 10 OS,
where the Packer build script `windows_10.json` will pick it up.
You have three options for getting this ISO file:

1. You can download an evaluation copy of Windows 10 x64 Enterprise ([here][03]).
Ultimately, you might need a purchase a licensed version of Windows 10
but this evaluation copy gives you 90 days of free use.
2. **This is what I did:**
Purchase a physical version of MS Windows 10 Pro
and create your own [ISO 9660 filesystem image][04].
To do this, you can use [`genisoimage`][05] & some advice from [here][06].
`genisoimage` is a command-line tool for creating ISO file which can be
burnt after to a CD or DVD using `wodim` or some other burning tool.
3. Download an active Windows 10 Disc Image ([here][10]) which requires a Product Key.
You can't use the product key from the purchase referenced above, but instead,
purchase the product key from Microsoft.

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

Create a check sum that will be used within the `packer` tool.

```bash
# generate a checksum for purchased physical version of ms windows 10 pro
cd ~/src/vagrant-machines/ms-windows/iso
$ sha256sum windows-10-pro-020120.iso
5a8969afcf5c49faf3d8f7f0bddfd5517453248dec47f125a61c93f538d08625  windows-10-pro-020120.iso
```

These articles where critical to understanding how to use `genisoimage`:

* [How to create a Windows bootable CD with mkisofs](http://www.g-loaded.eu/2007/04/25/how-to-create-a-windows-bootable-cd-with-mkisofs/)
* [How to Create Bootable Windows 10 image in Debian?](https://unix.stackexchange.com/questions/312488/how-to-create-bootable-windows-10-image-in-debian)

# Step 5: Modify the Answer File - DONE
Since you need to provide a Product Key during the Packer build process,
edit the `~/src/vagrant-machines/ms-windows/answer_files/10/Autounattend.xml`
and updated it with the key that came with your ISO file.
Procedures on how to make these edits are within the comments of the file.

# Step 6: Build the Vagrant Box Using Packer - DONE
Now, start the build process using Packer to create a Vagrant box:

```bash
# build the vagrant box using purchased physical version of ms windows 10 pro
packer build --only=virtualbox-iso -var 'iso_url=./iso/windows-10-pro-020120.iso' -var 'iso_checksum=5a8969afcf5c49faf3d8f7f0bddfd5517453248dec47f125a61c93f538d08625' windows_10.json

# OR - assuming you updated the script
#./build_windows_10.sh
```

The building of the Windows 10 OS will take several hours (its Microsoft after all).
You'll know when the Packer build is complete when the script terminate
and trace messages  are no long printed.

>**NOTE: Early in the boot-up of the VirtualBox,
>I get prompted for "Select the operating system you want to install"
>and a menu from the MS Windows install script.
>Appears there is a missing response in the
>`~/src/vagrant-machines/ms-windows/answer_files/10` file.

# Step 7: Build the Vagrant Box - DONE
Now that `packer` has completed building the box,
next we want to make this box available for use by adding it to our list of available boxes.
The follow commands addsa the new box to the list of currently available boxes.

```bash
# install the vagrant box in your local repository
#vagrant box add windows10base ./windows_10_virtualbox.box
vagrant box add --name windows10base ./windows_10_virtualbox.box

# check to see the box is in the local repository
vagrant box list

# remove the built box now that its in the repository
rm windows_10_virtualbox.box
```

Now you have the box and you can use it like any other box
by referencing it in a `Vagrantfile` for a new build.

If you wise to remove the box from the local repository,
use the command `vagrant box remove windows10base`.

# Step 8: Test the Build  - DONE
Now lets test if the newly created Vagrant box in fact works.
You can login into the VM using “vagrant” as user name and “vagrant” as a password,
but first we need to initialize our test environment:

```bash
# create your test environment
mkcd ~/tmp/test-windows-10

# initialize the vagrant environment
vagrant init
cp ~/src/vagrant-machines/ms-windows/vagrantfile-windows_10.template Vagrantfile

# may want to run this to clear out certificates
xfreerdp /u:vagrant /p:vagrant /v:127.0.0.1:3389

# bring up the vm (first issues will take long time, in typical Microsoft fashion)
vagrant up

# log into the ms windows 10 vm
vagrant rdp
```

>**NOTE:** When doing the `vagrant up`, you might hang on the trace message
>"==> Windows 10 Base Box: Also, verify that the firewall is open to allow RDP connections."
>This is most like due to an old certificates in `~/.config/freerdp/known_hosts2`.
>You can see this clearly if you run `xfreerdp /u:vagrant /p:vagrant /v:127.0.0.1:3389`.
>Clean out the old certificate and your should then be able to use `vagrant rdp` without problem.

check that the Product Key has in fact be installed.
Check the status of the license by openning the
**Settings** app and click **Update & Security**.
Open **Activation** and it should state the product is already activated.

Another method is to open a PowerShell Admin window session and enter the following commandline:

```bash
# print the product key
wmic path softwareLicensingService get OA3xOriginalProductKey
```

>**NOTE: **NOT TRUE --- ITS NOT ACTIVATED!!!   NOT TRUE --- ITS NOT ACTIVATED!!!   NOT TRUE --- ITS NOT ACTIVATED!!!**

Open a Explorer window and select **Network** and you'll notice "File sharing is turned off...".
Click to change it.

Once satisfied all is working well, run the following to clear out test environment:

```bash
vagrant destroy
rm -f -r ~/tmp/test-windows-10
```

# Step X: Build Box with MS Office and Visio

# Step X: Create a Vagrant Base Box from an Existing One
https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one

I also had software downloads for MS Office and Visio.
My files where:

```
18363.418.191007-0143.19h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso
Setup.Def.en-US_Professional2019Retail_0d3ef3f9-ae67-4b97-a856-fff4d491ba2c_TX_PR_Platform_def_.exe
Setup.Def.en-US_VisioStd2019Retail_0738b055-a809-4718-9a19-bfc2ec63bb9f_TX_PR_Platform_def_.exe
```

# Step X: Connect with Windows 10

```bash
# using xfreerdp directly
xfreerdp /u:vagrant /p:vagrant /v:127.0.0.1:3389

# using vagrant
vagrant rdp
```

vagrant box list

vagrant box add windows10 ./windows_10_virtualbox.box
vagrant box add --name windows10 ./windows_10_virtualbox.box

vagrant box list

vagrant up

vagrant rdp

vagrant distroy

vagrant box remove NAME




[01]:https://www.virtualbox.org/
[02]:https://www.vagrantup.com/
[03]:https://www.microsoft.com/en-us/evalcenter/evaluate-windows-10-enterprise
[04]:https://en.wikipedia.org/wiki/ISO_9660
[05]:http://www.tuxarena.com/static/tut_iso_cli.php
[06]:https://thomas-cokelaer.info/blog/2011/05/how-to-create-an-iso-image-from-a-folder-linux/
[07]:https://www.virtualbox.org/wiki/Virtualization
[08]:https://en.wikipedia.org/wiki/Hardware-assisted_virtualization
[09]:https://www.virtualbox.org/
[10]:https://www.microsoft.com/en-us/software-download/windows10ISO
[11]:https://www.packer.io/intro/why.html
[12]:https://remmina.org/
[13]:https://stefanscherer.github.io/
[14]:https://en.wikipedia.org/wiki/Infrastructure_as_code
[15]:https://www.hashicorp.com/
[16]:https://www.packer.io/
[17]:https://www.ansible.com/use-cases/configuration-management
[18]:https://github.com/StefanScherer/packer-windows#windows-updates
[19]:
[20]:https://www.vagrantup.com/
[21]:https://github.com/StefanScherer/packer-windows
[22]:https://app.vagrantup.com/StefanScherer/boxes/windows_10
[23]:https://app.vagrantup.com/StefanScherer/
[24]:https://app.vagrantup.com/boxes/search
[25]:
[26]:
[27]:
[28]:
[29]:
[30]:
