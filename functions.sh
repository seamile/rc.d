# get the relative path to current dir
function relpath() {
    realpath --relative-to='.' $1
}


# virtual activate
function wk() {
    if [[ $# == 0 ]]; then
        dest="."
    elif [ -d $1 ]; then
        dest="$1"
    else
        printf "$1 is not a directory.\n"
        return 1
    fi

    for actv in $(find $dest -maxdepth 4 -type f -name activate)
    do
        if source $actv; then
            echo -e "loading \033[35m$(dirname $(dirname $actv))\033[0m"
            return
        fi
    done
    echo 'Venv: Cannot find the activate file.'
}


# Proxy
function proxy() {
    if [ -z "$ALL_PROXY" ]; then
        export HTTP_PROXY="socks5://127.0.0.1:1086"
        export HTTPS_PROXY="socks5://127.0.0.1:1086"
        export ALL_PROXY="socks5://127.0.0.1:1086"
        printf "Proxy on: $ALL_PROXY\n";
    else
        unset HTTP_PROXY;
        unset HTTPS_PROXY;
        unset ALL_PROXY;
        printf 'Proxy off\n';
    fi
}


# fix brew include files
function fixBrewInclude() {
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


# kill tmux's session
function tkill() {
    if [[ "$1" == "-a" ]]; then
        tmux kill-session -a
    else
        for target in $@
        do
            if tmux kill-session -t $target; then
                echo "Tmux session $target has been killed"
            fi
        done
    fi
}
