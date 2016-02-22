#!/bin/bash

CODENAME="trusty"

echo '               .__                   _____         .__       .__  .__               '
echo '  ____    ____ |__| ____ ___  ___   /     \ _____  |__| ____ |  | |__| ____   ____  '
echo ' /    \  / ___\|  |/    \\  \/  /  /  \ /  \\__  \ |  |/    \|  | |  |/    \_/ __ \ '
echo '|   |  \/ /_/  >  |   |  \>    <  /    Y    \/ __ \|  |   |  \  |_|  |   |  \  ___/ '
echo '|___|  /\___  /|__|___|  /__/\_ \ \____|__  (____  /__|___|  /____/__|___|  /\___  >'
echo '     \//_____/         \/      \/         \/     \/        \/             \/     \/ '

mkdir -p ~/backup
sudo cp -r /etc/nginx ~/backup/nginx

curl -fsSL http://nginx.org/keys/nginx_signing.key | sudo apt-key add -

echo "deb http://nginx.org/packages/mainline/ubuntu/ $CODENAME nginx
deb-src http://nginx.org/packages/mainline/ubuntu/ $CODENAME nginx" | sudo tee /etc/apt/sources.list.d/nginx.list > /dev/null

sudo apt-get update && sudo apt-get purge nginx-common nginx-extras -y && sudo apt-get install nginx -y
sudo mkdir /etc/nginx/{sites-available,sites-enabled}
sudo rm /etc/nginx/conf.d/default.conf
sudo rm /etc/nginx/nginx.conf

echo "user			www-data;
worker_processes	4;

error_log		/var/log/nginx/error.log warn;
pid			/var/run/nginx.pid;

events {
	worker_connections	1024;
}


http {
	include			/etc/nginx/mime.types;
	default_type		application/octet-stream;

	log_format		main	'\$remote_addr - \$remote_user [\$time_local] \"\$request\" '
					'\$status $body_bytes_sent \"\$http_referer\" '
					'\"\$http_user_agent\" \"\$http_x_forwarded_for\"';

	access_log		/var/log/nginx/access.log	main;

	sendfile		on;
	tcp_nopush		on;
	tcp_nodelay		on;
	keepalive_timeout	65;
	types_hash_max_size	2048;
	server_tokens		off;

	server_names_hash_bucket_size	64;

	gzip			on;
	gzip_disable		\"msie6\";

	include			/etc/nginx/sites-enabled/*;
}" | sudo tee /etc/nginx/nginx.conf > /dev/null

echo "server {
        listen          80      default_server;
        listen          [::]:80 default_server;
        server_name     _;
        server_tokens   off;
        return          301     https://\$host\$request_uri;
}" | sudo tee /etc/nginx/sites-available/default > /dev/null

sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/000-ssl
sudo nginx -t

echo "\nIf nginx syntax is ok, don´t forget to perform sudo service nginx restart"
