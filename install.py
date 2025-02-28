import os
from os.path import expanduser as eu, dirname, exists, join as pjoin
from time import time
from subprocess import call
import shutil
import sys

backup = False


def _makedirs(dirs):
    # Create the folder in case it doesn't exist.
    try:
        os.makedirs(dirs)
    except OSError as e:
        if e.errno != 17:  # 17 means directory already exists
            raise


def link_with_backup(source, link_name, symbolic=True):
    link_name = eu(link_name)
    source = eu(source)
    print('Installing ' + source + ' -> ' + link_name)

    _makedirs(dirname(link_name))

    try:
        if symbolic:
            os.symlink(source, link_name)
        else:
            os.link(source, link_name)
    except OSError:
        if backup:
            os.rename(link_name, f'{link_name}.{int(time())}.dotfiles_backup')
        else:
            # Try to remove this thing. Non-empty directories don't work yet.
            try:
                os.remove(link_name)
            except OSError as e:
                os.rmdir(link_name)
        os.symlink(source, link_name)


def here(f):
    import inspect
    me = inspect.getsourcefile(here)
    return pjoin(os.path.dirname(os.path.abspath(me)), f)


def here_to_home(name, toname=None, symbolic=True):
    link_with_backup(here('_' + name), '~/.' + (toname if toname else name), symbolic=symbolic)


def main(mode):
    if mode != 'server':
        global backup
        backup = input('Delete existing files (no backs them up)? [y/N]: ') not in ('y', 'Y')

    # Things I install on all machines (lin/mac laptops, servers)
    here_to_home('tmux.conf')
    here_to_home('gitignore')
    here_to_home('pythonrc.py')
    here_to_home('config/nvim/init.lua')
    here_to_home('config/nvim/color')
    here_to_home('config/fish/solarized.fish')
    here_to_home('config/fish/config.fish')
    here_to_home('config/fish/functions/fish_prompt.fish')

    # My util scripts
    here_to_home('local/bin/imshow')
    here_to_home('local/bin/lightswitch')
    here_to_home('local/bin/togif')

    # Things for any desktop/laptop, but not server.
    if mode != 'server':
        here_to_home('config/kitty/kitty.conf')
        here_to_home('config/kitty/themes/Solarized Dark Lucas.conf')

    if mode == 'linux':
        here_to_home('inputrc')
        here_to_home('Xresources')
        here_to_home('Xresources.solarized-dark')
        here_to_home('Xresources.solarized-light')
        link_with_backup('.Xresources.solarized-dark', '~/.Xresources.colors')
        here_to_home('xinitrc')
        here_to_home('gitconfig')
        here_to_home('ssh_config', 'ssh/config', symbolic=False)  # Can't be symlink due to permissions.
        here_to_home('config/i3/config')
        here_to_home('config/i3status/config')
        here_to_home('config/xsettingsd/xsettingsd.conf')
        here_to_home('local/bin/e-cores')
        here_to_home('local/bin/reset-inputs')
    elif mode == 'mac':
        here_to_home('config/aerospace/aerospace.toml')
        here_to_home('local/bin/aerospace_scratch')

    if not shutil.which('fish'):
        print("WARNING: no fish installed?")

    try:
        import lb_secret
        lb_secret.install(mode, here_to_home)
    except ImportError:
        pass

if __name__ == '__main__':
    if len(sys.argv) == 2:
        assert sys.argv[1] in ('server', 'linux', 'mac')
    else:
        print("Specify install mode: server, linux, mac")
    main(sys.argv[1])
