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
  7.  [MailCow Prerequisites](#07---mailcow-prerequisites)
  8.  [nginx Mainline](#08---nginx-mainline)
  9.  [nginx Let's encrypt](#09---nginx-lets-encrypt)
  10.  [nginx MailCow](#10---nginx-mailcow)
  11.  [Postfix Security Fix](#11---postfix-security-fix)
  12.  [Let's Encrypt](#12---lets-encrypt)
  13.  [Let's Encrypt Certificates](#13---lets-encrypt-certificates)
  14.  [PHP IMAP Fix](#14---php-imap-fix)
  15.  [Rainloop](#15---rainloop)
  16.  [Docker Remote API](#16---docker-remote-api)
  17.  [Firewall Settings](#xx---firewall-settings)
2.  [Miscellaneous](#miscellaneous)

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
**&lt;clientname&gt;** - The hostname of your client

### 07 - MailCow Prerequisites
This script will generate new locales for en_US.UTF-8 and de_DE.UTF-8. I had some problems with the locales on my first tries.

#### Usage
```bash
./07-mailcow-prerequisites.sh
```

### 08 - nginx Mainline
This script will upgrade nginx to the mainline branch and defines a default nginx server config for a global ssl redirect

#### Usage
```bash
./08-nginx-mainline.sh
```

### 09 - nginx Let's encrypt
This script prepares the nginx to use the --webroot parameter from Let's Encrypt. Moreover, a new subdomain ist created for the acme-challenge (including a global redirct to the new subdomain).

#### Usage
```bash
./09-nginx-letsencrpyt.sh <domail.tld>
```

##### Mandatory Parameters

**&lt;domain.tld&gt;** - a new subdomain __letsencrypt.domain.tld__ will be created

### 10 - nginx MailCow
This script installs the MailCow server config to the new nginx mainline and enables HTTP/2 (supported on nginx > 1.9.5). Moreover, the letsencrypt snippet will be included and the non ssl server block deleted.

#### Usage
```bash
./10-nginx-mailcow.sh <domain.tld>
```

##### Mandatory Parameters
**&lt;domain.tld&gt;** - just the name for the mailcow config file (mailcow.domain.tld)

### 11 - Postfix Security Fix
This script modifies some security settings for postfix (including dane and dnssec support)

#### Usage
```bash
./11-postfix-fix.sh
```

### 12 - Let's Encrypt
This script installs Let's Encrypt and creates a global letsencrypt command

#### Usage
```bash
./12-letsencrypt.sh
```

### 13 - Let's Encrypt Certificates
This script creates a Let's Encrypt certificate usable for DANE. The script creates a folder in ~/build/dane/&lt;commonName&gt;/ and /etc/ssl/&lt;commonName&gt;. First one hold the generated files, second one the symbolic links for the servers (nginx, postfix, dovecot, ...)

**IMPORTANT**: I have to check the behavior if you want to expand your certificate with a new subdomain. Make a backup of the ~/build/dane/&lt;commonName&gt;/ folder if you call this more than once for a &lt;commonName&gt;!

#### Usage
```bash
./13-letsencrypt-certificates.sh <countryName> <stateOrProvince> <localityName> <postalCode> <streetAddress> <organizationName> <organizationalUnitName> <commonName> <emailAddress> <subjectAltName> [filename]
```

##### Mandatory Parameters
**&lt;countryName&gt;** - Needed for signing request, your country (e.g. DE)  
**&lt;stateOrProvince&gt;** - Needed for signing request, your state (e.g. Hessen)  
**&lt;localityName&gt;** - Needed for signing request, your city (e.g. Limburg)  
**&lt;postalCode&gt;** - Needed for signing request, your postal code (e.g 65xxx)  
**&lt;streetAddress&gt;** - Needed for signing request, your street address (e.g. "xxx xxx")  
**&lt;organizationName&gt;** - Needed for signing request, your name (e.g. "Jens Hartlep")  
**&lt;organizationalUnitName&gt;** - Needed for signing request, your OUName (e.g. IT)  
**&lt;commonName&gt;** - Needed for signing request, your domain.tld (e.g. example.com)  
**&lt;emailAddress&gt;** - Needed for signing request, your email address (e.g. admin@example.com)  
**&lt;subjectAltName&gt;** - Needed for singing request, your (sub)domains for the certificate (e.g. DNS:example.com,DNS:www.example.com)

##### Optional Parameters
**filename** - The filename for the .crt and .key file (e.g. nginx), default is __mail__

### 14 - PHP IMAP Fix
This script enabled the php5-imap module

#### Usage
```bash
./14-php-imap.sh
```

### 15 - Rainloop
This script installs the Rainloop webmail and enables a new subdomain for rainloop
**IMPORTANT**: AFTER THE INSTALLTION YOU MUST OPEN https://product_installation_URL/?admin AND CHANGE THE DEFAULT ADMIN CREDENTIALS (username: admin, password: 12345)

#### Usage
```bash
./15-rainloop.sh <fqdn>
```

##### Mandatory Parameters
**&lt;fqdn&gt;** - The new subdomain for Rainloop (e.g. webmail.example.com)

### 16 - Docker Remote API
This script enabled the docker remote API, creates a new user __docker__ for basic auth, creates a nginx reverse proxy configuration to the docker remote api on port 4242 and set the ufw to allow port 4242/tcp.

**Advice**: You should run [XX - Firewall Settings](#xx---firewall-setting) before using this script; see below.

#### Usage
```bash
./16-docker-remote.sh <domain.tld>
```

##### Mandatory Parameters
**&lt;domain.tld&gt;** - A new subdomain docker.domain.tld will be created

### XX - Firewall Settings
This script prepares the ufw for some ports and changes the defaults for incoming (deny) and outgoing (allow).

The following ports are allowed by this script
- ssh
- 1194/udp
- http
- https
- 25/tcp
- 110/tcp
- 143/tcp
- 587/tcp
- 993/tcp
- 995/tcp

#### Usage
```bash
./xx-firewall.sh
```

## Miscellaneous
Some links, tools, and sources in arbitrary order for the scripts above...

https://de.ssl-tools.net/  
https://thomas-leister.de/  
https://blog.kiefer-networks.de/  
https://mailcow.email/  
https://www.digitalocean.com/community/tutorials  
https://letsencrypt.org/howitworks/  
