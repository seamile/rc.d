# Load bashrc on MacOS
if [ `uname` = "Darwin" ]; then
    alias ls='ls -G'
fi

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
alias grep='grep --color=auto --exclude-dir={.git,.hg,.svn}'
export GREP_COLOR='1;31'
if [ -d $HOME/.bin ]; then
    export PATH=$HOME/.bin:$PATH
fi

# brew
if which brew > /dev/null; then
    # BREWHOME=`brew --prefix`
    BREWHOME="/usr/local"
    export LDFLAGS="-L$BREWHOME/lib"
    export CPPFLAGS="-I$BREWHOME/include"
    export PKG_CONFIG_PATH="$BREWHOME/lib/pkgconfig"
fi

# Golang env
export GOPATH="$HOME/Golang"
export PATH="$GOPATH/bin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if which pyenv > /dev/null; then
    eval "$(pyenv init -)";
    eval "$(pyenv virtualenv-init -)"
    # alias
    alias pyv='python --version;pyenv version'
    alias chpy='pyenv global'
    alias chlpy='pyenv local'
    alias chgpy='pyenv global'
    # func
    wk () {
        if [[ -d "$1" ]]; then
            source $1/bin/activate
        elif [[ -f "$1" ]]; then
            source $1
        else
            echo 'Venv: No such file or directory:' $1
        fi
    }
fi

# Custom alias
alias l='ls -Clho'
alias ll='ls -ClhF'
alias la='ls -A'

alias rs='rsync -cvrP --exclude={.git,.hg,.svn}'
alias pweb='python -m SimpleHTTPServer'
alias psgrep='ps ax|grep -v grep|grep'
alias tree='tree -C --dirsfirst'
alias less='less -N'
alias tkill='tmux kill-session -t'
alias aria='aria2c -c -x 16'
alias myip='echo $(curl -s https://api.ipify.org)'
if [ `uname` = "Darwin" ]; then
    alias tailf='tail -F'
    alias rmds='find ./ | grep ".DS_Store" | xargs rm -fv'
    alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
fi

# Python alias
alias py='python'
alias py2='python2'
alias py3='python3'
alias ipy='ipython'
alias ipy2='ipython2'
alias ipy3='ipython3'
alias pep='pep8 --ignore=E501'
alias rmpyc='find ./ | grep "py[co]$" | xargs rm -fv'

# Git alias
alias gst='git status -sb'
alias gdf='git difftool'
alias glg='git log --graph --max-count=10'
alias gco='git checkout'
alias gmg='git merge --no-commit --squash'

# pgrep && top
topgrep() {
    if [ `uname` = "Darwin" ]; then
        local CMD="top"
        for P in $(pgrep $1); do
            CMD+=" -pid $P"
        done
        eval $CMD
    else
        local CMD="top -p "
        for P in $(pgrep $1); do
            CMD+="$P,"
        done
        eval ${CMD%%,}
    fi
}

# Proxy
proxy() {
    if [ -z "$ALL_PROXY" ]; then
        export ALL_PROXY="socks5://127.0.0.1:1080"
        printf 'Proxy on\n';
    else
        unset ALL_PROXY;
        printf 'Proxy off\n';
    fi
}

# ssh gate
gfw() {
    local GFW_PID=`ps ax|grep -v grep|grep 'ssh -qTfnN -D 7070 root@box'|awk '{print $1}'`
    if [ ! -e $GFW_PID ]; then
        kill -9 $GFW_PID
    fi
    ssh -qTfnN -D 7070 root@box
}

# check ip
chkip() {
    if [[ $# == 0 ]]; then
        curl -s "http://ip.cn/"
    else
        local IP
        for IP in $@; do
            curl -s "http://ip.cn/index.php?ip=$IP"
        done
    fi
}

# enter docker container
ent() {
    docker exec -it $1 /bin/bash
}

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
