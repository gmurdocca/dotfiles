 #!/bin/bash


echo ""
echo "--+++===] Dotfiles Installer [===+++--"
echo ""
echo "Existing config files that are not symlinks will be renamed to <original_name>.dotfile_backup."
if [[ ! "$1" =~ ^-[yY] ]]; then
    echo -n "Hit Ctrl-C to abort (add -y option to suppress), else continuing in "
    count=5
    while [ $count -gt 0 ]; do
        echo -n "$count "
        ((count-=1))
        sleep 1
    done
    echo ""
fi

CHECKOUT_DIR="$( cd "$( dirname "$0" )" && pwd )"
FILES="xinitrc Xkbmap bash_profile tmux.conf vimrc zshrc zsh_functions gitconfig gitignore_global psqlrc ipython matplotlib sshrc sshrc.d"
cd $HOME

function symlink() {
    # Remove the old config if it's not a symlink
    if [ -f "$2" ] && [ ! -L "$2" ]; then
        mv "$2" "$2.dotfile_backup"
        #rm -f "$2"
    fi

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

# install dein for vim if not installed
$CHECKOUT_DIR/setup_vim.sh $1

echo Done!
echo ""
echo You may want to create ~/.gitconfig_global with contents:
echo ""
echo '[user]'
echo '   email = <your_email_address>'
echo '   name = <your name>'

