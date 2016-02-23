#!/bin/bash

 echo ' ________                     .__              _____          __  .__                   __  .__               __                '
 echo ' /  _____/  ____   ____   ____ |  |   ____     /  _  \  __ ___/  |_|  |__   ____   _____/  |_|__| ____ _____ _/  |_  ___________ '
 echo '/   \  ___ /  _ \ /  _ \ / ___\|  | _/ __ \   /  /_\  \|  |  \   __\  |  \_/ __ \ /    \   __\  |/ ___\\__  \\   __\/  _ \_  __ \'
 echo '\    \_\  (  <_> |  <_> ) /_/  >  |_\  ___/  /    |    \  |  /|  | |   Y  \  ___/|   |  \  | |  \  \___ / __ \|  | (  <_> )  | \/'
 echo ' \______  /\____/ \____/\___  /|____/\___  > \____|__  /____/ |__| |___|  /\___  >___|  /__| |__|\___  >____  /__|  \____/|__|   '
 echo '        \/             /_____/           \/          \/                 \/     \/     \/             \/     \/                   '

sudo apt-get install libpam-google-authenticator -y
sudo sed -i '/# PAM configuration for the Secure Shell service/a \\n\\n#Activate google authenticator\nauth [success=ok new_authtok_reqd=done default=die] pam_google_authenticator.so nullok' /etc/pam.d/sshd
sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo service ssh restart
google-authenticator
sudo service ssh restart
