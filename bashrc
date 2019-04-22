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
alias grep='grep -I --color=auto --exclude-dir={.git,.hg,.svn,.venv}'
export GREP_COLOR='1;31'
if [ -d $HOME/.local/bin ]; then
    export PATH=$HOME/.local/bin:$PATH
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
export GOPATH="$HOME/src/Golang"
export PATH="$GOPATH/bin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if which pyenv > /dev/null; then
    eval "$(pyenv init -)";
    eval "$(pyenv virtualenv-init -)"
    # pyenv alias
    alias pyv='pyenv versions'
    alias chpy='pyenv global'
    alias chlpy='pyenv local'
    alias chgpy='pyenv global'
fi
# pip
if which pip > /dev/null; then
    eval "$(pip completion --bash)"
fi

# Custom alias
alias l='ls -Clho'
alias ll='ls -ClhF'
alias la='ls -A'
alias lla='ls -ClhFA'

alias rs='rsync -cvrP --exclude={.git,.hg,.svn,.venv}'
alias httpserver='python -m SimpleHTTPServer'
alias httpserver3='python -m http.server'
alias psgrep='ps ax|grep -v grep|grep'
alias tree='tree -C --dirsfirst'
alias less='less -N'
alias tkill='tmux kill-session -t'
alias aria='aria2c -c -x 16 --file-allocation=none'
alias axel='axel -n 30'
alias myip='echo $(curl -s https://api.ipify.org)'
alias ping='ping -i 0.1 -c 10'

# macOS alias
if [ `uname` = "Darwin" ]; then
    export HOMEBREW_NO_AUTO_UPDATE=true  # disable homebrew auto update
    alias tailf='tail -F'
    alias rmds='find . -type f -name .DS_Store -delete'
    alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    alias power="echo Power: $(pmset -g batt|awk 'NR==2{print $3}'|sed 's/;//g')"
    alias clsattr="xattr -lr ."
    alias tree='tree -N'
fi

# Python alias
alias py='python'
alias py2='python2'
alias py3='python3'
alias ipy='ipython'
alias ipy2='ipython2'
alias ipy3='ipython3'
alias pep='pycodestyle --ignore=E501'
alias rmpyc='find . | grep -wE "py[co]|__pycache__" | xargs rm -rvf'
alias pygrep='grep --include="*.py"'

# Git alias
alias gst='git status -sb'
alias gdf='git difftool'
alias glg='git log --stat --graph --max-count=10'
alias gco='git checkout'
alias gmg='git merge --no-commit --squash'

# virtual activate
wk () {
    if [[ -f "$1/.venv/bin/activate" ]]; then
        source $1/.venv/bin/activate
    elif [[ -f "$1/bin/activate" ]]; then
        source $1/bin/activate
    elif [[ -f "$1/activate" ]]; then
        source $1/activate
    elif [[ -f "$1" ]]; then
        source $1
    elif [[ -f ".venv/bin/activate" ]]; then
        source .venv/bin/activate
    else
        echo 'Venv: Cannot find the activate file.'
    fi
}

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
        if [[ $1 == "-s" ]]; then
            export ALL_PROXY="socks5://127.0.0.1:1080"
        else
            export ALL_PROXY="http://127.0.0.1:1087"
        fi
        printf "Proxy on: $ALL_PROXY\n";
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
# chkip() {
#     local PYCODE="import sys,json;o=json.load(sys.stdin);s1='IP : %(query)s\nLoc: %(city)s / %(regionName)s / %(country)s\nPos: %(lat)s / %(lon)s';s2='IP : %(query)s\nInf: %(message)s';s=s2 if 'message' in o else s1;print(s % o);"
#     if [[ $# == 0 ]]; then
#         curl -s "http://ip-api.com/json/" | python -c "$PYCODE"
#     else
#         local IP i=0
#         for IP in $@; do
#             curl -s "http://ip-api.com/json/$IP" | python -c "$PYCODE"
#             ((i++))
#             if [[ $i < $# ]]; then
#                 echo ''
#             fi
#         done
#     fi
# }

# enter docker container
ent() {
    docker container start $1
    docker exec -it $1 /bin/bash
}

# fix brew include files
fixBrewInclude() {
    cd $BREWHOME/include
    for dir in `find -L ../opt -name include`
    do
        for include in `ls $dir`
        do
            local SRC="$dir/$include"
            if [ -d $SRC ] || [[ ${SRC##*.} == "h" ]]; then
                local DST="./$include"
                [[ -e $DST ]] || echo "ln -s $SRC $DST"
            fi
        done
    done
    cd -
}

# set filename with crc32
crcname() {
    for filename in $*
    do
        if [[ -f $filename ]]; then
            hash_value=`crc32 $filename`
            ext_name=`echo "${filename##*.}" | tr '[:upper:]' '[:lower:]'`
            new_name="$hash_value.$ext_name"
            mv -nv $filename $new_name
        fi
    done
}

# list files of each dir
filecount() {
    for dir in `ls -A $1`
    do
        if [ -d $dir ]; then
            cnt=$(find $dir -type file | wc -l)
            printf "%6s %s\n" $cnt $dir
        fi
    done
}

# download by bee
sdown() {
    ssh bee "wget $1 -O /tmp/$2"
    scp bee:/tmp/$2 $2
    ssh bee "rm /tmp/$2"
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
