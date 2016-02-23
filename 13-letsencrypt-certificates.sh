#!/bin/bash

if [[ -z "$1" ]]
        then echo "You must provide a countryName"
        exit
fi

if [[ -z "$2" ]]
        then echo "You must provide a stateOrProvinceName"
        exit
fi

if [[ -z "$3" ]]
        then echo "You must provide a localityName"
        exit
fi

if [[ -z "$4" ]]
        then echo "You must provide a postalCode"
        exit
fi

if [[ -z "$5" ]]
        then echo "You must provide a streetAddress"
        exit
fi

if [[ -z "$6" ]]
        then echo "You must provide a organizationName"
        exit
fi

if [[ -z "$7" ]]
        then echo "You must provide a organizationalUnitName"
        exit
fi

if [[ -z "$8" ]]
        then echo "You must provide a commonName"
        exit
fi

if [[ -z "$9" ]]
        then echo "You must provide a emailAddress"
        exit
fi

if [[ -z "$10" ]]
        then echo "You must provide a subjectAltName (e.g. DNS:example.com,DNS:www.example.com)"
        exit
fi

echo '.____           __ /\        ___________                                   __                 ________      _____    _______  ___________'
echo '|    |    _____/  |)/ ______ \_   _____/ ____   ___________ ___.__._______/  |_      .__      \______ \    /  _  \   \      \ \_   _____/'
echo '|    |  _/ __ \   __\/  ___/  |    __)_ /    \_/ ___\_  __ <   |  |\____ \   __\   __|  |___   |    |  \  /  /_\  \  /   |   \ |    __)_ '
echo '|    |__\  ___/|  |  \___ \   |        \   |  \  \___|  | \/\___  ||  |_> >  |    /__    __/   |    `   \/    |    \/    |    \|        \'
echo '|_______ \___  >__| /____  > /_______  /___|  /\___  >__|   / ____||   __/|__|       |__|     /_______  /\____|__  /\____|__  /_______  /'
echo '        \/   \/          \/          \/     \/     \/       \/     |__|                               \/         \/         \/        \/ '

mkdir -p ~/build/dane
cd ~/build/dane

echo "[ req ]
default_md = sha512
prompt = no
encrypt_key = no
distinguished_name = req_distinguished_name
req_extensions = v3_req

[ req_distinguished_name ]
countryName = \"$1\"
stateOrProvinceName = \"$2\"
localityName = \"$3\"
postalCode = \"$4\"
streetAddress = \"$5\"
organizationName = \"$6\"
organizationalUnitName = \"$7\"
commonName = \"$8\"
emailAddress = \"$9\"

[ v3_req ]
subjectAltName = ${10}" | tee ~/build/dane/request.cnf > /dev/null

openssl genrsa -out privkey.pem 4096
openssl req -config request.cnf -new -key privkey.pem -out request.csr -outform der

letsencrypt certonly --webroot -w /var/www/letsencrypt/letsencrypt-auth --key-path privkey.pem --cert-path cert.pem --fullchain-path fullchain.pem --csr request.csr

sudo ln -s ~/build/dane/0000_fullchain.pem /etc/ssl/mail/mail.crt
sudo ln -s ~/build/dane/privkey.pem /etc/ssl/mail/mail.key

sudo service nginx restart
sudo service postfix restart
sudo service dovecot restart
