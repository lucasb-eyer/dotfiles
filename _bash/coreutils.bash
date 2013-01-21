
# This is a crude check to see whether commands like ls and grep support the --color flag.
HAS_COLORS=1 && command -v dircolors > /dev/null 2>&1 || HAS_COLORS=0

# Add colors and line numbers
[ $HAS_COLORS -ne 0 ] && alias grep='grep -n --color=auto'

# Add colors to ls
[ $HAS_COLORS -ne 0 ] && alias ls='ls --color=auto' || alias ls='ls -GF'
[ $HAS_COLORS -ne 0 ] && eval $(dircolors -b)
alias ll='ls -lh'
alias la='ls -alh'

