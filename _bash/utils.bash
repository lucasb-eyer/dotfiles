# Watch the linecount of a file in real-time.
# See: TODO: URL for details

function my_watchlines {
    if [ -z "$1" ]; then
        echo "Need to pass a filename!"
        return 1
    fi

    while true; do
        l=$(wc -l $1 | awk '{ printf "%s: %s", $2, $1 }')
        echo -n -e "\r$l"
        sleep 0
    done
}
alias watchlines='my_watchlines'

# Watch the output of an expression in real-time

function my_watchexpr {
    if [ -z "$1" ]; then
        echo "Need to pass a command to execute!"
        exit 1
    fi

    # So this is the way to store all arguments in an array, such that
    # script.sh foo "bar baw" blob
    # will be stored in a length-4 array.
    stuff=("$@")

    while true; do
        # And this is how we correctly call the previously stored command
        line=$( "${stuff[@]}" | tr -d '\r\n' )
        echo -n -e "\r$line"
        sleep 0
    done
}
alias watchexpr='my_watchexpr'

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
    version=${2:-"1.10.1"}
    my_fetchit https://pypi.python.org/packages/source/v/virtualenv/virtualenv-$version.tar.gz || exit 1
    tar xzC /tmp < virtualenv-$version.tar.gz || exit 1
    # TODO: make sys an option.
    python /tmp/virtualenv-$version/virtualenv.py --system-site-packages $name || exit 1
    rm -Rf /tmp/virtualenv-$version || exit 1
    . $name/bin/activate
}

#alias mkenv='my_fetchit https://raw.github.com/pypa/virtualenv/master/virtualenv.py && python virtualenv.py env && rm virtualenv.py* && . env/bin/activate'
alias mkenv='my_mkenv'

function my_search {
    if [ $# = 0 ] ; then
        echo "Usage:"
        echo "  search [WHERE] [HAYSTACK] NEEDLE"
        echo ""
        echo "Searches for NEEDLE (can be any expression grep understands)"
        echo "in all files matching HAYSTACK (expression find understands)"
        echo "starting at location WHERE"
        return
    fi

    WHERE=.
    if [ $# = 3 ] ; then
        WHERE=$1
        shift
    fi

    if [ $# = 2 ] ; then
        echo "find $WHERE -name \"$1\" -print0 | xargs -0 grep -n \"$2\"" 1>&2
        find $WHERE -name "$1" -print0 | xargs -0 grep -n "$2"
    else
        echo "find $WHERE -print0 2> /dev/null | xargs -0 grep -n \"$1\" 2> /dev/null" 1>&2
        find $WHERE -print0 2> /dev/null | xargs -0 grep -n "$1" 2> /dev/null
    fi
}

alias search='my_search'

alias hibernate='dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Hibernate'
