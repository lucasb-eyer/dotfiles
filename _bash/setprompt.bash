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
    export PS1="${err_prompt}[`prt_username`@`prt_hostname`:`prt_dir` `prt_time`]`prt_git`\n${BLUE}$ ${DEFAULT}"
}

PROMPT_COMMAND=prompt_command

prt_ret () {
    RET=$?
    if [ $RET -ne 0 ]; then
        echo "${RED}O.o ${RET}${DEFAULT}"
    else
        echo "${TEST}:) ${DEFAULT}"
    fi
}

prt_git () {
    # Check if inside a git repo
    git branch > /dev/null 2>&1
    if [ $? -ne 0 ]; then
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

    # Set arrow icon based on status against remote.
    remote_pattern="# Your branch is (.*) of"
    if [[ ${git_status} =~ ${remote_pattern} ]]; then
        if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
            remote="↑"
        else
            remote="↓"
        fi
    else
        remote=""
    fi
    diverge_pattern="# Your branch and (.*) have diverged"
    if [[ ${git_status} =~ ${diverge_pattern} ]]; then
        remote="↕"
    fi

    # Get the name of the branch.
    branch_pattern="^# On branch ([^${IFS}]*)"
    if [[ ${git_status} =~ ${branch_pattern} ]]; then
         branch=${BASH_REMATCH[1]}
    fi

    # Set the final branch string.
    echo "${state}(${branch})${remote}${DEFAULT}"
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

prt_time () { #format time just the way I likes it
    if [ `date +%p` = "PM" ]; then
        meridiem="pm"
    else
        meridiem="am"
    fi
    val=`date +"%l:%M:%S$meridiem"|sed 's/ //g'`
    echo "${YELLOW}$val${DEFAULT}"
}
