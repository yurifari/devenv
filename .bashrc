# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200

# [[ $TERM != "screen" ]] && exec tmux
test -s ~/.alias && . ~/.alias || true

source /usr/bin/virtualenvwrapper

source <(kubectl completion bash)
source <(pip completion --bash)

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# Aliases

alias kubetest='kubectl -n qws-test'
alias kubeprod='kubectl -n qws-prod'


# Prompt

source ~/.git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="verbose name"

color() {
    echo -n "\["; tput setaf $1; echo -n "\]"
    echo -n $2
    echo -n "\["; tput sgr0; echo -n "\]"
}

style() {
    echo -n "\["; tput $1; echo -n "\]"
    echo -n $2
    echo -n "\["; tput sgr0; echo -n "\]"
}

separator() {
    echo "\[\e[90m\]$1\[\e[0m\]"
}

get_penv() {
    project=$(cat $VIRTUAL_ENV/$VIRTUALENVWRAPPER_PROJECT_FILENAME)
    conf=$project/.configured

    if [[ -e $conf ]]; then
        penv=$(grep "env:" $project/.configured | head -1)
        penv=${penv##*:[[:space:]]}
    else
        penv=""
    fi

    echo $penv
}

get_soenv () {
    PS1="\w"

    if [[ -n "$VIRTUAL_ENV" ]]; then
        venv=$(style bold $(basename $VIRTUAL_ENV))
        envs="$venv"
        penv=$(get_penv)

        if [[ -n $penv ]]; then
            if [[ "$penv" == "test" ]]; then
                env_col=3
            elif [[ "$penv" == "prod" ]]; then
                env_col=1
            else
                env_col=7
            fi

            cpenv=$(color $env_col $penv)
            envs="$envs$(separator :)$cpenv"
        fi

        PS1="$PS1 $(separator ») $envs"
    fi

    psgit=$(__git_ps1)

    if [[ -n "$psgit" ]]; then
        psgit=${psgit:2:-1}
        branch=$(printf $psgit | cut -d" " -f 1)
        gitflags=$(printf $psgit | cut -d" " -f 2)

        PS1="$PS1 $(separator ») $branch"

        if [[ "$branch" -ne "$gitflags" ]]; then
            PS1="$PS1 $(color 6 $gitflags)"
        fi
    fi

    PS1="$PS1 $(style bold $) "
}

PROMPT_COMMAND="get_soenv; $PROMPT_COMMAND"


# Commands

runinto() {
    current_env=$(get_penv)
    invoke configure -e $1 > /dev/null
    eval ${@:2}
    invoke configure -e $current_env > /dev/null
}
