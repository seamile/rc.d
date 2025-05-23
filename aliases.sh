export GREP_COLORS='mt=1;31'
export LC_ALL="zh_CN.UTF-8"
export LESS='-NRF'
export LESSOPEN='| pygmentize -g -O style=native %s'

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
alias psgrep='ps ax|grep -v grep|grep'
alias tree='tree -N -C --dirsfirst'
# alias less='less -N'
alias aria='aria2c -c -x 16 --file-allocation=none'
alias axel='axel -n 30'
alias myip='curl -Ls http://seamile.cn/myip'
alias ping='ping -i 0.1 -c 30'
alias ping6='ping6 -i 0.1 -c 30'
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
    alias lock="sudo chflags schg"
    alias unlock="sudo chflags noschg"
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
alias httpserver='python -m http.server'
alias httpserver2='python -m SimpleHTTPServer'
alias pip-search='pip_search'
alias jpy='jupyter notebook'
alias pep='pycodestyle --ignore=E501'
alias rmpyc='find . | grep -wE "py[co]|__pycache__" | xargs rm -rvf'
alias pygrep='grep --include="*.py"'
alias upip='uv pip'
alias uvenv='uv venv'
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

# Pyenv
# eval "$(pyenv init -)";
# eval "$(pyenv virtualenv-init -)"
export PYENV_SHELL=`basename $SHELL`
export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT/shims" ]; then
    export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
    source "$PYENV_ROOT/completions/pyenv.zsh"
    # command pyenv rehash 2>/dev/null  # slowly

    # pyenv alias
    alias chpy='pyenv global'
    alias chlpy='pyenv local'
    alias chgpy='pyenv global'

    function pyenv() {
      local command
      command="${1:-}"
      if [ "$#" -gt 0 ]; then
        shift
      fi

      case "$command" in
      activate|deactivate|rehash|shell)
        eval "$(pyenv "sh-$command" "$@")";;
      *)
        command pyenv "$command" "$@";;
      esac
    }
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
