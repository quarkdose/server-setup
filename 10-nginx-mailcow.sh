#!/bin/bash

echo '               .__                   _____         .__.__  _________                '
echo '  ____    ____ |__| ____ ___  ___   /     \ _____  |__|  | \_   ___ \  ______  _  __'
echo ' /    \  / ___\|  |/    \\  \/  /  /  \ /  \\__  \ |  |  | /    \  \/ /  _ \ \/ \/ /'
echo '|   |  \/ /_/  >  |   |  \>    <  /    Y    \/ __ \|  |  |_\     \___(  <_> )     / '
echo '|___|  /\___  /|__|___|  /__/\_ \ \____|__  (____  /__|____/\______  /\____/ \/\_/  '
echo '     \//_____/         \/      \/         \/     \/                \/               '

sudo cp ~/backup/nginx/sites-available/mailcow /etc/nginx/sites-available
sudo sed -i 's/listen 443;/listen 443 ssl http2;/g' /etc/nginx/sites-available/mailcow
sudo sed -i 's/listen \[::\]:443;/listen \[::\]:443 ssl http2;/g' /etc/nginx/sites-available/mailcow
sudo sed -i '/ssl on;/i \\tinclude conf.d/letsencrypt-auth.conf;' /etc/nginx/sites-available/mailcow
sudo sed -i '/server {/,/}/ { // { x; s/$/./; x; }; x; /.../! { x; d; }; x; }' /etc/nginx/sites-available/mailcow

sudo ln -s /etc/nginx/sites-available/mailcow /etc/nginx/sites-enabled/003-mailcow

sudo nginx -t

echo "\nIf nginx syntax is ok, don´t forget to perform sudo service nginx restart"
