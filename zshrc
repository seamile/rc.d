# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(golang python docker)

source $ZSH/oh-my-zsh.sh

# User configuration
DEFAULT_USER=Seamile

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
export GOROOT="/usr/local/opt/go/libexec"
export GOPATH="$HOME/Golang"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
if which go > /dev/null; then
    alias gd='go doc'
    alias gdr='echo -e "Listen 0.0.0.0:9090";godoc -http 0.0.0.0:9090'
fi

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
alias .='source'
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
    if [ -z $1 ]; then
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

# source zshrc.local
if [[ -r "$HOME/.zshrc.local" && -r "$HOME/.zshrc.local" ]]; then
    source $HOME/.zshrc.local
fi
