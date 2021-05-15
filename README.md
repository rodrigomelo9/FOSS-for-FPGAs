# Getting started with FOSS for FPGAs

> This project is licensed under
> [CC BY 4.0 ![CC BY 4.0 icon](https://i.creativecommons.org/l/by/4.0/80x15.png)](https://creativecommons.org/licenses/by/4.0/)

The Free and Open-Source Software (FOSS) ecosystem for digital hardware design, to work with devices such as FPGAs and ASICs, is growing and can be difficult to know the alternatives and be up-to-date.
Our aim is to provide a gentle introduction to the main development tools, in a common place.

## Requisites to reproduce the presentation and run examples

> **NOTE:** this instructions are for x86_64/amd64 architectures of Ubuntu (>= 16.04) and Debian (>= 9)

### To create the presentation

Install *reveal-md*:
```bash
apt install npm
npm install -g reveal-md
```

### To run examples

#### Docker installation

As root:
```bash
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr [:upper:] [:lower:])/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr [:upper:] [:lower:]) $(lsb_release -cs) stable"
apt update
apt install -y docker-ce docker-ce-cli containerd.io
```

> More info at [Install Docker Engine](https://docs.docker.com/engine/install)

#### Docker post-installation

As root:
```bash
groupadd docker
usermod -aG docker <YOUR_USER>
```

As user:
```bash
newgrp docker
docker version
docker run hello-world
```

> More info at [Post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall)
