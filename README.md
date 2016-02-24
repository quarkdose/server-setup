# Setup scripts for my Ubuntu 14.04 LTS Server
Here is my collection of setup scripts for my Ubuntu server.

## Table of content

1. [Usage](#usage)
1.1.  [Initial Setup](#initial-setup)


## Usage

### 01 - Initial Setup
This script has to be called as user **root**. It will perform a update && (dist)upgrade, install ntp, adds a new user and puts this user into sudoers.d.
Moreover the ssh root login will be disabled.

#### Usage(#usage)
```bash
./01-initial-setup.sh <username> [NOPASSWD]
```

##### Mandatory Parameters
<username> - the username for the new user to add

##### Optional Parameters
NOPASSWD - If set, the sudoers entry will have the NOPASSWD flag

### 02 - Google Authenticator
This script will install the libpam-google-authenticator package and changes the ssh configuration for the calling user to force ssh login with two factor authentication

#### Usage
```bash
./02-authenticator.sh
```

### 03 - zsh shell
This script will install zsh (and git and curl as dependency) and oh-my-zsh, and sets this shell as default.




https://de.ssl-tools.net/
