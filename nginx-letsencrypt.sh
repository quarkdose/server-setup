#!/bin/bash

echo '               .__                .__          __         ___________                                   __   '
echo '  ____    ____ |__| ____ ___  ___ |  |   _____/  |_  _____\_   _____/ ____   ___________ ___.__._______/  |_ '
echo ' /    \  / ___\|  |/    \\  \/  / |  | _/ __ \   __\/  ___/|    __)_ /    \_/ ___\_  __ <   |  |\____ \   __\'
echo '|   |  \/ /_/  >  |   |  \>    <  |  |_\  ___/|  |  \___ \ |        \   |  \  \___|  | \/\___  ||  |_> >  |  '
echo '|___|  /\___  /|__|___|  /__/\_ \ |____/\___  >__| /____  >_______  /___|  /\___  >__|   / ____||   __/|__|  '
echo '     \//_____/         \/      \/           \/          \/        \/     \/     \/       \/     |__|         '

echo "
location /.well-known/acme-challenge {
	location ~ /.well-known/acme-challenge/(.*) {
		return	301	http://letsencrypt-auth.hartlep.email\$request_uri;
	}
}
" | sudo tee /etc/nginx/conf.d/letsencrypt-auth.conf > /dev/null

echo "
server {
	listen			80;
	listen			[::]:80;
	server_name		letsencrypt-auth.hartlep.email;
	root			/var/www/letsencrypt/letsencrypt-auth;
	default_type		text/plain;
}
" | sudo tee /etc/nginx/sites-available/letsencrypt > /dev/null

sudo mkdir -p /var/www/letsencrypt/letsencrypt-auth/.well-known/acme-challenge
sudo ln -s /etc/nginx/sites-available/letsencrypt /etc/nginx/sites-enabled/001-letsencrypt

sudo nginx -t
