#!/bin/bash

echo '__________               __    _____.__        '
echo '\______   \____  _______/  |__/ ____\__|__  ___'
echo ' |     ___/  _ \/  ___/\   __\   __\|  \  \/  /'
echo ' |    |  (  <_> )___ \  |  |  |  |  |  |>    < '
echo ' |____|   \____/____  > |__|  |__|  |__/__/\_ \'
echo '                    \/                       \/'

sudo sed -i '/# Disallow SSLv2 and SSLv3, only accept secure ciphers/a smtpd_tls_protocols=!SSLv2,!SSLv3' /etc/postfix/main.cf
sudo service postfix restart
