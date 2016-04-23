#!/bin/bash

if [[ -z "$1" ]]
        then echo "Missing mandatory path parameter"
        exit
fi

DOMAIN_PATH="$HOME/build/dane/$1"

if [[ ! -d $DOMAIN_PATH ]]
        then echo "Path $PATH does not exist"
        exit
fi

if [[ $1 == "mail" ]]
        then
        FILENAME="mail"
        else
        FILENAME="nginx"
fi

cd $DOMAIN_PATH
letsencrypt certonly --webroot -w /var/www/letsencrypt/letsencrypt-auth --key-path privkey.pem --cert-path cert.pem --fullchain-path fullchain.pem --csr request.csr

FULLCHAIN=`ls -t *_fullchain.pem | head -1`

sudo ln -snf $DOMAIN_PATH/$FULLCHAIN /etc/ssl/$1/$FILENAME.crt

sudo service postfix restart
sudo service dovecot restart
sudo service nginx restart

echo "New Certificates for \"$1\" created!"
