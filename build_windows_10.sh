#!/bin/bash


# build the vagrant box using purchased physical version of ms windows 10 pro
#packer build --only=virtualbox-iso -var 'iso_url=./iso/windows-10-pro-012020.iso' -var 'iso_checksum=07a055219c89f20ec5a5edf50399d09c0fbbe7c9cae173363c8f96cbb6f803e1' windows_10.json

# build the vagrant box using downloaded evaluation copy of windows 10 x64 enterprise
#packer build --only=virtualbox-iso -var 'iso_url=./iso/18363.418.191007-0143.19h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso' -var 'iso_checksum=9ef81b6a101afd57b2dbfa44d5c8f7bc94ff45b51b82c5a1f9267ce2e63e9f53' windows_10.json

# using https://www.microsoft.com/en-us/software-download/windows10ISO
# build the vagrant box using downloaded windows 10 disk image
packer build --only=virtualbox-iso -var 'iso_url=./iso/Win10_1909_English_x64.iso' -var 'iso_checksum=01bf1eb643f7e50d0438f4f74fb91468d35cde2c82b07abc1390d47fc6a356be' windows_10.json
