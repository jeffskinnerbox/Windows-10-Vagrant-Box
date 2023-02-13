<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="https://python-deprecated.readthedocs.io/en/latest/_images/logo-full.png" title="Deprecated is increasingly used as a technical term meaning 'to recommend against using something on the grounds that it is obsolete', or 'to declare some technological feature or function to be obsolescent'.  The earliest meaning of deprecate was 'to pray against, as an evil,' and soon after this first meaning it took on the additional sense 'to express disapproval of.' Meanwhile, depreciate, the closely related word with which it is often confused, means 'to lower in value.'" align="center">
</div>

Now that multiple Vagrant boxes are available for Windows 10
(e.g. Vagrant Cloud repository [`baunegaard/win10pro-en`][35]),
I have no need to build my own Vagrant box.
You can find my much easier replacement approach in my Github repository
[`jeffskinnerbox/windows-10-pro`][36].


----


# Vagrant Box for Windows 10
Vagrant boxes for all the variants of Linux are plentiful since
this OS is (generally) open source,
but a product like MS Windows is different.
Microsoft doesn't generally give you Vagrant boxes for its product.
So I decided to create my own Windows 10 base box for Vagrant,
then on top of this base, build a Windows OS box with the Office Suite & Visio pre-installed.

Vagrant's documentation seems to discourse you from creating your own base boxes.
I suspect this is because box creation is really a task done with your virtual machine tool kit,
which is a non-trivial process to perform,
and you can save a lot of time simply using a base box someone else has created.

You'll need a [hypervisor][25] ([Virtualbox][01] in my case),
[Vagrant][02] and a Windows 10 [ISO file or disc][04].
I purchased mine from Microsoft but you can use an [Windows 10 evaluation version][03].

The basic prerequisites in creating your Windows 10 base box are:
install VirtualBox, Vagrant, Packer, RDP client xfreerdp,
and obtain Microsoft 10 OS ISO Image.

Some good sources of information are:

