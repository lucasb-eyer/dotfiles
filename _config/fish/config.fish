set -x PATH ~/inst/bin $PATH
set -x EDITOR vim

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
