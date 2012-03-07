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
for f in ~/.bash/*.bash
do
    . "$f"
done

"""

def main():
    global backup
    backup = raw_input('Delete existing files? [y/n]: ') != 'y'

    here_to_home('bash')
    bashrc = eu('~/.bashrc')
    try:
        if bashloader not in open(bashrc).read():
            with open(bashrc, 'a') as f:
                f.write(bashloader)
    except IOError:
        # Assume non-existing file. Create one.
        # (Or no permission, this wont change anything in that case.)
        with open(bashrc, 'w+') as f:
            f.write(bashloader)

    here_to_home('vimrc')
    here_to_home('vim')
    here_to_home('inputrc')

if __name__ == '__main__':
    main()

