import os
from os.path import expanduser as eu, dirname
from time import time
from subprocess import call

# Compatibility between py2 and py3:
try:
    raw_input

    # We are in py2. Rename input to raw_input.
    import __builtin__
    del __builtin__.input
    __builtin__.input = lambda *args, **kwargs: raw_input(*args, **kwargs)
except NameError:
    # We are in py3 for which input already is raw_input
    pass

backup = True


def link_with_backup(source, link_name):
    full_link_name = eu(link_name)
    print('Installing ' + source + ' -> ' + full_link_name)

    # Create the folder in case it doesn't exist.
    try:
        os.makedirs(dirname(full_link_name))
    except OSError as e:
        if e.errno != 17:  # 17 means directory already exists
            raise

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


def here_to_home(name, toname=None):
    link_with_backup(here('_' + name), '~/.' + (toname if toname else name))


def main():
    # Pull in the plugins
    if call('git submodule update --init', shell=True) != 0:
        if input('Error during submodule (=plugin) init or update. Continue setup? [Y/n] ') not in ('y', 'Y', ''):
            return 1

    global backup
    backup = raw_input('Delete existing files (no backs them up)? [y/N]: ') not in ('y', 'Y')

    here_to_home('bash')
    bashrc = eu('~/.bashrc')
    bashappend = open('_bashrc.append').read()
    try:
        if bashappend not in open(bashrc).read():
            with open(bashrc, 'a') as f:
                f.write(bashappend)
    except IOError:
        # Assume non-existing file. Create one.
        # (Or no permission, this wont change anything in that case.)
        with open(bashrc, 'w+') as f:
            f.write(bashappend)

    here_to_home('vimrc')
    here_to_home('vim')
    here_to_home('inputrc')
    here_to_home('gitconfig')
    here_to_home('gitignore')
    here_to_home('gdbinit')
    here_to_home('pythonrc.py')
    here_to_home('ssh_config', 'ssh/config')
    here_to_home('config_awesome_rc.lua', 'config/awesome/rc.lua')
    here_to_home('config_awesome_themes_solarized-dark.lua', 'config/awesome/themes/solarized-dark.lua')

if __name__ == '__main__':
    main()
