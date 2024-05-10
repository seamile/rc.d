# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# history settings
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:ignorespace
HISTTIMEFORMAT="[%y-%m-%d_%T]  "

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set PS1
if [ `id -u` == 0 ]; then
    PS1="\[$(tput bold)\]\[$(tput setaf 1)\]\u\[$(tput sgr0)\]\[$(tput setaf 4)\]@\[$(tput sgr0)\]\[$(tput setaf 5)\]\h \[$(tput sgr0)\]\w\[$(tput bold)\]\[$(tput setaf 1)\] \\$ \[$(tput sgr0)\]"
else
    PS1="\[$(tput bold)\]\[$(tput setaf 3)\]\u\[$(tput sgr0)\]\[$(tput setaf 4)\]@\[$(tput sgr0)\]\[$(tput setaf 5)\]\h \[$(tput sgr0)\]\w\[$(tput bold)\]\[$(tput setaf 4)\] \\$ \[$(tput sgr0)\]"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# automatic set_window_title when use screen
if [[ "$TERM" == screen* ]]; then
    screen_set_window_title () {
        local HPWD="$PWD"
        case $HPWD in
            $HOME) HPWD="~";;
            $HOME/*) HPWD="~${HPWD#$HOME}";;
        esac
        printf '\ek%s\e\\' "$HPWD"
    }
    PROMPT_COMMAND="screen_set_window_title; $PROMPT_COMMAND"
fi

# Load bashrc on MacOS
if [ `uname` = "Darwin" ]; then
    alias ls='ls -G'
fi

# source aliases.sh
if [ -f "$HOME/.rc.d/aliases.sh" ]; then
    source $HOME/.rc.d/aliases.sh
fi

# source functions.sh
if [ -f "$HOME/.rc.d/functions.sh" ]; then
    source $HOME/.rc.d/functions.sh
fi

# enable completion features
if ! shopt -oq posix; then
    if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    elif [ -f /usr/local/etc/bash_completion ]; then
        . /usr/local/etc/bash_completion
    elif [ -f /opt/homebrew/etc/bash_completion ]; then
        . /opt/homebrew/etc/bash_completion
    fi
fi

