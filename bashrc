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

export HISTTIMEFORMAT="[%y-%m-%d_%T]  "

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
