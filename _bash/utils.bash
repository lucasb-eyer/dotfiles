# The commented-out version would be better as it lets one specify the virtualenv dirname but
# for some reason beyond my understanding, it doesn't work (my_mkenv unknown)

function my_mkenv {
    function my_fetchit {
        command -v curl > /dev/null 2>&1
        if [ $? = 0 ] ; then
            curl $1 > `basename $1`
        else
            wget $1
        fi
    }

    name=${1:-"env"}
    my_fetchit https://raw.github.com/pypa/virtualenv/master/virtualenv.py && python virtualenv.py $name && rm virtualenv.py* && . $name/bin/activate
}

#alias mkenv='my_fetchit https://raw.github.com/pypa/virtualenv/master/virtualenv.py && python virtualenv.py env && rm virtualenv.py* && . env/bin/activate'
alias mkenv='my_mkenv'

function my_search {
    if [ $# = 2 ] ; then
        echo "find . -name \"$1\" -print0 | xargs -0 grep -n \"$2\"" 1>&2
        find . -name "$1" -print0 | xargs -0 grep -n "$2"
    else
        echo "find . -print0 2> /dev/null | xargs -0 grep -n \"$1\" 2> /dev/null" 1>&2
        find . -print0 2> /dev/null | xargs -0 grep -n "$1" 2> /dev/null
    fi
}

alias search='my_search'
