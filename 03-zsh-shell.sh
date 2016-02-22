#!/bin/bash

echo '       .__                                                     .__     '
echo '  ____ |  |__             _____ ___.__.         ________  _____|  |__  '
echo ' /  _ \|  |  \   ______  /     <   |  |  ______ \___   / /  ___/  |  \ '
echo '(  <_> )   Y  \ /_____/ |  Y Y  \___  | /_____/  /    /  \___ \|   Y  \'
echo ' \____/|___|  /         |__|_|  / ____|         /_____ \/____  >___|  /'
echo '            \/                \/\/                    \/     \/     \/ '

sudo apt-get install zsh git curl -y
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="crunch"/g' ~/.zshrc
sed -i 's/plugins=(git)/plugins=(git docker)/g' ~/.zshrc
source ~/.zshrc
