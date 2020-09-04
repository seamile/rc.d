#!/bin/bash

CURRENT_DIR=$PWD

RC_DIR="$HOME/.rc.d"
LOCAL_BIN="$HOME/.local/bin"

PYTHON_VERSION='3.8.3'
BREW_URL='https://raw.githubusercontent.com/Homebrew/install/master/install'
OH_MY_ZSH_URL='https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh'
POWERLINE_FONTS_URL='https://github.com/powerline/fonts.git'
PYENV_URL='https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer'
RC_URL='https://github.com/seamile/rc.d.git'
UTILS_URL='https://github.com/seamile/utils.git'


function exist() {
    which $1 > /dev/null
    return $?
}


function ensure_rc() {
    if [ ! -d $RC_DIR ]; then
        git clone $RC_URL $RC_DIR
    fi
}


function install_brew() {
    echo "exec: install_brew"

    if [[ `uname` == 'Darwin' ]] && ! `exist brew`
    then
        xcode-select --install
        ruby -e "$(curl -fsSL $BREW_URL)"
    fi

    echo 'done!'
}


function install_softwares_for_macos() {
    echo "exec: install_softwares_for_macos"

    ensure_rc

    for pkg in `cat $RC_DIR/packages/cask-pkg`
    do
        read -p "Do you want to install '$pkg'? (y/n) " confirm
        if [[ $confirm == "y" ]]
        then
            brew cask install $pkg
        fi
    done

    echo "done!"
}


function install_sys_packages() {
    echo "exec: install_sys_packages"

    ensure_rc

    if [[ `uname` == 'Darwin' ]]; then
        echo "installing brew packages ..."
        brew -v update
        brew install `cat $RC_DIR/packages/brew-pkg`

    elif `exist apt-get`; then
        echo "installing deb packages ..."
        sudo apt update -y
        sudo apt upgrade -y
        sudo apt install -y `cat $RC_DIR/packages/apt-pkg`

    elif `exist yum`; then
        echo "installing rpm packages ..."
        sudo yum update
        sudo yum install -y `cat $RC_DIR/packages/yum-pkg`

    else
        echo 'not found any package installer'
    fi

    echo 'done!'
}


function install_powerline_fonts() {
    echo "exec: install_powerline_fonts"

    if [ ! -d $HOME/.powerline-fonts ]; then
        git clone --depth=1 $POWERLINE_FONTS_URL $HOME/.powerline-fonts
        $HOME/.powerline-fonts/install.sh
    else
        echo "powerline-fonts is already installed"
    fi

    echo 'done!'
}


function install_ohmyzsh() {
    echo "exec: install_ohmyzsh"

    if [ ! -d $HOME/.oh-my-zsh ]; then
        bash -c "$(curl -fsSL $OH_MY_ZSH_URL)"
    else
        echo "oh-my-zsh is already installed"
    fi

    echo 'done!'
}


function install_pyenv() {
    echo "exec: install_pyenv"

    if [ ! -d $HOME/.pyenv ]; then
        curl -L $PYENV_URL | bash
        export PATH="$HOME/.pyenv/bin:$PATH"
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
        pyenv update
    else
        echo "pyenv is already installed"
    fi

    echo 'done!'
}


function install_python() {
    echo "exec: install_python"

    if ! pyenv versions | grep $PYTHON_VERSION > /dev/null; then
        pyenv install -kv $PYTHON_VERSION
    else
        echo "Python v$PYTHON_VERSION is already installed"
    fi

    pyenv global $PYTHON_VERSION

    echo 'done!'
}


function install_python_pkg() {
    echo "exec: install_python_pkg"

    ensure_rc

    pyenv global $PYTHON_VERSION
    pip install -r $RC_DIR/packages/python-pkg

    echo 'done!'
}


function setup_utils() {
    echo "exec: setup_utils"

    mkdir -p $LOCAL_BIN
    cd $LOCAL_BIN
    git clone $UTILS_URL utils

    for u_path in `find utils -maxdepth 1 -perm 0755 -type f`
    do
        ln -sfv $u_path `basename $u_path`
    done
}


function setup_env() {
    echo "exec: setup_env"

    ensure_rc

    # link rc files
    cd $HOME
    ln -sfv .rc.d/gitconfig .gitconfig
    ln -sfv .rc.d/vimrc .vimrc
    ln -sfv .rc.d/zshrc .zshrc
    ln -sfv .rc.d/bashrc .bashrc
    ln -sfv .rc.d/tmux.conf .tmux.conf
    ln -sfv .rc.d/myclirc .myclirc

    # link aria2
    mkdir -p $HOME/.aria2
    cd $HOME/.aria2
    ln -sfv $RC_DIR/aria2.conf aria2.conf

    touch $HOME/.zshrc.local

    echo 'done!'
}


function setup_zsh_theme() {
    echo "exec: setup_zsh_theme"

    ensure_rc

    if [ -d "$HOME/.oh-my-zsh/custom/themes" ]; then
        cd $HOME/.oh-my-zsh/custom/themes
        for name in `ls $RC_DIR/omz-theme`
        do
            # link zsh themes
            ln -sfv $RC_DIR/omz-theme/$name $name
        done
    else
        echo "Please install ohmyzsh first."
        exit 1
    fi

    echo 'done!'
}


function install_all() {
    ensure_rc
    install_brew
    install_sys_packages
    install_powerline_fonts
    install_ohmyzsh
    install_pyenv
    install_python
    install_python_pkg
    setup_utils
    setup_env
    setup_zsh_theme
}


cat << EOF
select a function code:
===============================
【 1 】 Install brew
【 2 】 Install sys packages
【 3 】 Install powerline fonts
【 4 】 Install oh-my-zsh
【 5 】 Install pyenv
【 6 】 Install python
【 7 】 Install python pkg
【 8 】 Setup utils
【 9 】 Setup env
【 0 】 Setup zsh theme
【 a 】 Install all
【 x 】 Install softwares for macos
【 * 】 Exit
===============================
EOF


if [[ -n $1 ]]; then
    choice=$1
    echo "exec: $1"
else
    read -p "select: " choice
fi

case $choice in
    1) install_brew;;
    2) install_sys_packages;;
    3) install_powerline_fonts;;
    4) install_ohmyzsh;;
    5) install_pyenv;;
    6) install_python;;
    7) install_python_pkg;;
    8) setup_utils;;
    9) setup_env;;
    0) setup_zsh_theme;;
    a) install_all;;
    x) install_softwares_for_macos;;
    *) echo 'Bye' && exit;;
esac


cd $CURRENT_DIR
