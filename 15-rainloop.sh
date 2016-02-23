#!/bin/bash

if [[ -z "$1" ]]
	then echo "You must provide a FQDN (e.g. webmail.example.com)"
	exit
fi

echo '__________        .__       .____                           __      __      ___.                  .__.__   '
echo '\______   \_____  |__| ____ |    |    ____   ____ ______   /  \    /  \ ____\_ |__   _____ _____  |__|  |  '
echo ' |       _/\__  \ |  |/    \|    |   /  _ \ /  _ \\____ \  \   \/\/   // __ \| __ \ /     \\__  \ |  |  |  '
echo ' |    |   \ / __ \|  |   |  \    |__(  <_> |  <_> )  |_> >  \        /\  ___/| \_\ \  Y Y  \/ __ \|  |  |__'
echo ' |____|_  /(____  /__|___|  /_______ \____/ \____/|   __/    \__/\  /  \___  >___  /__|_|  (____  /__|____/'
echo '        \/      \/        \/        \/            |__|            \/       \/    \/      \/     \/         '

cd /tmp/
sudo wget http://repository.rainloop.net/v2/webmail/rainloop-community-latest.zip
sudo unzip /tmp/rainloop-community-latest.zip -d /var/www/rainloop
sudo chown -R www-data:www-data /var/www/rainloop

cd /var/www/rainloop
sudo find . -type d -exec chmod 755 {} \;
sudo find . -type f -exec chmod 644 {} \;

echo "server {
	listen				443 ssl http2;
	listen				[::]:443 ssl http2;
	server_name			$1;
	server_tokens			off;
	ssl				on;
	ssl_certificate			/etc/ssl/mail/mail.crt;
	ssl_certificate_key		/etc/ssl/mail/mail.key;
	ssl_prefer_server_ciphers	on;
	ssl_protocols			TLSv1 TLSv1.1 TLSv1.2;
	ssl_ciphers			'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
	ssl_dhparam			/etc/ssl/mail/dhparams.pem;
	add_header			Strict-Transport-Security	max-age=15768000;
	ssl_session_timeout		30m;
	client_max_body_size 150m;
	root				/var/www/rainloop;
	index				index.html	index.htm	index.php;
	error_page			502	/redir.html;
	location /redir.html {
		return	301	/admin.php;
	}
	location ~ /(\.ht) {
		deny	all;
		return	404;
	}
	location = /favicon.ico {
		log_not_found	off;
		access_log	off;
	}
	location = /robots.txt {
		allow		all;
		log_not_found	off;
		access_log	off;
	}
	location / {
		try_files	\$uri	\$uri/	index.php;
	}
	location ~ \.php\$ {
        	include			fastcgi_params;
        	fastcgi_split_path_info	^(.+\.php)(/.+)\$;
	        fastcgi_pass		unix:/var/run/php5-fpm-mail.sock;
	        fastcgi_index		index.php;
	        fastcgi_param		HTTPS	on;
	        fastcgi_param		SCRIPT_FILENAME	\$document_root\$fastcgi_script_name;
		fastcgi_read_timeout	630;
		fastcgi_keep_conn	on;
	}
	include                         /etc/nginx/conf.d/letsencrypt-auth.conf;
}" | sudo tee /etc/nginx/sites-available/rainloop > /dev/null

sudo ln -s /etc/nginx/sites-available/rainloop /etc/nginx/sites-enabled/003-rainloop

sudo nginx -t

echo "If nginx syntax is ok, don´t forget to perform sudo service nginx restart"
echo "And don't forget do create a let's encrypt certificate for this fqdn!"
