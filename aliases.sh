export GREP_COLORS='mt=1;31'
export LC_ALL="zh_CN.UTF-8"
# export LESS='-NRF'
# export LESSOPEN='| pygmentize -g -O style=native %s'

[[ ! ":${PATH}:" =~ "/usr/local/sbin" ]] && export PATH="/usr/local/sbin:$PATH"
[[ ! ":${PATH}:" =~ "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ ! ":${PATH}:" =~ "$HOME/.local/utils" ]] && export PATH="$HOME/.local/utils:$PATH"

# Custom alias
alias l='ls -ClhoF'
alias li='ls -Clhoi'
alias ll='ls -ClhF'
alias la='ls -A'
alias lla='ls -ClhFA'
alias rm='rm -v'
alias cp='cp -nv'
alias mv='mv -nv'
alias ln='ln -v'
alias rs="rsync -crvzptHP --exclude='.[A-Za-z0-9._-]*' --exclude={__pycache__,'*.pyc'}"
alias grep="grep -I --color=auto --exclude-dir='.[A-Za-z0-9._-]*'"
alias psgrep='pscm|grep -v grep|grep'
alias tree='tree -N -C --dirsfirst'
# alias less='less -N'
alias aria='aria2c -c -x 16 --file-allocation=none'
alias axel='axel -n 30'
alias myip='curl -Ls http://seamile.cn/myip'
alias ping='ping -i 0.2 -c 10'
alias ping6='ping6 -i 0.2 -c 10'
alias ip4="ifconfig | grep -w inet | awk '{print \$2}'| sort"
alias ip6="ifconfig | grep -w inet6 | awk '{print \$2}'| sort"
alias tailf='tail -F'
alias tm='tmux attach || tmux'

# macOS alias
if [ `uname` = "Darwin" ]; then
    export HOMEBREW_NO_AUTO_UPDATE=true  # disable homebrew auto update
    # export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    # export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
    export HOMEBREW_NO_INSTALL_CLEANUP=1
    alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    alias lock="sudo chflags schg"
    alias unlock="sudo chflags noschg"
fi

# Python alias
alias py='python'
alias ipy='ipython'
alias httpserver='python -m http.server'
alias pip-search='pip_search'
alias rmpyc='find . | grep -wE "py[co]|__pycache__" | xargs rm -rvf'
alias pygrep='grep --include="*.py"'
alias pip='uv pip'
alias venv='uv venv'
alias upy='uv python'

# Git alias
alias gad='git add'
alias gst='git status -sb'
alias gdf='git difftool'
alias glg='git log --stat --graph --max-count=10'
alias gpl='git pull'
alias gci='git commit'
alias gco='git checkout'
alias gsw='git switch'
alias gmg='git merge --no-commit --squash'

# brew
if command -v brew >/dev/null 2>&1; then
    # BREWHOME=`brew --prefix`
    BREWHOME="/usr/local"
    export LDFLAGS="-L$BREWHOME/lib"
    export CPPFLAGS="-I$BREWHOME/include"
    export PKG_CONFIG_PATH="$BREWHOME/lib/pkgconfig"
fi

# Rust env
if [[ -d $HOME/.cargo  && ! ":${PATH}:" =~ "$HOME/.cargo/bin" ]]; then
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

# Podman
if command -v podman >/dev/null 2>&1; then
    alias docker="podman"
    alias docker-compose="podman-compose"
    export PODMAN_COMPOSE_WARNING_LOGS=false
fi

# pnpm
if command -v pnpm >/dev/null 2>&1; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    # pnpm config set global-bin-dir $HOME/.local/bin
    alias npm='pnpm'
    alias npx='pnpx'
fi
