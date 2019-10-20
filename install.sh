#!/bin/bash

CURRENT_DIR=$PWD

RC_DIR="$HOME/.rc.d"

PYTHON_VERSION='3.6.9'
BREW_URL='https://raw.githubusercontent.com/Homebrew/install/master/install'
OH_MY_ZSH_URL='https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh'
POWERLINE_FONTS_URL='https://github.com/powerline/fonts.git'
PYENV_URL='https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer'
RC_URL='https://github.com/seamile/rc.d.git'
UTILS_URL='https://github.com/seamile/utilities.git'


function exist() {
    which $1 > /dev/null
    return $?
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


function install_packages_for_macos() {
    echo "exec: install_packages_for_macos"

    brew -v update
    brew install `cat $RC_DIR/packages/brew-pkg`

    echo 'done!'
}


function install_softwares_for_macos() {
    echo "exec: install_softwares_for_macos"

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


function install_packages_for_ubuntu() {
    echo "exec: install_packages_for_ubuntu"

    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y `cat $RC_DIR/packages/apt-pkg`

    echo 'done!'
}


function install_packages_for_fedora() {
    echo "exec: install_packages_for_fedora"

    sudo yum update
    sudo yum install -y `cat $RC_DIR/packages/yum-pkg`

    echo 'done!'
}


function install_sys_packages() {
    echo "exec: install_sys_packages"

    if [[ `uname` == 'Darwin' ]]; then
        install_packages_for_macos
    elif `exist apt-get`; then
        install_packages_for_ubuntu
    elif `exist yum`; then
        install_packages_for_fedora
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
        env PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install -kv $PYTHON_VERSION
    else
        echo "Python v$PYTHON_VERSION is already installed"
    fi

    pyenv global $PYTHON_VERSION

    echo 'done!'
}


function install_python_pkg() {
    echo "exec: install_python_pkg"

    pyenv global $PYTHON_VERSION
    pip install -r $RC_DIR/packages/python-pkg

    echo 'done!'
}


function clone_rc_d() {
    echo "exec: clone_rc_d"

    if [ ! -d $RC_DIR ]; then
        git clone $RC_URL $RC_DIR
    else
        echo "rc.d is already cloned"
    fi

    git clone $UTILS_URL $RC_DIR/utilities

    echo 'done!'
}


function setup_env() {
    echo "exec: setup_env"

    # mkdir .local/bin
    mkdir -p $HOME/.local/bin

    # link rc files
    cd $HOME
    ln -sf .rc.d/gitconfig .gitconfig
    ln -sf .rc.d/vimrc .vimrc
    ln -sf .rc.d/zshrc .zshrc
    ln -sf .rc.d/bashrc .bashrc
    ln -sf .rc.d/tmux.conf .tmux.conf
    ln -sf .rc.d/myclirc .myclirc

    # link aria2
    mkdir -p $HOME/.aria2
    cd $HOME/.aria2
    ln -sf $RC_DIR/aria2.conf aria2.conf

    touch $HOME/.zshrc.local

    echo 'done!'
}


function setup_zsh_theme() {
    echo "exec: setup_zsh_theme"

    cd $HOME/.oh-my-zsh/custom/themes
    for name in `ls $RC_DIR/omz-theme`
    do
        # link zsh themes
        ln -sf $RC_DIR/omz-theme/$name $name
    done

    echo 'done!'
}


function install_all() {
    install_brew
    install_software
    install_powerline_fonts
    install_ohmyzsh
    install_pyenv
    install_python
    install_python_pkg
    clone_rc_d
    setup_env
    setup_zsh_theme
}


cat << EOF
select a function code:
===============================
【 1 】 install_brew
【 2 】 install_sys_packages
【 3 】 install_powerline_fonts
【 4 】 install_ohmyzsh
【 5 】 install_pyenv
【 6 】 install_python
【 7 】 install_python_pkg
【 8 】 clone_rc_d
【 9 】 setup_env
【 0 】 setup_zsh_theme
【 a 】 install_all;;
【 b 】 install_softwares_for_macos;;
【 * 】 exit
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
    8) clone_rc_d;;
    9) setup_env;;
    0) setup_zsh_theme;;
    a) install_all;;
    b) install_softwares_for_macos;;
    *) echo 'Bye' && exit;;
esac


cd $CURRENT_DIR
