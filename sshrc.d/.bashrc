# .bashrc

#export KRB5CCNAME=/tmp/kr5ccache

# FIXME re-enable this when you fix zsh key bindings
#if [ -z "$ZSH_VERSION" ]; then
#  zsh --login
#  exit 0
#fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions


# Check for an interactive session
[ -z "$PS1" ] && return

#merged mkdir/cd
function mkcd() { [ -n "$1" ] && mkdir -p "$1" && cd "$1"; }

alias ls='ls --color=auto'
alias sl='sl -e'
#alias tmux="TERM=screen-256color-bce tmux"
alias tmux-join="tmux new-session -t"
alias t="tmux attach"
alias v='vim'
#alias emacs='TERM=screen-16color emacs -nw'

# Random settings
export SBT_OPTS="-XX:MaxPermSize=128m"

# Editor:
export EDITOR=vim
export PSQL_EDITOR='vim -c "set ft=sql"'

# PATH changes
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# Prompt
DEFAULT="[0;0m"
PINK="[0;35m"
GREEN="[0;32m"
YELLOW="[0;33m"
BLDCYAN="[1;36m"

#export PS1='\n\e${PINK}\u\e${BLDCYAN}@\e${DEFAULT}\e${YELLOW}\h \
#\e${DEFAULT}in \e${GREEN}\w\
#\e${DEFAULT}\n$ '
job_status="\`if [ \$? = 0 ]; then echo \[\e[32m\]:\)\[\e[0m\]; else echo \[\e[31m\]:\(\[\e[0m\]; fi\`"
CURRENTUSER=`whoami`
if [ "$CURRENTUSER" = "root" ]; then
    uhp_status="\[\033[41;1;37m\]\u\[\033[0;1;37m\]\[\033[42;1;37m\]@\h\[\033[0;01;34m\] \w"
    prompt="#"
else
    uhp_status="\[\033[1;32m\]\u@\[\033[42;1;37m\]\h\[\033[0;01;34m\] \w"
    prompt="$"
fi
#vcs_status="\[\033[0;35m\]\$(vcprompt)"
bgj_status="\[\033[1;37m\]\`if [ \$(jobs | wc -l | tr -d ' ') -gt 0 ]; then echo '[jobs:\j] \[\e[0m\]'; fi\`"
export PS1="${job_status} ${uhp_status} ${bgj_status}\[\033[01;34m\]${prompt}\[\033[00m\] "

# Disable Ctrl-S
stty stop undef

# Make ~/.bash_history unbounded in size (from: http://mywiki.wooledge.org/BashFAQ/088)
unset HISTFILESIZE
export HISTSIZE=10000
export PROMPT_COMMAND="history -a"

# Don't write lines starting with a space or repeat entries to the history
export HISTCONTROL=ignoredups:ignorespace

[[ `basename $SHELL` == bash ]] && shopt -s histappend

settitle() {  # change the title of the current window
  printf "\033k$1\033\\"
}

ssh() {  # set the title of the current window to the host we're sshing into
  settitle "@$( cut -d@ -f2 <<< $* )"
  command ssh "$@"
  settitle `basename $SHELL`
}

vim() {  # set the title of the current window to the file we're editing
  [[ ! -z "$1" ]] && settitle "%%$( basename $1 )"
  command vim "$@"
  settitle `basename $SHELL`
}

# start powerline-daemon if it is in $PATH and not already running
if hash powerline-daemon 2>/dev/null; then
    if [ -z "$( ps aux | grep powerline-daemon | grep -v grep )" ]; then
        powerline-daemon
    fi
fi

# Get pretty ls colours
#eval `dircolors ~/.dircolors`

# Necessary sudo aliases
alias please='sudo'
alias sorry='sudo $(history -p "!!")'
alias rootme='sudo su -s /bin/bash -c "bash --rcfile <(echo \"source $SSHHOME/sshrc.bashrc\")"'
#alias tmux="/usr/bin/tmux -f $SSHHOME/.sshrc.d/tmux.conf"

# install neobundle for vim
rpm -qa git | grep -q git || sudo yum -y install git
curl -s https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > /tmp/neobundle_install.sh
sh /tmp/neobundle_install.sh >/dev/null 2>&1
