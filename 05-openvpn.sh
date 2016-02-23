#!/bin/bash

if [[ -z "$1" ]]
	then echo "You must provide a FQDN (e.g. vpn.example.com)"
	exit
fi

echo '________                     ____   _____________________   '
echo '\_____  \ ______   ____   ___\   \ /   /\______   \      \  '
echo ' /   |   \\____ \_/ __ \ /    \   Y   /  |     ___/   |   \ '
echo '/    |    \  |_> >  ___/|   |  \     /   |    |  /    |    \'
echo '\_______  /   __/ \___  >___|  /\___/    |____|  \____|__  /'
echo '        \/|__|        \/     \/                          \/ '

mkdir -p ~/docker/openvpn

OVPN_DATA="OpenVPN-Data"
OVPN_SERVER="OpenVPN-Server"
USER=$(whoami)

docker run --name $OVPN_DATA -v /home/$USER/docker/openvpn:/etc/openvpn busybox
docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_genconfig -u udp://$1:1194
docker run --volumes-from $OVPN_DATA --rm -it kylemanna/openvpn ovpn_initpki
docker run --name $OVPN_SERVER --volumes-from $OVPN_DATA -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn

echo "description \"OpenVPN Server container\"
author \"Jens Hartlep\"
start on filesystem and started docker
stop on runlevel [!2345]
respawn
script
  /usr/bin/docker start -a $OVPN_SERVER
end script" | sudo tee /etc/init/docker-openvpn.conf > /dev/null
