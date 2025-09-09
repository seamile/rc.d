function highlight() {
    local message="$1"
    shift
    local codes=""

    for style in "$@"; do
        style=$(echo "$style" | tr '[:upper:]' '[:lower:]')
        case $style in
            # styles
            reset)            codes+='\033[0m' ;;
            bold)             codes+='\033[1m' ;;
            dim)              codes+='\033[2m' ;;
            italic)           codes+='\033[3m' ;;
            underline)        codes+='\033[4m' ;;
            blink)            codes+='\033[5m' ;;
            reverse)          codes+='\033[7m' ;;
            # foreground colors
            black)            codes+='\033[30m' ;;
            red)              codes+='\033[31m' ;;
            green)            codes+='\033[32m' ;;
            yellow)           codes+='\033[33m' ;;
            blue)             codes+='\033[34m' ;;
            magenta)          codes+='\033[35m' ;;
            cyan)             codes+='\033[36m' ;;
            white)            codes+='\033[37m' ;;
            gray)             codes+='\033[90m' ;;
            light_red)        codes+='\033[91m' ;;
            light_green)      codes+='\033[92m' ;;
            light_yellow)     codes+='\033[93m' ;;
            light_blue)       codes+='\033[94m' ;;
            light_magenta)    codes+='\033[95m' ;;
            light_cyan)       codes+='\033[96m' ;;
            light_white)      codes+='\033[97m' ;;
            # background colors
            bg_black)         codes+='\033[40m' ;;
            bg_red)           codes+='\033[41m' ;;
            bg_green)         codes+='\033[42m' ;;
            bg_yellow)        codes+='\033[43m' ;;
            bg_blue)          codes+='\033[44m' ;;
            bg_magenta)       codes+='\033[45m' ;;
            bg_cyan)          codes+='\033[46m' ;;
            bg_white)         codes+='\033[47m' ;;
            bg_light_black)   codes+='\033[100m' ;;
            bg_light_red)     codes+='\033[101m' ;;
            bg_light_green)   codes+='\033[102m' ;;
            bg_light_yellow)  codes+='\033[103m' ;;
            bg_light_blue)    codes+='\033[104m' ;;
            bg_light_magenta) codes+='\033[105m' ;;
            bg_light_cyan)    codes+='\033[106m' ;;
            bg_light_white)   codes+='\033[107m' ;;
            *) echo "Invalid style: $style"; return 1 ;;
        esac
    done
    printf "${codes}${message}\033[0m"
}

function rmds() {
  find "${@:-.}" -type f -name .DS_Store -delete
}

function preview() {
  (( $# > 0 )) && qlmanage -p $* &>/dev/null &
}

# ps with cpu and memory
function pscm() {
    ps -eo pid,pcpu,rss,args |
    awk 'NR>1 {printf "%-6s %-5s %7.1f MB  %s\n", $1, $2" %", $3/1024, substr($0, index($0,$4))}'
}

# show python version
function pyv() {
    highlight "$(python --version)" yellow bold
    highlight " ($(which python))\n" gray
}

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
        highlight "Venv: $1 is not a directory.\n" red
        return 1
    fi

    for actv in $(find $dest -maxdepth 4 -type f -name activate); do
        if source $actv; then
            printf "Work on "
            highlight "$(dirname $(dirname $actv))\n" magenta bold
            return
        fi
    done
    highlight "Venv: Cannot find the activate file.\n" red
}


# Proxy
function proxy() {
    if [ -n "$1" ]; then
        port=$1
    else
        port=7890
    fi
    if [ -z "$all_proxy" ]; then
        export http_proxy=http://127.0.0.1:$port
        export https_proxy=http://127.0.0.1:$port
        export all_proxy=socks5://127.0.0.1:$port
        printf "Proxy on: $all_proxy\n";
    else
        unset http_proxy;
        unset https_proxy;
        unset all_proxy;
        printf 'Proxy off\n';
    fi
}


# fix brew include files
function fixBrewInclude() {
    cd $BREWHOME/include
    for dir in `find -L ../opt -name include`; do
        for include in `ls $dir`; do
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
        for target in $@; do
            if tmux kill-session -t $target; then
                highlight "Tmux session $target has been killed\n" yellow
            fi
        done
    fi
}

# colored less
# function less() {
#     while getopts "f:" opt; do
#         case $opt in
#         f)
#             fmt=$OPTARG
#             ;;
#         *)
#             echo "Usage: less [-f format] file"
#             return 1
#             ;;
#         esac
#     done
#     shift $((OPTIND - 1))
#
#     if command -v pygmentize > /dev/null 2>&1; then
#         if [ -z "$fmt" ]; then
#             pygmentize -g -O style=native $1 | /usr/bin/less -NR
#         else
#             pygmentize -l $fmt -O style=native $1 | /usr/bin/less -NR
#         fi
#     else
#         /usr/bin/less -N "$1"
#     fi
# }

# 进行简单的数学运算
# Usage: calc '(1 + 2) * 3'
calc() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        result=$(echo "$*" | bc -lz)
    else
        result=$(echo "$*" | bc -l)
    fi
    if [[ "$result" =~ '\.' ]]; then
        printf "%.2f\n" "$result"
    else
        echo $result
    fi
}

# 查看 macOS 电池电量
function power() {
    pwr=$(pmset -g batt|awk 'NR==2{print $3}'|sed 's/;//g')
    echo "Power: $pwr"
}

# 检查 MacBook 的电池情况
function chk-battery() {
    device=$(sysctl hw.model|awk '{print $2}')
    max_capacity=$(ioreg -r -c "AppleSmartBattery" | grep -w 'MaxCapacity' | awk '{print $3}')
    design_capacity=$(ioreg -r -c "AppleSmartBattery" | grep -w 'DesignCapacity' | tail -1 | awk '{print $3}')
    cycle_count=$(system_profiler SPPowerDataType | grep 'Cycle Count' | awk '{print $3}')

    # 计算损耗率
    if [[ -n "$max_capacity" && -n "$design_capacity" ]]; then
        loss_percentage=$(echo "(1 - ($max_capacity * 1.0 / $design_capacity)) * 100" | bc -lz)

        # 显示电池健康状态
        printf "🔋 "
        highlight "${device%%,*} 电池健康状况\n" light_green bold underline
        printf "🔹 当前容量：$max_capacity mAh\n"
        printf "🔹 设计容量：$design_capacity mAh\n"
        printf "🔹 电池损耗：%4.0f %%\n" $loss_percentage
        printf "🔹 循环次数：%4d 次\n" $cycle_count

        # 健康建议
        if [[ $loss_percentage > 20 || $cycle_count > 800 ]]; then
            highlight "🪫 电池健康下降，建议维修！\n" red
        else
            highlight "✅ 电池状态良好，无需更换！\n" green
        fi
    else
        highlight "❌ 无法获取电池信息，请检查系统！\n" red
    fi
}
