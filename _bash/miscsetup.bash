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
    export GOROOT=~/go
    export GOPATH=~/go/
    export PATH=$PATH:$GOROOT/bin
fi

# Make the python interactive console a bit smarter.
if [ -f ~/.pythonrc.py ]; then
    export PYTHONSTARTUP=~/.pythonrc.py
fi

# ROS (Robot Operating System)
if [ -f /opt/ros/groovy/setup.bash ]; then
    . /opt/ros/groovy/setup.bash
fi

