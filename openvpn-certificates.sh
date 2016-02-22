#!/bin/bash

if [[ -z "$1" ]]
	then echo "You must provide a clientname"
	exit
fi

echo '________                     ____   _____________________            _________                __  .__  _____.__               __                 '
echo '\_____  \ ______   ____   ___\   \ /   /\______   \      \           \_   ___ \  ____________/  |_|__|/ ____\__| ____ _____ _/  |_  ____   ______'
echo ' /   |   \\____ \_/ __ \ /    \   Y   /  |     ___/   |   \   ______ /    \  \/_/ __ \_  __ \   __\  \   __\|  |/ ___\\__  \\   __\/ __ \ /  ___/'
echo '/    |    \  |_> >  ___/|   |  \     /   |    |  /    |    \ /_____/ \     \___\  ___/|  | \/|  | |  ||  |  |  \  \___ / __ \|  | \  ___/ \___ \ '
echo '\_______  /   __/ \___  >___|  /\___/    |____|  \____|__  /          \______  /\___  >__|   |__| |__||__|  |__|\___  >____  /__|  \___  >____  >'
echo '        \/|__|        \/     \/                          \/                  \/     \/                              \/     \/          \/     \/ '

OVPN_DATA="OpenVPN-Data"

docker run --volumes-from $OVPN_DATA --rm -it kylemanna/openvpn easyrsa build-client-full $1 nopass
docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_getclient $1 > ~/docker/openvpn/$1.ovpn
