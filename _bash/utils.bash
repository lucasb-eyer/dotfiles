# The commented-out version would be better as it lets one specify the virtualenv dirname but
# for some reason beyond my understanding, it doesn't work (my_mkenv unknown)

#function my_mkvenv {
    function my_fetchit {
        command -v curl > /dev/null 2>&1
        if [ $? = 0 ] ; then
            curl $1 > `basename $1`
        else
            wget $1
        fi
    }

#    name = ${1:-"env"}
#    my_fetchit https://raw.github.com/pypa/virtualenv/master/virtualenv.py && python virtualenv.py $name && rm virtualenv.py* && . env/bin/activate
#}

alias mkenv='my_fetchit https://raw.github.com/pypa/virtualenv/master/virtualenv.py && python virtualenv.py env && rm virtualenv.py* && . env/bin/activate'
#alias mkenv='my_mkenv'

