#!/bin/bash

if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
fi

if [[ -z "$1" ]]
        then echo "You must provide a username to create"
        exit
fi

if [[ "$2" = "NOPASSWD" ]]
        then SUDOERS="$1 ALL=(ALL:ALL) NOPASSWD:ALL"
        else SUDOERS="$1 ALL=(ALL:ALL) ALL"
fi

echo '.___       .__  __  .__       .__      _________       __                '
echo '|   | ____ |__|/  |_|__|____  |  |    /   _____/ _____/  |_ __ ________  '
echo '|   |/    \|  \   __\  \__  \ |  |    \_____  \_/ __ \   __\  |  \____ \ '
echo '|   |   |  \  ||  | |  |/ __ \|  |__  /        \  ___/|  | |  |  /  |_> >'
echo '|___|___|  /__||__| |__(____  /____/ /_______  /\___  >__| |____/|   __/ '
echo '         \/                 \/               \/     \/           |__|    '

# Perform system update and upgrade and install ntp
apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
apt-get install ntp -y

# Configure timezone
dpkg-reconfigure tzdata

# Add new user and put this user to sudoers.d
adduser $1
echo $SUDOERS >> /etc/sudoers.d/$1
chmod 440 /etc/sudoers.d/$1

# Deny user root for ssh login
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

# Restart SSH service
service ssh restart
