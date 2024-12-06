import os
from os.path import expanduser as eu, dirname, exists, join as pjoin
from time import time
from subprocess import call
import shutil

backup = True


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


def main():
    # Pull in the plugins
    if call(['git', 'submodule', 'update', '--init']) != 0:
        if input('Error during submodule (=plugin) init or update. Continue setup? [Y/n] ') not in ('y', 'Y', ''):
            return 1

    # Pull in Vundle (for vim, should make it a submodule at some point?)
    if not exists(here('_vim/bundle/vundle')):
        if call(['git', 'clone', 'https://github.com/gmarik/vundle.git', here('_vim/bundle/vundle')]) != 0:
            if input('Error getting Vundle. Continue setup? [y/N]') not in ('y', 'Y'):
                return 1

    global backup
    backup = input('Delete existing files (no backs them up)? [y/N]: ') not in ('y', 'Y')

    here_to_home('vim')
    here_to_home('vimrc')
    here_to_home('tmux.conf')
    here_to_home('inputrc')
    here_to_home('Xresources')
    here_to_home('Xresources.light')
    here_to_home('xinitrc')
    here_to_home('gitconfig')
    here_to_home('gitignore')
    here_to_home('pythonrc.py')
    here_to_home('ssh_config', 'ssh/config', symbolic=False)  # Can't be symlink due to permissions.
    here_to_home('config/i3/config')
    here_to_home('config/i3status/config')
    here_to_home('config/kitty/kitty.conf')
    here_to_home('config/kitty/themes/Solarized Dark Lucas.conf')

    if shutil.which('fish'):
        here_to_home('config/fish/solarized.fish')
        here_to_home('config/fish/config.fish')
        here_to_home('config/fish/functions/fish_prompt.fish')
    else:
        print("WARNING: skipped fish, it seems not to be installed.")

    # Reload some stuff
    # TODO: update - currently hangs?
    # if 'DISPLAY' in os.environ:
    #     call(['xrdb', '-nocpp', '-merge', '~/.Xresources'], shell=True)

    print("Don't forget to possibly run the following: ")
    print("- Open vim and run `:BundleInstall` or `:BundleUpdate`")
    print("- `cd _vim/bundle/YouCompleteMe/` and `python install.py --clang-completer/--all`")

if __name__ == '__main__':
    main()
