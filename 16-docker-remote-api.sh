#!/bin/bash

if [[ -z "$1" ]]
        then echo "You must provide a domain (e.g. example.com)"
        exit
fi

echo '________                 __                  __________                       __              _____ __________.___ '
echo '\______ \   ____   ____ |  | __ ___________  \______   \ ____   _____   _____/  |_  ____     /  _  \\______   \   |'
echo ' |    |  \ /  _ \_/ ___\|  |/ // __ \_  __ \  |       _// __ \ /     \ /  _ \   __\/ __ \   /  /_\  \|     ___/   |'
echo ' |    `   (  <_> )  \___|    <\  ___/|  | \/  |    |   \  ___/|  Y Y  (  <_> )  | \  ___/  /    |    \    |   |   |'
echo '/_______  /\____/ \___  >__|_ \\___  >__|     |____|_  /\___  >__|_|  /\____/|__|  \___  > \____|__  /____|   |___|'
echo '        \/            \/     \/    \/                \/     \/      \/                 \/          \/              '

sudo sed -i 's/DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4 --iptables=false/DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4 --iptables=false -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"/g' /etc/default/docker

sudo service docker restart

sudo apt-get install apache2-utils -y

sudo htpasswd -c /etc/nginx/.htpasswd docker

echo "upstream docker {
        server unix:/var/run/docker.sock fail_timeout=0;
}
server {
        listen                          4242;
        server_name                     docker.$1;
        server_tokens                   off;
        ssl                             on;
        ssl_certificate                 /etc/ssl/$1/nginx.crt;
        ssl_certificate_key             /etc/ssl/$1/nginx.key;
        ssl_prefer_server_ciphers       on;
        ssl_protocols                   TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers						'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
        ssl_dhparam                     /etc/ssl/mail/dhparams.pem;
        add_header                      Strict-Transport-Security       max-age=15768000;
        ssl_session_timeout             30m;
        client_max_body_size            150m;

        location / {
                auth_basic                      "Restricted";
                auth_basic_user_file            /etc/nginx/.htpasswd;

                proxy_pass                      http://docker;
                proxy_redirect                  off;

                proxy_set_header                Host             \$host;
                proxy_set_header                X-Real-IP        \$remote_addr;
                proxy_set_header                X-Forwarded-For  \$proxy_add_x_forwarded_for;

                client_max_body_size            10m;
                client_body_buffer_size         128k;

                proxy_connect_timeout           90;
                proxy_send_timeout              120;
                proxy_read_timeout              120;

                proxy_buffer_size               4k;
                proxy_buffers                   4 32k;
                proxy_busy_buffers_size         64k;
                proxy_temp_file_write_size      64k;
        }
}" | sudo tee /etc/nginx/sites-available/docker.$1 > /dev/null

sudo ln -s /etc/nginx/sites-available/docker.$1 /etc/nginx/sites-enabled/003-docker.$1
sudo nginx -t

sudo ufw allow 4242/tcp

echo "If nginx syntax is ok, don´t forget to perform sudo service nginx restart"
echo "Don't forget to add a Let's Encrypt certificate for docker.$1"
echo "Don't forget to restart your docker containers!"
