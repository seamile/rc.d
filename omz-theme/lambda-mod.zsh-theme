#!/usr/bin/env zsh

local LAMBDA="%(?,%{$fg_bold[blue]%}λ,%{$fg_bold[red]%}✘)"
local END="%(?,%{$fg_bold[blue]%}❯ ,%{$fg_bold[red]%}❯ )"

# set username's color
if [[ "$USER" == "root" ]]; then
    local USERCOLOR="red"
else
    local USERCOLOR="yellow"
fi

# check if current dir is a Git repo
if which git > /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
    local IS_GIT_REPO=true
else
    local IS_GIT_REPO=false
fi


function is_clean() {
    local STATUS=''
    local -a FLAGS
    FLAGS=('--porcelain')

    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
        FLAGS+='--ignore-submodules=dirty'
    fi

    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
        FLAGS+='--untracked-files=no'
    fi

    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)

    if [[ -n $STATUS ]]; then
        return 1
    else
        return 0
    fi
}

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" ["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}✚ "
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[green]%}⤒  "
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_bold[green]%}⤓  "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}✖  "
ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg_bold[yellow]%}ᚶ  "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[red]%}● "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}⤳  "
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[cyan]%}☑  "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}⤭  "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[yellow]%}? "

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg_bold[white]%}[%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg_bold[white]%}]"

function git_prompt_info() {
    local ref
    if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
        ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0

        local git_prompt="$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"

        if is_clean; then
            echo "$ZSH_THEME_GIT_PROMPT_CLEAN$git_prompt"
        else
            echo "$ZSH_THEME_GIT_PROMPT_DIRTY$git_prompt"
        fi
    fi
}

# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string.
function check_git_prompt_info() {
    if [[ $IS_GIT_REPO = true ]] ; then
        echo -e "$(git_prompt_info) $(git_prompt_status)\n$END"
    else
        echo "$END"
    fi
}

function get_right_prompt() {
    if [[ $IS_GIT_REPO = true ]] ; then
        echo -n "$(git_prompt_short_sha)%{$reset_color%}"
    else
        echo -n "%{$reset_color%}"
    fi
}

PROMPT=$LAMBDA'\
 %{$fg_bold[$USERCOLOR]%}%n\
 %{$fg_no_bold[blue]%}[%3~]\
 $(check_git_prompt_info)\
%{$reset_color%}'

RPROMPT='$(get_right_prompt)'
