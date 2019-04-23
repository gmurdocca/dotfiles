#!/bin/bash
CHECKOUT_DIR="$( cd "$( dirname "$0" )" && pwd )"
FILES="xinitrc Xkbmap bash_profile tmux.conf vimrc zshrc zsh_functions gitconfig gitignore_global psqlrc ipython matplotlib sshrc sshrc.d"

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

# terminator 
mkdir -p ".config/terminator"
symlink "$CHECKOUT_DIR/_terminator" ".config/terminator/config"

# Link the dircolors checkout
symlink "$CHECKOUT_DIR/dircolors.ansi-dark" .dircolors

# install custom bins
mkdir -p .local
symlink "$CHECKOUT_DIR/bin" .local/bin

# ipython
conf_src_dir="$CHECKOUT_DIR/_ipython/"
conf_dest_dir=${HOME}/.ipython
find "${conf_src_dir}" -type f | while read f; do 
    conf_src_file=$(readlink -m $f)
    len_conf_src_dir=${#conf_src_dir}
    rel_dest_path=${conf_src_file:${len_conf_src_dir}}
    abs_dest_path=${conf_dest_dir}/${rel_dest_path}
    abs_dest_dir=$(dirname ${abs_dest_path})
    mkdir -p ${abs_dest_dir}
    symlink ${conf_src_file} ${abs_dest_path}
done

# install neobundle for vim if not installed
if [ ! -d ~/.vim/bundle/neobundle.vim ]; then
    if ! type git >/dev/null 2>&1; then
        echo ERROR: Please install git so that I can install NeoBundle for Vim, then re-run this script.
        exit 1
    fi
    curl -s https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > /tmp/neobundle_install.sh
    sh /tmp/neobundle_install.sh >/dev/null 2>&1
fi

echo Done!
