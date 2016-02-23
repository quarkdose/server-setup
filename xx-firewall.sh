#!/bin/bash

echo '___________.__                              .__  .__   '
echo '\_   _____/|__|______   ______  _  _______  |  | |  |  '
echo ' |    __)  |  \_  __ \_/ __ \ \/ \/ /\__  \ |  | |  |  '
echo ' |     \   |  ||  | \/\  ___/\     /  / __ \|  |_|  |__'
echo ' \___  /   |__||__|    \___  >\/\_/  (____  /____/____/'
echo '     \/                    \/             \/           '

sudo ufw allow ssh

sudo ufw allow 1194/udp

sudo ufw allow http
sudo ufw allow https

sudo ufw allow 25/tcp
sudo ufw allow 110/tcp
sudo ufw allow 143/tcp
sudo ufw allow 587/tcp
sudo ufw allow 993/tcp
sudo ufw allow 995/tcp

sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw show added

echo "Enable firewall by sudo ufw enable"
