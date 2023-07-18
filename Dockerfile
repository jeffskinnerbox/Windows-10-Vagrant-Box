FROM ubuntu:jammy

WORKDIR /home/project

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && apt-get install -y freerdp2-x11 wget lsb-release gnupg virtualbox

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt update && apt install -y vagrant 

RUN export VER="1.5.1" \
    && wget https://releases.hashicorp.com/packer/${VER}/packer_${VER}_linux_amd64.zip \
    && unzip packer_${VER}_linux_amd64.zip \
    && mv packer /usr/local/bin \
    && packer --help

