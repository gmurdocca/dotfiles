#!/bin/bash

#### Exit if Dein is installed already ####
if [ -d ~/.vim/repos/github.com/Shougo/dein.vim ]; then
    echo Dein is already installed, ViM appears to be setup already.
    exit 0
fi

#### Check for Lua support in vim...
echo -n 'Checking for Lua support...'
vim_exc=$(which -a vim | grep bin | head -n1)
has_lua=`$vim_exc -nes -S <(echo 'verbose echo has("lua")') +quit 2>&1`
if [ $has_lua != '1' ]; then
    echo NO
    echo ERROR: Your vim at $vim_exc does not support Lua, please fix.
    exit 1
else
    echo Ok
fi

#### Install Dein...
echo "Installing Dein..."
tmpfile=$(mktemp /tmp/dein_installer.XXXXXX)
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $tmpfile
bash $tmpfile ~/.vim
rm -f $tmpfile
echo "Done."

