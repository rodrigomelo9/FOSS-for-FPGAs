# Getting started with FOSS for FPGAs

[![License](https://img.shields.io/github/license/rodrigomelo9/FOSS-for-FPGAs.svg?longCache=true)](https://github.com/rodrigomelo9/FOSS-for-FPGAs/blob/main/LICENSE)
[![Doc generation status](https://img.shields.io/github/workflow/status/rodrigomelo9/FOSS-for-FPGAs/doc?longCache=true&label=doc)](https://github.com/rodrigomelo9/FOSS-for-FPGAs/actions/workflows/doc.yml)
[![Examples status](https://img.shields.io/github/workflow/status/rodrigomelo9/FOSS-for-FPGAs/doc?longCache=true&label=examples)](https://github.com/rodrigomelo9/FOSS-for-FPGAs/actions/workflows/examples.yml)

The Free and Open-Source Software (FOSS) ecosystem for digital hardware design, to work with devices such as FPGAs and ASICs, is growing and can be difficult to know the alternatives and be up-to-date.
Our aim is to provide a gentle introduction to the main development tools, in a common place.

## Talks

* 2021-05-18 - [Ciclo de charlas sobre la EDU-CIAA-FPGA](https://www.youtube.com/channel/UCmdz7OJ4p64Jh7GRFJqhHqQ)
  * [video](https://www.youtube.com/watch?v=IKDzkQ1zg2g) (Spanish)
  * [slides](https://github.com/rodrigomelo9/FOSS-for-FPGAs/tree/f92dfc4b1e12b47b9e02ebc9f9ad46cd24bb6b98) (tag 2021-05-18)
* 2021-02-10 - [Joint ICTP-IAEA School on FPGA-based SoC and its Applications for Nuclear and Related Instrumentation](http://indico.ictp.it/event/9443/other-view?view=ictptimetable)
  * [video](http://video.ictp.it/WEB/2021/2021_01_25-smr3562/2021_02_10-11_00-smr3562.mp4) (English)
  * [slides](http://indico.ictp.it/event/9443/session/258/contribution/587/material/slides/0.pdf)

## Requisites to reproduce the presentation and run the exercises

### To create the presentation

Install *reveal-md*:
```bash
apt install npm
npm install -g reveal-md
```

Then create the presentation:
```bash
cd slides
make
```

And open `_build/index.html` with a web browser.

### To run the exercises

> **NOTE:** this instructions are for x86_64/amd64 architectures of Ubuntu (>= 16.04) and Debian (>= 9).
> Other alternatives or more details at [Install Docker Engine](https://docs.docker.com/engine/install).

#### Docker installation

As root:
```bash
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr [:upper:] [:lower:])/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr [:upper:] [:lower:]) $(lsb_release -cs) stable"
apt update
apt install -y docker-ce docker-ce-cli containerd.io
```

> **NOTE:** or with the alternative `curl -fsSL https://get.docker.com/ | sh -`.

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
