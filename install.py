import os
from os.path import expanduser as eu
from time import time

backup = True

def link_with_backup(source, link_name):
    full_link_name = eu(link_name)
    print('Installing ' + source + ' -> ' + full_link_name)
    try:
        os.symlink(source, full_link_name)
    except OSError:
        if backup:
            os.rename(full_link_name, full_link_name + '.' + str(int(time())) + '.dotfiles_backup')
        else:
            os.remove(full_link_name)
        os.symlink(source, full_link_name)

def here(f):
    import inspect
    me = inspect.getsourcefile(here)
    return os.path.join(os.path.dirname(os.path.abspath(me)), f)

def here_to_home(name):
    link_with_backup(here('_' + name), '~/.' + name)

bashloader = r"""

# Load and execute all scripts in that folder:
if [ -d "~/.bash" ]; then
    for f in "~/.bash/*.bash"
    do
        . "$f"
    done
fi

"""

def main():
    global backup
    backup = raw_input('Delete existing files? [y/n]: ') != 'y'

    here_to_home('bash')
    if bashloader not in open(eu('~/.bashrc')).read():
        with open(eu('~/.bashrc'), 'a') as f:
            f.write(bashloader)

    here_to_home('vimrc')
    here_to_home('vim')

if __name__ == '__main__':
    main()