* [How to Build a Vagrant Box from Scratch](https://www.youtube.com/watch?v=edoDx8bzU4M)
* [How to create you own vagrant base boxes](http://kamalim.github.io/blogs/how-to-create-you-own-vagrant-base-boxes/)
* [Create a Vagrant Base Box (VirtualBox)](https://oracle-base.com/articles/vm/create-a-vagrant-base-box-virtualbox)

* [Reusable Windows VMs with Vagrant](https://rendered-obsolete.github.io/2019/02/04/vagrant.html)
* [First steps with Windows on Vagrant](https://akrabat.com/first-steps-with-windows-on-vagrant/)
* [Creating a Windows 10 Base Box for Vagrant with VirtualBox](https://huestones.co.uk/2015/08/creating-a-windows-10-base-box-for-vagrant-with-virtualbox/)
* [Create Windows 10 Vagrant Base Box](https://softwaretester.info/create-windows-10-vagrant-base-box/)

* [Create Windows Machine Builds With Packer](https://blog.ipswitch.com/create-windows-machine-builds-with-packer)
* [Jeff Geerling's Vagrant Box Packer Builds](https://github.com/geerlingguy/packer-boxes)
* [Create Vagrant boxes with Packer for rapid IT environment builds](https://searchitoperations.techtarget.com/tutorial/Create-Vagrant-boxes-with-Packer-for-rapid-IT-environment-builds)
* [Packer-Windows10](https://github.com/luciusbono/Packer-Windows10)
* [Vagrant - 9 - Windows boxes with Vagrant and Packer](https://www.youtube.com/watch?v=EgqQMDw4T4Q)


-----


# Tools Being Used

## VirtualBox
[VirtualBox][09] is a [full virtualization][07] x86 / AMD64 / Intel64 hardware architecture
(contrast this with [hardware-assisted virtualization][08]).
It creates a virtual machine (VM), aka an emulation of a computer system.
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
Its great for standup new software solutions for testing without disrupting your working system.
You can build and manage virtual machine environments in a single workflow.

Vagrant has an easy-to-use workflow, makes automation easy,
and lowers development environment setup time.
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


----


# Building Vagrant Windows 10 Base Box
While Vagrant can support supports Windows and Linux VMs,
creating an OS image is vastly different between the two.
I will show here on how use Packer & Vagrant to create a Windows 10 VM.
Here are the steps you need to do:

Prerequisites:

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads),
[Vagrant](https://www.vagrantup.com/docs/installation/),
[Packer](https://www.packer.io/intro/getting-started/install.html)
2. Install RDP Client [xfreerdp](http://www.freerdp.com/)
3. Obtain a [Windows 10 ISO file][03]

>**NOTE:** See the following for some guidance:
>
>* VirtualBox - ["How to Install VirtualBox 7.0 on Ubuntu 22.04"][30] and ["Fix apt-get update 'the following signatures couldn’t be verified because the public key is not available'"][31].
>* Packer - ["Install Packer"][32] and ["`packer fix` Command"][34]
>* RDP Client `xfreerdp` - ["Configure FreeRDP client on my Ubuntu server to access other desktops"][33]

## Step 1: Install the Prerequisites
Install VirtualBox, Vagrant, Packer, and the RDP client `xfreerdp`.
VirtualBox and Vagrant installation are likely familiar tools but
I'll provide install instructions for Packer and the RDP client here.

### Step 1A: Installing Packer
Packer is likely to be the least fimilar of the required tools,
so here is a short installation tutorial ([source][26]).
Packer may be installed from a pre-compiled binary or from source.
The easy and recommended method for all users is binary installation method.
Check the latest release of Packer on the [Downloads page][19].
Then download the recent version for your platform.
In my case:

```bash
# download version 1.5.1  for ubuntu
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

Packer uses builders (sometimes called a template)
to generate images and create machines for various platforms from templates.
A builder is a configuration file used to define what image is built and its format is JSON.
You can see a [full list of supported builders and their templates][05].
A builder has the following three main parts.

1. **variables** – Where you define custom variables.
2. **builders** – Where you mention all the required builder parameters.
3. **provisioners** – Where you can integrate a shell script,
ansible play or a chef cookbook for configuring a required application.

### Step 1B: Install RDP Client
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

## Step 2: Create Packer Template for Windows 10
The [Stefan Scherer][13] [packer-window GitHub repository][21]
contains Packer templates that can be used to create a wide verity of Windows boxes for Vagrant.
Stefan uses this repository to generate a
[Vagrant boxes for multiple Windows OS][23] on [Vagrant Cloud][24].

We'll clone Stefan's GitHub repository,
and then strip-out the things we don't need for our Windows 10 Vagrant box.

```bash
# change to your target directory
cd ~/src/vagrant-machines

# clone the repository
git clone https://github.com/StefanScherer/packer-windows.git ms-windows
cd ~/src/vagrant-machines/ms-windows

# remove what you don't need for windows 10
rm -f *windows_[7-8]* *windows_20*
rm -f *windows_server* *insider* *docker*
rm -f make_unattend_iso.ps1 Dockerfile CHANGELOG.md appveyor.yml AZURE.md build_windows_10.ps1 README-ami.md test.ps1 upload-vhd.ps1 fix.sh
rm -r -f ansible bin nested test

# remove un-needed answer files
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

>**NOTE:** The Packer scripts will install all Windows updates during Windows Setup.
>This is a very time consuming process and you might want to disable this.
>The [StefanScherer GitHub repository][18] shows how to do this.

>**NOTE:** Using StefanScherer's GitHub scripts,
>StefanScherer maintains a[Windows 10 Vagant box on the HashiCorp Vagrant Cloud][22].
>If you prefer, you could use StefanScherer's instead of building your own Vagrant box,
>but this box doesn't have a Microsoft license.

## Step 4: Download Microsoft Provided ISO File
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
`genisoimage` is a command-line tool for creating ISO file.
You find more details in the `~/src/vagrant-machines/ms-windows/iso/README.md` file.
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

I found these articles critical to my understanding of how to use `genisoimage`:

* [How to create a Windows bootable CD with mkisofs](http://www.g-loaded.eu/2007/04/25/how-to-create-a-windows-bootable-cd-with-mkisofs/)
* [How to Create Bootable Windows 10 image in Debian?](https://unix.stackexchange.com/questions/312488/how-to-create-bootable-windows-10-image-in-debian)

## Step 5: Modify the Answer File
Since you need to provide a Product Key during the Packer build process,
edit the `~/src/vagrant-machines/ms-windows/answer_files/10/Autounattend.xml`
and updated it with the key that came with your ISO file.
Procedures on how to make these edits are within the comments of the file.

## Step 6: Build the Vagrant Box Using Packer
Now, start the build process using Packer to create a Vagrant box:

```bash
# build the vagrant box using purchased physical version of ms windows 10 pro
packer build --only=virtualbox-iso -var 'iso_url=./iso/windows-10-pro-020120.iso' -var 'iso_checksum=5a8969afcf5c49faf3d8f7f0bddfd5517453248dec47f125a61c93f538d08625' windows_10.json

# OR - assuming you updated the script
#./build_windows_10.sh
```

The building of the Windows 10 OS will take several hours (its Microsoft after all).
You'll know when the Packer build is complete when the script terminate
and trace messages are no long printed.

>**NOTE:** Early in the boot-up of the VirtualBox,
>I get prompted for "Select the operating system you want to install"
>and a menu from the MS Windows install script.
>Appears there is a missing response in the
>`~/src/vagrant-machines/ms-windows/answer_files/10` file.

## Step 7: Build the Vagrant Box
Now that `packer` has completed building the box,
next we want to make this box available for use by adding it to our list of available boxes.
The follow commands adds the new box to the list of currently available boxes.

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

## Step 8: Test the Build
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

Check that the Product Key has in fact been installed.
Check the status of the license by opening the
**Settings** app and click **Update & Security**.
Open **Activation** and it should state the product is already activated.

Another method is to open a PowerShell Admin window session and enter the following commandline:

```bash
# print the product key
wmic path softwareLicensingService get OA3xOriginalProductKey
```

>**NOTE:** You can only have a single active license for MS Windows,
>so you might not get a positive response to having an active license.
>Check out the article ["How to Transfer your Windows 10 License to a New Computer"][27]
>to resolve this issue.

## Step 9: Access Host Filesystem
Within MS Windows 10,
open a Explorer window and select **Network**
and you'll notice "File sharing is turned off...".
Click to change it.
This will give you access to the Vagrant host computer filesystem.

Once satisfied all is working well, run the following to clear out test environment:

```bash
# remove local version of the vagrant box
vagrant destroy
rm -f -r ~/tmp/test-windows-10
```


----


# Build Box with MS Office, Visio, and TurboTax
I also have software downloads for MS Office, Visio, and a TurboTax CD.
I want to install them on top of the Windows 10 base box.
My MS Office & Visio files are in `~/src/vagrant-machines/ms-windows` and called:

```
# office pro and visio install programs located in ~/src/vagrant-machines/ms-windows/iso
Setup.Def.en-US_Professional2019Retail_0d3ef3f9-ae67-4b97-a856-fff4d491ba2c_TX_PR_Platform_def_.exe
Setup.Def.en-US_VisioStd2019Retail_0738b055-a809-4718-9a19-bfc2ec63bb9f_TX_PR_Platform_def_.exe
```

My TurboTax is on a CD-ROM and I want to load that software directly from the CD.
To do this, I need the CD/DVD optical reader on my host computer to share with the MS Windoes 10 guest VM.

## Step 1: Create Your Windows 10 VM Vagrantfile
Using the Vagrant base box we just create,
create a VM instance for your working version of MS Windows 10.

```bash
# make diretory where your ms window 10 will reside
mkdir ~/src/vagrant-machines/windows-10
cd ~/src/vagrant-machines/windows-10

# initialize the vagrant environment
cp ~/src/vagrant-machines/ms-windows/vagrantfile-windows_10.template Vagrantfile
```

With this, you can create an envirnment that will look like the base box.
The remaining steps converts this into your working Windows 10 envirnment.

## Step 2: Access CD/DVD Reader
To allow the VM to access the host's optical drive,
add the following to the Vagrantfile:

```
   .
   .
    # add access to host optical drive
    config.vm.provider :virtualbox do |v, override|
        v.customize ["storagectl", :id, "--name", "SATA Controller", "--add", "sata",  "--controller", "IntelAHCI"]
        v.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", "0", "--device", "0", "--type", "dvddrive", "--hotpluggable", "on", "--medium", "host:/dev/sr0"]
    end
   .
   .
```

To derive the Vagrantfile update,
I experimented with provisioning VirtualBox directly using [VBoxManage][29],
settling on the following as working code:

```bash
# get the list of VMs that are running
$ vboxmanage list runningvms
"rsyslog-test_default_1581097326775_97773" {5bf0edd8-8fde-48fa-9532-f9cfdae98ae0}
"windows-10_Windows10BaseBox_1581212590774_74597" {856f4ebb-3f51-4138-a51a-2091bf2ab296}

# add a virtual SATA controller and point to physical DVD drive
VM="windows-10_Windows10BaseBox_1581212590774_74597"
vboxmanage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
vboxmanage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --hotpluggable on --medium host:/dev/sr0
```

Sources used to understand what was needed:

* [Create VirtualBox VM from the command line](http://www.perkin.org.uk/posts/create-virtualbox-vm-from-the-command-line.html)
* [Vagrant - Adding a second hard drive](https://everythingshouldbevirtual.com/virtualization/vagrant-adding-a-second-hard-drive/)
* [Add an empty optical drive to Oracle VirtualBox instance with the Vagrantfile](https://medium.com/@njeremymiller/add-an-empty-optical-drive-to-oracle-virtualbox-instance-with-the-vagrantfile-523e8e9114be)
* [How to add storage settings to Vagrant file?](https://stackoverflow.com/questions/21986511/how-to-add-storage-settings-to-vagrant-file)
* [FIX FOR VBOXMANAGE: ERROR: COULD NOT FIND A CONTROLLER NAMED ‘SATA’ ERROR](https://www.minvolai.com/fix-for-vboxmanage-error-could-not-find-a-controller-named-sata-error/)

## Step 3: Install Office Pro and Visio
I could use a Vagrantfile to do this install but my skills in PowerShell
are nearly non-existent.
Therefore, I'll be doing the old fashion manual way.
I will login into the Windows 10 VM and install the Office Pro and Visio packages manually.

First thing we must do is create links to these package in our working directory on the host computer
so we can do the install.

```bash
# symbolic link to office pro setup executable
ln -s ~/src/vagrant-machines/ms-windows/iso/Setup.Def.en-US_Professional2019Retail_0d3ef3f9-ae67-4b97-a856-fff4d491ba2c_TX_PR_Platform_def_.exe setup_office_pro.exe

# symbolic link to visio setup executable
ln -s ~/src/vagrant-machines/ms-windows/iso/Setup.Def.en-US_VisioStd2019Retail_0738b055-a809-4718-9a19-bfc2ec63bb9f_TX_PR_Platform_def_.exe setup_visio.exe

# symbolic link to file containing product keys
ln -s ~/src/vagrant-machines/ms-windows/iso/README-secret.md README-secret.md
```

Now lets bring up the VM:

```bash
# bring up the vm (first issues will take long time, in typical Microsoft fashion)
vagrant up
```

Next, login to the VM,
establish access to your working directory on the Vagrant host machine,
and then execute the setup programs.

1. Execute `vagrant rdp &` with the host machine.
2. Within MS Windows 10,
open a Explorer window and select **Network**
and you'll notice "File sharing is turned off...".
Click to change it.
This will give you access to the Vagrant host computer filesystem.
3. Within Explorer, select **Network** > **VBOXSVR** > **\\VBOXSVR\vagrant**
4. Execute `setup_office_pro.exe` and `setup_visio.exe` to install Office Pro and Visio.
5. To install TurboTax, place the CD in the optical drive and execute the setup script.

>**NOTE:** You may want to run this
>`xfreerdp /u:vagrant /p:vagrant /v:127.0.0.1:3389`
>to clear out certificates problems if vagrant rdp fails.

## Step 4: Apply Product Keys
Check the status of the license by opening the
**Settings** app and click **Update & Security**.
Open **Activation** and it should state the product is already activated.

## Step 5: Make It Another Box
I could decide to create a new Vagrant base box from this new VM using [this method][28],
but I see no purpose at this time.



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
[19]:https://packer.io/downloads.html
[20]:https://www.vagrantup.com/
[21]:https://github.com/StefanScherer/packer-windows
[22]:https://app.vagrantup.com/StefanScherer/boxes/windows_10
[23]:https://app.vagrantup.com/StefanScherer/
[24]:https://app.vagrantup.com/boxes/search
[25]:https://en.wikipedia.org/wiki/Hypervisor
[26]:https://computingforgeeks.com/how-to-install-and-use-packer/
[27]:https://www.groovypost.com/howto/transfer-windows-10-license-new-pc/
[28]:https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one
[29]:https://docs.oracle.com/cd/E97728_01/E97727/html/vboxmanage-intro.html
[30]:https://tecadmin.net/how-to-install-virtualbox-on-ubuntu-22-04/
[31]:https://chrisjean.com/fix-apt-get-update-the-following-signatures-couldnt-be-verified-because-the-public-key-is-not-available/
[32]:https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli
[33]:https://stackoverflow.com/questions/58215340/configure-freerdp-client-on-my-ubuntu-server-to-access-other-desktops
[34]:https://developer.hashicorp.com/packer/docs/commands/fix
[35]:https://app.vagrantup.com/baunegaard/boxes/win10pro-en/versions/1.4.0
[36]:https://github.com/jeffskinnerbox/windows-10-pro
[37]:
[38]:

