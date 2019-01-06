#!/bin/bash

_PWD=$PWD

PYTHON_VERSION='3.6.7'
BREW_URL='https://raw.githubusercontent.com/Homebrew/install/master/install'
OH_MY_ZSH_URL='https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh'
POWERLINE_FONTS_URL='https://github.com/powerline/fonts.git'
PYENV_URL='https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer'
RC_URL='git@github.com:seamile/rc.d.git'

# check cmd exist
exist() {
    if which $1 > /dev/null; then
        return 0
    else
        return 1
    fi
}

# ensure brew
if [[ `uname` == 'Darwin' ]] && ! `exist brew`; then
    ruby -e "$(curl -fsSL $BREW_URL)"
fi

# ensure zsh, git, curl, wget, and other softwares
if [[ `uname` == 'Darwin' ]]; then
    brew update
    brew install zsh tmux git curl wget aria2
    brew install openssl readline sqlite3 xz zlib
elif `exist apt-get`; then
    apt-get update
    apt-get install -y zsh tmux git curl wget aria2
    apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev xz-utils libxml2-dev libxmlsec1-dev libffi-dev
elif `exist yum`; then
    yum update
    yum install -y zsh tmux git curl wget aria2
    yum install gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz
else
    echo 'not found any package installer'
    exit 1
fi

# install powerline fonts
if [ ! -d $HOME/.powerline-fonts ]; then
    git clone --depth=1 $POWERLINE_FONTS_URL $HOME/.powerline-fonts
    $HOME/.powerline-fonts/install.sh
else
    echo "powerline-fonts is already installed"
fi

# install oh-my-zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
    bash -c "$(curl -fsSL $OH_MY_ZSH_URL)"
else
    echo "oh-my-zsh is already installed"
fi

# install pyenv
if [ ! -d $HOME/.pyenv ]; then
    curl -L $PYENV_URL | bash
    pyenv update
else
    echo "pyenv is already installed"
fi

# install python
if ! pyenv versions | grep $PYTHON_VERSION > /dev/null; then
    env PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install -kv $PYTHON_VERSION
else
    echo "Python v$PYTHON_VERSION is already installed"
fi

# clone rc.d
if [ ! -d $HOME/.rc.d ]; then
    git clone $RC_URL $HOME/.rc.d
else
    echo "rc.d is already cloned"
fi

# link rc files
cd $HOME
ln -sf .rc.d/gitconfig .gitconfig
ln -sf .rc.d/vimrc .vimrc
ln -sf .rc.d/zshrc .zshrc
ln -sf .rc.d/bashrc .bashrc
ln -sf .rc.d/tmux.conf .tmux.conf

# link zsh themes
cd $HOME/.oh-my-zsh/custom/themes
for name in `ls $HOME/.rc.d/omz-theme`
do
    ln -sf $HOME/.rc.d/omz-theme/$name $name
done

# install python requirements
pyenv global $PYTHON_VERSION
pip install -r $HOME/.rc.d/requirements.txt

cd $_PWD
