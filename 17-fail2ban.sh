#!/bin/bash

echo '___________      .__.__   __________________                                      _____         '
echo '\_   _____/____  |__|  |  \_____  \______   \_____    ____       .__       __ ___/ ____\_  _  __'
echo ' |    __) \__  \ |  |  |   /  ____/|    |  _/\__  \  /    \    __|  |___  |  |  \   __\\ \/ \/ /'
echo ' |     \   / __ \|  |  |__/       \|    |   \ / __ \|   |  \  /__    __/  |  |  /|  |   \     / '
echo ' \___  /  (____  /__|____/\_______ \______  /(____  /___|  /     |__|     |____/ |__|    \/\_/  '
echo '     \/        \/                 \/      \/      \/     \/                                     '

echo "
[sshd]
enabled   = true
banaction = ufw
port      = ssh
filter    = sshd
logpath   = %(sshd_log)s
maxretry  = 3
" | sudo tee -a /etc/fail2ban/jail.local
