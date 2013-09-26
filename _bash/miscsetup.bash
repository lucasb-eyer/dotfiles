# For a lack of a better name, doing small stuff for various programs.

# Enable git autocompletion for bash. (Tested on OSX only, most linuxes I use do this by default.)
if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
    . /usr/local/git/contrib/completion/git-completion.bash
fi

# Add autocompletition to homebrew.
if [ `type brew >/dev/null 2>&1`$? -eq 0 ]; then
    source `brew --prefix`/Library/Contributions/brew_bash_completion.sh
fi

# Add macports to the path.
if [ -d /usr/local/macports/bin ]; then
    PATH=/usr/local/macports/bin:$PATH
fi

# Setup go if it exists in the home folder.
if [ -d ~/go ]; then
    # Differentiate between a global go install (my chakra) and a local one in home.
    if [ -d /usr/lib/go ]; then
        export GOROOT=/usr/lib/go
    else
        export GOROOT=~/go
    fi

    export GOPATH=~/go/
    export PATH=$PATH:$GOROOT/bin
fi

# Make the python interactive console a bit smarter.
if [ -f ~/.pythonrc.py ]; then
    export PYTHONSTARTUP=~/.pythonrc.py
fi

# On many computers I am required to install things locally.
if [ -d ~/inst ]; then
    export PATH=~/inst/bin:$PATH
    export LD_LIBRARY_PATH=~/inst/lib64:~/inst/lib:$LD_LIBRARY_PATH
    export PYTHONPATH=~/inst/lib/python2.7/site-packages:$PYTHONPATH
fi

# ROS (Robot Operating System)
if [ -f /opt/ros/groovy/setup.bash ]; then
    . /opt/ros/groovy/setup.bash
fi
