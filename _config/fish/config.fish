set -x EDITOR vim

# Add custom stuff to the path
set -x PATH ~/inst/bin $PATH
set -x LD_LIBRARY_PATH ~/inst/lib $LD_LIBRARY_PATH
set -x CPATH ~/inst/include/ $CPATH

# Add cuda stuff to the path
set -x PATH /usr/local/cuda-7.0/bin $PATH
set -x LD_LIBRARY_PATH /usr/local/cuda-7.0/lib64 $LD_LIBRARY_PATH

# Add cudnn stuff to the path
set -x LD_LIBRARY_PATH ~/inst/cudnn3/lib64/ $LD_LIBRARY_PATH
set -x LIBRARY_PATH ~/inst/cudnn3/lib64/ $LIBRARY_PATH
set -x CPATH ~/inst/cudnn3/include/ $CPATH


# Setup go if it exists in the home folder.
if test -d ~/go
    # Differentiate between a global go install (my chakra) and a local one in home.
    if test -d /usr/lib/go
        set -x GOROOT /usr/lib/go
    else
        set -x GOROOT ~/go
    end

    set -x GOPATH ~/go
    set -x PATH ~/go/bin $PATH
end

. $HOME/.config/fish/solarized.fish
