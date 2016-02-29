function add_unique_path -d 'Add an element to $PATH if it exists and is not already in there.'
    if begin; test -d $argv[1]; and not contains $argv[1] $PATH; end
        set -xg PATH $argv[1] $PATH
    end
end

function add_unique_ldpath -d 'Add an element to $LD_LIBRARY_PATH if it exists and is not already in there.'
    if begin; test -d $argv[1]; and not contains $argv[1] $LD_LIBRARY_PATH; end
        set -xg LD_LIBRARY_PATH $argv[1] $LD_LIBRARY_PATH
    end
end

function add_unique_lpath -d 'Add an element to $LIBRARY_PATH if it exists and is not already in there.'
    if begin; test -d $argv[1]; and not contains $argv[1] $LIBRARY_PATH; end
        set -xg LIBRARY_PATH $argv[1] $LIBRARY_PATH
    end
end

function add_unique_cpath -d 'Add an element to $CPATH if it exists and is not already in there.'
    if begin; test -d $argv[1]; and not contains $argv[1] $CPATH; end
        set -xg CPATH $argv[1] $CPATH
    end
end

#set -x EDITOR vim

# Add custom stuff to the path
add_unique_path ~/inst/bin
add_unique_ldpath ~/inst/lib
add_unique_lpath ~/inst/lib
add_unique_cpath ~/inst/include

# Setup go if it exists in the home folder.
if test -d ~/go
    # Differentiate between a global go install (my chakra) and a local one in home.
    if test -d /usr/lib/go
        set -xg GOROOT /usr/lib/go
    else
        set -xg GOROOT ~/go
    end

    set -xg GOPATH ~/go
    add_unique_path ~/go/bin
end

# Setup CUDA for...
# ...Arch Linux
add_unique_path /opt/cuda/bin
add_unique_ldpath /opt/cuda/lib64
add_unique_lpath /opt/cuda/lib64
add_unique_cpath /opt/cuda/include
# ...Ubuntu 14.04
add_unique_path /usr/local/cuda/bin
add_unique_ldpath /usr/local/cuda/lib64
add_unique_lpath /usr/local/cuda/lib64
add_unique_cpath /usr/local/cuda/include
# ...Ubuntu 14.04 again?
add_unique_path /usr/local/cuda-7.0/bin
add_unique_ldpath /usr/local/cuda-7.0/lib64
add_unique_lpath /usr/local/cuda-7.0/lib64
add_unique_cpath /usr/local/cuda-7.0/include

# Setup cuDNN
add_unique_ldpath ~/inst/cudnn3/lib64
add_unique_lpath ~/inst/cudnn3/lib64
add_unique_cpath ~/inst/cudnn3/include

# Setup Julia (it can't use the fish shell.)
set -xg JULIA_SHELL /bin/bash

. $HOME/.config/fish/solarized.fish

# See https://github.com/fish-shell/fish-shell/issues/2456
set -xg LD_LIBRARY_PATH (printf '%s\n' $LD_LIBRARY_PATH | paste -sd:)
set -xg LIBRARY_PATH (printf '%s\n' $LIBRARY_PATH | paste -sd:)
set -xg CPATH (printf '%s\n' $CPATH | paste -sd:)
