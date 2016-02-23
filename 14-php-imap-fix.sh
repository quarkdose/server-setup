#!/bin/bash

echo '__________  ___ _____________          .__                        ___________.__        '
echo '\______   \/   |   \______   \         |__| _____ _____  ______   \_   _____/|__|__  ___'
echo ' |     ___/    ~    \     ___/  ______ |  |/     \\__  \ \____ \   |    __)  |  \  \/  /'
echo ' |    |   \    Y    /    |     /_____/ |  |  Y Y  \/ __ \|  |_> >  |     \   |  |>    < '
echo ' |____|    \___|_  /|____|             |__|__|_|  (____  /   __/   \___  /   |__/__/\_ \'
echo '                 \/                             \/     \/|__|          \/             \/'

sudo php5enmod imap
sudo service php5-fpm restart

echo "I don't know why, but for me a system restart is needed, so do sudo shutdown -r now ..."
