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
        for P in `pgrep $1`; do
            CMD+=" -pid $P"
        done
        eval $CMD
    else
        local CMD="top -p "
        for P in `pgrep $1`; do
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
jmp() {
    if ! lsof -i:7070 > /dev/null
    then
        server=$1 || server='box'
        ssh -qTfnN -D 7070 root@$server
        echo "proxy: $server:7070"
    else
        echo "port 7070 in used"
    fi
}


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
            cnt=`find $dir -type file | wc -l`
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

# md5sum
md5sum() {
    for fname in $@
    do
        if [ -f $fname ]; then
            checksum=`md5 -q $fname`
            echo "$checksum  $fname"
        fi
    done
}
