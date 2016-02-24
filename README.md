# Setup scripts for my Ubuntu 14.04 LTS Server
Here is my collection of setup scripts for my Ubuntu server.

## Table of content

1. [Usage](#usage)
  1.  [Initial Setup](#01---initial-setup)
  2.  [Google Authenticator](#02---google-authenticator)
  3.  [zsh Shell (oh-my-zsh)](#03---zsh-shell)
  4.  [Docker.io](#04---docker.io)
  5.  [OpenVPN Server](#05---openvpn)
  6.  [OpenVPN Client Certificates](#06---openvpn-client-certificates)

## Usage

### 01 - Initial Setup
This script has to be called as user **root**. It will perform a update && (dist)upgrade, install ntp, adds a new user and puts this user into sudoers.d.
Moreover the ssh root login will be disabled.

#### Usage(#usage)
```bash
./01-initial-setup.sh <username> [NOPASSWD]
```

##### Mandatory Parameters
**&lt;username&gt;** - the username for the new user to add

##### Optional Parameters
**NOPASSWD** - If set, the sudoers entry will have the NOPASSWD flag

### 02 - Google Authenticator
This script will install the libpam-google-authenticator package and changes the ssh configuration for the calling user to force ssh login with two factor authentication

#### Usage
```bash
./02-authenticator.sh
```

### 03 - zsh shell
This script will install zsh (and git and curl as dependency) and oh-my-zsh, and sets this shell as default.
The default theme will be set to **crunch**.
The default plugins will be set to **git** and **docker**.

#### Usage
```bash
./03-zsh-shell.sh
```

### 04 - Docker.io
This script will install docker (and its dependecies) and enables the calling user to call docker commands without sudo.
Moreover the default docker behavior for iptables will be disabled.

#### Usage
```bash
./04-docker.sh
```

### 05 - OpenVPN
This script will install OpenVPN as a docker container. For this, two containers are created: __OpenVPN-Data__ and __OpenVPN-Server__. With the __OpenVPN-Data__-container, a new folder to store the certificates will be created at /home/$(whoami)/docker/openvpn.
At last an upstart script is created to ensure, this container is always started.

#### Usage
```bash
./05-openvpn.sh <fqdn>
```

##### Mandatory Parameters
**&lt;fqdn&gt;** - a full qualified domain name for your OpenVPN server

### 06 - OpenVPN client certificates
This script will create a OpenVPN .ovpn file including a certificate to use with your client. This file is located at /home/$(whoami)/docker/openvpn.

#### Usage
```bash
./06-openvpn-certificates.sh <clientname>
```

##### Mandatory Parameters
**&lt;clientname&gt; - The hostname of your client

https://de.ssl-tools.net/
