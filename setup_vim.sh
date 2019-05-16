#!/bin/bash

#### Exit if Dein is installed already ####

vim_exc=$(which -a vim | grep bin | head -n1)

#### Check vim version...
echo -n 'Checking for Vim version...'
current_version=`$vim_exc -nes -S <(echo 'verbose echo v:version') +quit 2>&1`
if [ $current_version -ge 800  ]; then
    echo Ok
    #### Install Dein...
    echo "Installing Dein..."
    if [ -d ~/.vim/repos/github.com/Shougo/dein.vim ]; then
        echo Dein is already installed, Vim appears to be setup already.
    else
        tmpfile=$(mktemp /tmp/dein_installer.XXXXXX)
        curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $tmpfile
        bash $tmpfile ~/.vim
        rm -f $tmpfile
        echo "Done."
    fi
else
    echo NO
    echo "WARNING: Your Vim version at $vim_exc is < 800 (8.x). Current version is: $current_version. Please fix:"
    echo ""
    echo "         *** Neobundle will be installed instead of Dein ***"
    echo ""
    echo "         Ctrl-C now if you want to upgrade to Vim >= 8.x"
    echo ""
    echo "         To upgrade Vim on Ubuntu:"
    echo "            sudo add-apt-repository ppa:jonathonf/vim -y"
    echo "            sudo apt update"
    echo "            sudo apt install vim -y"
    echo ""
    count=5
    while [ $count -gt 0 ]; do
        echo -n "$count "
        ((count-=1))
        sleep 1
    done
    echo ""
    #### Install NeoBundle...
    echo "Installing NeoBundle..."
    
    if [ -d ~/.vim/bundle/neobundle.vim ]; then
        echo Neobundle is already installed, Vim appears to be setup already.
    else
        tmpfile=$(mktemp /tmp/neobundle_installer.XXXXXX)
        curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > $tmpfile
        bash $tmpfile
        rm -f $tmpfile
        echo "Done."
    fi
fi

#### Check for Lua support in vim...
echo -n 'Checking for Lua support...'
has_lua=`$vim_exc -nes -S <(echo 'verbose echo has("lua")') +quit 2>&1`
if [ $has_lua == '1' ]; then
    echo Ok
else
    echo NO
    echo WARNING: Your Vim at $vim_exc does not support Lua. To fix:
    echo "          for Ubuntu:"
    echo "              add-apt-repository universe"
    echo "              apt-get update"
    echo "              sudo apt install vim-nox"
    echo "          for OSX:"
    echo "              brew install vim --with-lua"
    echo ""
fi



