import os
from os.path import expanduser as eu, dirname, exists, join as pjoin
from time import time
from subprocess import run
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


def link_with_backup(source, link_name, method="symlink"):
    link_name = eu(link_name)
    source = eu(source)
    print('Installing ' + source + ' -> ' + link_name)

    _makedirs(dirname(link_name))

    def _dolink():
        if method == "symlink":
            os.symlink(source, link_name)
        elif method == "hardlink":
            os.link(source, link_name)
        elif method == "copy":
            shutil.copy(source, link_name)
        else:
            raise ValueError("Bug!!")

    try:
        _dolink()
    except OSError:
        if backup:
            os.rename(link_name, f'{link_name}.{int(time())}.dotfiles_backup')
        else:
            # Try to remove this thing. Non-empty directories don't work yet.
            try:
                os.remove(link_name)
            except OSError as e:
                os.rmdir(link_name)
        _dolink()


def here(f):
    import inspect
    me = inspect.getsourcefile(here)
    return pjoin(os.path.dirname(os.path.abspath(me)), f)


def here_to_home(name, toname=None, method="symlink"):
    link_with_backup(here('_' + name), '~/.' + (toname if toname else name), method=method)


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
    here_to_home('config/dunst/dunstrc')
    here_to_home('config/rofi/theme')
    here_to_home('config/xsettingsd/xsettingsd.conf', method="copy")  # We're changing it with sed on lightswitch, and sed copies anyways.
    here_to_home('config/kitty/kitty.conf')
    if mode != 'server':
        here_to_home(f'config/kitty/kitty.conf.{mode}', 'config/kitty/kitty.conf.local')
    here_to_home('config/kitty/themes/Solarized Dark Lucas.conf')
    here_to_home('urxvt_ext_52-osc', 'urxvt/ext/52-osc')

    if mode == 'linux':
        here_to_home('config/sway/config')
        here_to_home('config/sway/solarized-colors')
        here_to_home('config/sway/solarized-light')
        here_to_home('config/sway/solarized-dark')
        here_to_home('config/waybar/config.jsonc')
        here_to_home('config/waybar/style-light.css')
        here_to_home('config/waybar/style-dark.css')
        here_to_home('local/share/applications/chrome-wayland.desktop')

    # My util scripts
    here_to_home('local/bin/colortest')
    here_to_home('local/bin/e-cores')
    here_to_home('local/bin/imshow')
    here_to_home('local/bin/lightswitch')
    here_to_home('local/bin/togif')
    here_to_home('local/bin/unthrottle')

    # Things for any desktop/laptop, but not server.
    if mode != 'server':
        here_to_home('config/kitty/kitty.conf')
        here_to_home('config/kitty/themes/Solarized Dark Lucas.conf')
        here_to_home('config/kitty/themes/Solarized Light Lucas.conf')

    if mode == 'linux':
        here_to_home('inputrc')
        here_to_home('gitconfig')
        here_to_home('ssh_config', 'ssh/config', method="hardlink")  # Can't be symlink due to permissions.
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

    # Create the correct themeing links
    run(['_local/bin/lightswitch', 'dark'], check=True)


if __name__ == '__main__':
    if len(sys.argv) == 2:
        assert sys.argv[1] in ('server', 'linux', 'mac')
        main(sys.argv[1])
    else:
        print("Specify install mode: server, linux, mac")
