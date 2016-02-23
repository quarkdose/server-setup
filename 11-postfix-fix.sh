#!/bin/bash

echo '__________               __    _____.__        '
echo '\______   \____  _______/  |__/ ____\__|__  ___'
echo ' |     ___/  _ \/  ___/\   __\   __\|  \  \/  /'
echo ' |    |  (  <_> )___ \  |  |  |  |  |  |>    < '
echo ' |____|   \____/____  > |__|  |__|  |__/__/\_ \'
echo '                    \/                       \/'

sudo sed -i '/# Disallow SSLv2 and SSLv3, only accept secure ciphers/a smtpd_tls_protocols=!SSLv2,!SSLv3' /etc/postfix/main.cf

sudo git clone https://github.com/csware/postfix-tls-policy.git /etc/postfix/tls_policy
sudo postmap /etc/postfix/tls_policy/tls_policy-dane

sudo postconf -e "smtpd_use_tls = yes"
sudo postconf -e "smtp_dns_support_level = dnssec"
sudo postconf -e "smtp_tls_policy_maps = hash:/etc/postfix/tls_policy/tls_policy-dane"
sudo postconf -e "smtp_host_lookup = dns, native"

sudo service postfix restart
