#!/bin/bash

if [[ -z "$1" ]]
        then echo "You must provide your storage username"
        exit
fi

if [[ -z "$2" ]]
        then echo "You must provide your storage password"
        exit
fi

if [[ "$3" = "ASUSER" ]]
        then ASUSER=",uid=$(whoami),gid=$(whoami),file_mode=0640,dir_mode=0750"
        else ASUSER=""
fi

echo '  _________                                _________                   _________ __                                      '
echo ' /   _____/ ______________  __ ___________ \_   ___ \  ______  _  __  /   _____//  |_  ________________     ____   ____  '
echo ' \_____  \_/ __ \_  __ \  \/ // __ \_  __ \/    \  \/ /  _ \ \/ \/ /  \_____  \\   __\/  _ \_  __ \__  \   / ___\_/ __ \ '
echo ' /        \  ___/|  | \/\   /\  ___/|  | \/\     \___(  <_> )     /   /        \|  | (  <_> )  | \// __ \_/ /_/  >  ___/ '
echo '/_______  /\___  >__|    \_/  \___  >__|    \______  /\____/ \/\_/   /_______  /|__|  \____/|__|  (____  /\___  / \___  >'
echo '        \/     \/                 \/               \/                        \/                        \//_____/      \/ '

sudo apt-get install cifs-utils -y
sudo mkdir /samba_share

sudo sed -i "\$a //io.servercow.de/home /samba_share cifs username=$1,passwd=$2$ASUSER 0 0"
sudo mount -a
