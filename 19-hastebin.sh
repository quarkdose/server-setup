#!/bin/bash

if [[ -z "$1" ]]
        then echo "You must provide a domain.tld for hastebin (e.g. example.com)"
        exit
fi

echo '.__                     __        ___.   .__        '
echo '|  |__ _____    _______/  |_  ____\_ |__ |__| ____  '
echo '|  |  \\__  \  /  ___/\   __\/ __ \| __ \|  |/    \ '
echo '|   Y  \/ __ \_\___ \  |  | \  ___/| \_\ \  |   |  \'
echo '|___|  (____  /____  > |__|  \___  >___  /__|___|  /'
echo '     \/     \/     \/            \/    \/        \/ '

docker run --name hastebin -d -p 8082:7777 jmvrbanac/hastebin
echo "server {
        listen                          443 ssl http2;
        listen                          [::]:443 ssl http2;
        server_name                     paste.$1;
        server_tokens                   off;
        ssl                             on;
        ssl_certificate                 /etc/ssl/$1/nginx.crt;
        ssl_certificate_key             /etc/ssl/$1/nginx.key;
        ssl_prefer_server_ciphers       on;
        ssl_protocols                   TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers                     'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA25$
        ssl_dhparam                     /etc/ssl/mail/dhparams.pem;
        add_header                      Strict-Transport-Security       max-age=15768000;
        ssl_session_timeout             30m;
        client_max_body_size            150m;
        location / {
                proxy_set_header        X-Real-IP \$remote_addr;
                proxy_set_header        X-Forwarded-For \$remote_addr;
                proxy_set_header        Host \$host;
                proxy_pass              http://127.0.0.1:8082;
        }
        include /etc/nginx/conf.d/letsencrypt-auth.conf;
}
" | sudo tee /etc/nginx/sites-available/paste.$1 > /dev/null

sudo ln -s /etc/nginx/sites-available/paste.$1 /etc/nginx/sites-enabled/003-paste.$1
sudo nginx -t

echo "Don't forget to add a Let's Encrypt certificate for $1"
echo "If nginx syntax is ok, don´t forget to perform sudo service nginx restart"
