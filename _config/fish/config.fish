# Import variables set by /etc/profile and included therein.
# Based upon https://wiki.archlinux.org/index.php/Fish#.2Fetc.2Fprofile_and_.7E.2F.profile_compatibility
#
# This is especially important for LANG from /etc/locale.conf, see discussion here:
# https://github.com/fish-shell/fish-shell/issues/3092
env -i HOME=$HOME sh -c 'printenv' | sed -e '/_/d ; /PWD/d ; /SHLVL/d ; /PATH/s/:/ /g ; s/=/ / ; s/^/set -x /' | source

# For homebrew setup on mac os:
if test -d /usr/local/bin/brew
  /usr/local/bin/brew shellenv | source
end

# Except that it doesn't seem to work and I'm tired of it, so just setting LANG here:
set -xg LANG en_US.UTF-8

abbr -a -- startx ssh-agent startx

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

set -xg EDITOR nvim
set -xg VISUAL nvim
abbr -a -- vim nvim

if type -q kitty
  set -xg TERMINAL (which kitty) -1
end

# Since I am building my own prompt, don't let virtualenv create one.
# Also, most recently, activate.fish's prompt is broken fish code.
set -xg VIRTUAL_ENV_DISABLE_PROMPT 1

# Fix java rendering in non-reparenting WMs like awesomewm
set -xg _JAVA_AWT_WM_NONREPARENTING 1

# Not quite the right place, but in Wayland, make electron-apps look good:
set -xg ELECTRON_OZONE_PLATFORM_HINT auto
set -xg GDK_BACKEND wayland

add_unique_path /usr/libexec

# Add custom stuff to the path
add_unique_path ~/.local/bin

add_unique_path ~/inst/bin
add_unique_ldpath ~/inst/lib
add_unique_lpath ~/inst/lib
add_unique_cpath ~/inst/include

# Setup go if it exists in the home folder.
if test -d ~/inst/go
    # Differentiate between a global go install (my chakra) and a local one in home.
    if test -d /usr/lib/go
        set -xg GOROOT /usr/lib/go
    else
        set -xg GOROOT ~/inst/go
    end

    set -xg GOPATH ~/inst/go
    add_unique_path ~/inst/go/bin
end

# Setup CUDA for...
# ...Arch Linux
add_unique_path /opt/cuda/bin
add_unique_ldpath /opt/cuda/lib64
add_unique_lpath /opt/cuda/lib64
add_unique_cpath /opt/cuda/include

# Setup cuDNN
add_unique_ldpath ~/inst/cudnn5/lib64
add_unique_lpath ~/inst/cudnn5/lib64
add_unique_cpath ~/inst/cudnn5/include

# Setup Julia (it can't use the fish shell.)
set -xg JULIA_SHELL /bin/bash

. $HOME/.config/fish/solarized.fish

# See https://github.com/fish-shell/fish-shell/issues/2456
set -xg LD_LIBRARY_PATH (printf '%s\n' $LD_LIBRARY_PATH | paste -sd:)
set -xg LIBRARY_PATH (printf '%s\n' $LIBRARY_PATH | paste -sd:)
set -xg CPATH (printf '%s\n' $CPATH | paste -sd:)

# Until they hopefully get into the defaults:
# https://github.com/fish-shell/fish-shell/issues/180#issuecomment-349293667
# https://stackoverflow.com/q/16660301/2366315
function fish_user_key_bindings
  bind \e\[7~ beginning-of-line
  bind \e\[8~ end-of-line
end

# Some aliases for commands I frequently use.
abbr -a -- glo "git log --oneline origin/master.."
abbr -a -- gsl 'git log -g --pretty="%C(yellow)%gd %C(blue)%ci%C(reset) %s" refs/stash'
