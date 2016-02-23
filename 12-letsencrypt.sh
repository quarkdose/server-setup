#!/bin/bash

echo '.____           __ /\        ___________                                   __   '
echo '|    |    _____/  |)/ ______ \_   _____/ ____   ___________ ___.__._______/  |_ '
echo '|    |  _/ __ \   __\/  ___/  |    __)_ /    \_/ ___\_  __ <   |  |\____ \   __\'
echo '|    |__\  ___/|  |  \___ \   |        \   |  \  \___|  | \/\___  ||  |_> >  |  '
echo '|_______ \___  >__| /____  > /_______  /___|  /\___  >__|   / ____||   __/|__|  '
echo '        \/   \/          \/          \/     \/     \/       \/     |__|         '

cd ~/build
git clone https://github.com/letsencrypt/letsencrypt

sudo ln -s ~/build/letsencrypt/letsencrypt-auto /usr/local/bin/letsencrypt

echo "You might need to relogin to use the letsencrypt command"
