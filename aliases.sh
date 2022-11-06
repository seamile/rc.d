export GREP_COLOR='1;31'
export LC_ALL="zh_CN.UTF-8"

if [ `uname` = "Darwin" ]; then
    export PATH="/usr/local/sbin:$PATH"
fi

if [ -d $HOME/.local/bin ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Custom alias
alias l='ls -ClhoF'
alias li='ls -Clhoi'
alias ll='ls -ClhF'
alias la='ls -A'
alias lla='ls -ClhFA'
alias rm='rm -v'
alias cp='cp -nv'
alias mv='mv -nv'
alias rs='rsync -crvzpHP --exclude={.git,.venv,.DS_Store,__pycache__,.vscode,.mypy_cache}'
alias httpserver='python -m http.server'
alias httpserver2='python -m SimpleHTTPServer'
alias grep='grep -I --color=auto --exclude-dir={.git,.venv}'
alias psgrep='ps ax|grep -v grep|grep'
alias tree='tree -N -C --dirsfirst'
alias less='less -N'
alias aria='aria2c -c -x 16 --file-allocation=none'
alias axel='axel -n 30'
alias myip='curl -Ls http://seamile.cn/myip'
alias ping='ping -i 0.2 -c 30'
alias ip4="ifconfig | grep -w inet | awk '{print \$2}'| sort"
alias ip6="ifconfig | grep -w inet6 | awk '{print \$2}'| sort"
alias tailf='tail -F'

# macOS alias
if [ `uname` = "Darwin" ]; then
    export HOMEBREW_NO_AUTO_UPDATE=true  # disable homebrew auto update
    # export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    # export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
    alias rmds='find . -type f -name .DS_Store -delete'
    alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    alias power="echo Power: $(pmset -g batt|awk 'NR==2{print $3}'|sed 's/;//g')"
fi

# Python alias
alias py='python'
alias py2='python2'
alias py3='python3'
alias ipy='ipython'
alias ipy2='ipython2'
alias ipy3='ipython3'
alias venv='python -m venv'
alias virtualenv='python -m venv'
alias jpy='jupyter notebook'
alias pep='pycodestyle --ignore=E501'
alias rmpyc='find . | grep -wE "py[co]|__pycache__" | xargs rm -rvf'
alias pygrep='grep --include="*.py"'
if [[ $plugins =~ 'pip' ]]; then
    unalias pip
fi

# Git alias
alias gst='git status -sb'
alias gdf='git difftool'
alias glg='git log --stat --graph --max-count=10'
alias gpl='git pull'
alias gci='git commit'
alias gco='git checkout'
alias gmg='git merge --no-commit --squash'

# brew
if command -v brew >/dev/null 2>&1; then
    # BREWHOME=`brew --prefix`
    BREWHOME="/usr/local"
    export LDFLAGS="-L$BREWHOME/lib"
    export CPPFLAGS="-I$BREWHOME/include"
    export PKG_CONFIG_PATH="$BREWHOME/lib/pkgconfig"
fi

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
    # eval "$(pyenv init -)";
    # eval "$(pyenv virtualenv-init -)"
    # pyenv alias
    alias pyv='pyenv versions'
    alias chpy='pyenv global'
    alias chlpy='pyenv local'
    alias chgpy='pyenv global'
fi

# Rust env
if command -v cargo > /dev/null 2>&1; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Golang env
if command -v go >/dev/null 2>&1; then
    export GOPATH="$HOME/src/Golang"
    export PATH="$GOPATH/bin:$PATH"
    export GOPROXY="https://goproxy.cn"
fi

# Flutter
if command -v flutter >/dev/null 2>&1; then
    # Flutter src dir
    export FLUTTER_ROOT="$HOME/.local/flutter"
    export FLUTTER_SRC="$FLUTTER_ROOT/packages/flutter/lib/src"
    # Flutter CN mirror
    export PUB_HOSTED_URL='https://pub.flutter-io.cn'
    export FLUTTER_STORAGE_BASE_URL='https://storage.flutter-io.cn'
fi
