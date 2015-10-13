#!/bin/bash

fgcol () {
    echo "\\[\\033[48;5;"$1"m\\]"
}

BLACK="\[\033[0;30m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
PINK="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
GRAY="\[\033[0;37m\]"
#TEST="\[\033[0;38m\]"

DEFAULT="\[\033[0m\]"

# Bold
BRED="\[\033[1;31m\]"
BGREEN="\[\033[1;32m\]"
BYELLOW="\[\033[1;33m\]"
BBLUE="\[\033[1;34m\]"
BPINK="\[\033[1;35m\]"
BCYAN="\[\033[1;36m\]"
BGRAY="\[\033[1;37m\]"
DUNNO="\[\033[1;38m\]"

#TEST=`fgcol 117`

prompt_command () {
    local err_prompt=`prt_ret`
    export PS1="${err_prompt}`prt_virtualenv`[`prt_username`@`prt_hostname`:`prt_dir` `prt_time`]`prt_git`\n${BLUE}$ ${DEFAULT}"
}

PROMPT_COMMAND=prompt_command

prt_ret () {
    RET=$?
    if [ $RET -ne 0 ]; then
        echo "${RED}O.o ${RET} ${DEFAULT}"
    else
        echo "${TEST}:) ${DEFAULT}"
    fi
}

prt_virtualenv () {
    if [ $VIRTUAL_ENV ]; then
        d=`dirname $VIRTUAL_ENV`
        parent="`basename $d`/`basename $VIRTUAL_ENV`"
        pyenv="${PINK}($parent)${DEFAULT} "
    fi

    # Node.js virtualenvs (created using nodeenv from pypi)
    if [ $NODE_VIRTUAL_ENV ]; then
        d=`dirname $NODE_VIRTUAL_ENV`
        parent="`basename $d`/`basename $NODE_VIRTUAL_ENV`"
        nodeenv="${PINK}($parent)${DEFAULT} "
    fi

    # Go directories
    if [ $GOPATH ]; then
        d=`dirname $GOPATH`
        name="`basename $d`/`basename $GOPATH`"
        goenv="${PINK}($name)${DEFAULT}"
    fi

    echo "$pyenv$nodeenv$goenv"
}

prt_git () {
    # Check if inside a git repo
    if ! git rev-parse --is-inside-work-tree >&/dev/null 2>&1; then
        return 0
    fi

    # Capture the output of the "git status" command.
    git_status=`git status 2> /dev/null`

    # Set color based on clean/staged/dirty.
    if [[ ${git_status} =~ "working directory clean" ]]; then
        state="${GREEN}"
    elif [[ ${git_status} =~ "Changes to be committed" ]]; then
        state="${YELLOW}"
    else
        state="${RED}"
    fi

    # Get the name of the branch.
    branch=`git symbolic-ref --quiet --short HEAD`
    if [[ $? -gt 0 ]]; then
        branch=`git log -n 1 --pretty=%h HEAD`
    fi

    # Set arrow icon based on status against remote.
    remote=`git config branch.${branch}.remote`
    ahead=`git rev-list --count $remote/${branch}..HEAD`
    behind=`git rev-list --count HEAD..$remote/$branch`
    if [[ $ahead -gt 0 ]] && [[ $behind -gt 0 ]]; then
        remotestat="↕+$ahead-$behind"
    elif [[ $ahead -gt 0 ]]; then
        remotestat="↑$ahead"
    elif [[ $behind -gt 0 ]]; then
        remotestat="↓$behind"
    fi

    # Set the final branch string.
    echo "${state}(${branch})${remotestat}${DEFAULT}"
}

prt_username () {
    who=`whoami`
    if [ $who = "root" ]; then
        echo "${BRED}${who}${DEFAULT}"
    else
        echo "${GREEN}${who}${DEFAULT}"
    fi
}

prt_hostname () {
    echo "${BLUE}\h${DEFAULT}"
}

prt_dir () {
    echo "${CYAN}\w${DEFAULT}"
}

prt_time () {
    val=`date +"%k:%M:%S"`
    echo "${YELLOW}$val${DEFAULT}"
}
