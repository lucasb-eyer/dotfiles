# Shades of blue, from dark to bright
set -g c0 (set_color 005284)
set -g c1 (set_color 0075cd)
set -g c2 (set_color 009eff)
set -g c3 (set_color 6dc7ff)
set -g c4 (set_color ffffff)

function prompt_status -d "the symbols for exit status and background jobs"
    if [ $RETVAL -ne 0 ]
        set_color red
        printf "Ô.o $RETVAL "
        set_color normal
    else
        printf ":) "
    end

    # Time taken display (undocumented)
    # http://geraldkaszuba.com/tweaking-fish-shell/
    if [ "$CMD_DURATION" -gt 999 ]
        # Would be nice to use a time-related unicode symbol here, one of:
        # http://stackoverflow.com/questions/5437674/what-utf-8-symbol-is-a-good-mark-of-time
        # but oh, my current font doesn't have any :(
        printf $CMD_DURATION"ms "
    end

    # Jobs display
    if [ (jobs -l | wc -l) -gt 0 ]
        set_color cyan
        printf "⚙ "
        set_color normal
    end
end

function prompt_centralblock -d "the central part with username, host, dir and time"
    printf '['
    if [ (whoami) != "root" ]
        set_color green
    else
        set_color --background red --underline --bold black
    end
    printf '%s' (whoami)
    set_color normal
    printf '@'
    set_color blue
    printf '%s' (hostname|cut -d . -f 1)
    if [ -n "$SSH_CONNECTION" ]
        printf "$c0(ssh)"
    end
    set_color normal
    printf ':'
    printf "$c1"
    printf '%s' (prompt_pwd | sed -e "s|\(.*\)/|\1/$c2|" -e "s|/|$c0/$c1|g")
    set_color normal
    printf ' '
    printf '%s' (date +"$c1%k$c0:$c1%M$c0:$c1%S")
    set_color normal
    printf ']'
end

function prompt_git -d "Display the current git state"
  set -l gitstatus (git status --porcelain=v2 -b --show-stash --ahead-behind -unormal 2>&-)

  if test -z "$gitstatus"
    return
  end

  # Is there a stash?
  if string match -q -r '# stash (?<stash>.+)' $gitstatus
    printf " %d" $stash
  end

  set -l branchfmt "(%s)"

  # Is there any unresolved merge conflicts?
  if string match -q -r '^u .*$' $gitstatus
    set_color red
    set -l branchfmt "❗%s❗"
  # Is there any change that's staged? -> Orange
  else if string match -q -r '^(1|2) [^.].*$' $gitstatus
    set_color yellow
  # Is there any unstaged changes?
  else if string match -q -r '^(1|2) \.[^.].*' $gitstatus
    set_color red
  # Only untracked files, but no unchanged ones?
  else if string match -q -r '^\? .*$' $gitstatus
    set_color cyan
  # Green means we got a clean slate:
  else
    set_color green
  end

  # Show branch name in parens
  string match -q -r 'branch.head (?<branch>.+)' $gitstatus
  printf $branchfmt $branch

  # Get ahead/behind info into variables $a and $b:
  if string match -q -r 'branch.ab \+(?<a>\\d+) -(?<b>\\d+)' $gitstatus
    if [ $a != "0" -a $b != "0" ]
      printf "↕+$a-$b"
    else if [ $a != "0" ]
      printf "↑$a"
    else if [ $b != "0" ]
      printf "↓$b"
    end
  end

  set_color normal
end

function _two_last_names -a dir -d "print the last two components of a path"
    printf "%s/%s" (basename (dirname $dir)) (basename $dir)
end

set -x VIRTUAL_ENV_DISABLE_PROMPT yes
function prompt_virtualenv -d "display all currently active language environments."
    # Python virtualenvs
    if [ $VIRTUAL_ENV ]
        set_color magenta
        printf "(%s) " (_two_last_names $VIRTUAL_ENV | sed 's:.virtualenvs/::')
        set_color normal
    end

    # Node.js virtualenvs (created through nodeenv from pypi)
    if [ $NODE_VIRTUAL_ENV ]
        set_color magenta
        printf "(%s) " (_two_last_names $NODE_VIRTUAL_ENV)
        set_color normal
    end

    # Golang
    if [ $GOPATH ]
        set_color magenta
        printf "(%s) " (_two_last_names $GOPATH)
        set_color normal
    end
end

function _is_plugged -d "returns 0 if power is plugged in, 1 else"
    [ (cat /sys/class/power_supply/AC/online) -eq 1 ]
end

function prompt_battery -d "shows whether the laptop battery is charging or discharging and how full it is."
    # For desktops
    if not [ -e /sys/class/power_supply/AC ]
        return
    end

    set -l cap (cat /sys/class/power_supply/BAT0/capacity)

    # Don't need to show anything if (almost) full!
    if _is_plugged; and [ $cap -gt 95 ]
        return
    end

    if [ $cap -gt 50 ]
        set_color green
    else if [ $cap -gt 10 ]
        set_color yellow
    else
        set_color red
    end
    if _is_plugged
        printf "⚡↑ "
    else
        printf "⚡↓ "
    end
    set_color normal
end

function prompt_load -d "shows the cpu load if it was relatively high in the past minute."
    # For mac
    if not [ -e /proc/loadavg ]
        return
    end

    set -l load1m (command cut -d ' ' -f 1 /proc/loadavg)
    set -l load1m100 (math $load1m \* 100 / 1)
    if [ $load1m100 -gt 200 ]
        set_color red
        printf "⚡$load1m "
        set_color normal
    else if [ $load1m100 -gt 50 ]
        set_color yellow
        printf "⚡$load1m "
        set_color normal
    end
end

function fish_prompt
    set -g RETVAL $status
    prompt_status
    prompt_battery
    prompt_load
    prompt_virtualenv
    prompt_centralblock
    prompt_git

    # Line 2
    echo
    set_color blue
    printf "$c3>$c2<$c1($c0($c1($c2\"$c3> "
    set_color normal
end
