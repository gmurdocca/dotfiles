#!/bin/bash
CHECKOUT_DIR="$( cd "$( dirname "$0" )" && pwd )"
FILES="bash_profile tmux.conf vim vimrc zshrc zsh_functions gitconfig psqlrc ipython matplotlib"

read -p "Are you sure you want to clobber all your config files? (y/n)" -n 1
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
echo

cd $HOME

function symlink() {
    # Remove the old config if it's not a symlink
    [ -f "$2" ] && [ ! -L "$2" ] && rm -f "$2"

    if [[ ! -a "$2" ]]; then
        echo "Linking '$1' to '$2'"
        ln -s "$1" "$2"
    fi
}

for FILE in $FILES; do
    # Symlink the config to the one in the repo
    symlink "$CHECKOUT_DIR/_$FILE" ".$FILE"
done

# Link .bashrc to .bash_profile
symlink "$CHECKOUT_DIR/_bash_profile" ".bashrc"

# fish
mkdir -p ".config"
symlink "$CHECKOUT_DIR/fish" ".config/fish"

# terminator 
mkdir -p ".config/terminator"
symlink "CHECKOUT_DIR/_terminator" ".config/terminator/config"

# Link the dircolors checkout
symlink "$CHECKOUT_DIR/dircolors.ansi-dark" .dircolors
