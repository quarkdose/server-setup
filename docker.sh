#!/bin/bash

USER=$(whoami)

echo '________                 __                  .__        '
echo '\______ \   ____   ____ |  | __ ___________  |__| ____  '
echo ' |    |  \ /  _ \_/ ___\|  |/ // __ \_  __ \ |  |/  _ \ '
echo ' |    `   (  <_> )  \___|    <\  ___/|  | \/ |  (  <_> )'
echo '/_______  /\____/ \___  >__|_ \\___  >__| /\ |__|\____/ '
echo '        \/            \/     \/    \/     \/            '

curl -fsSL https://get.docker.com/gpg | sudo apt-key add -
curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
