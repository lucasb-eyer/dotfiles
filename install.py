import os
from os.path import expanduser as eu, dirname, exists, join as pjoin
from time import time
from subprocess import call

# Compatibility between py2 and py3:
try: input = raw_input
except NameError: pass

# See if we've got Jupyter.
try:
    from notebook.nbextensions import install_nbextension, jupyter_data_dir
    from notebook.services.config import ConfigManager
    jupyter_nb = True
except ImportError:
    jupyter_nb = False

backup = True


def makedirs(dirs):
    # Create the folder in case it doesn't exist.
    try:
        os.makedirs(dirs)
    except OSError as e:
        if e.errno != 17:  # 17 means directory already exists
            raise


def link_with_backup(source, link_name):
    full_link_name = eu(link_name)
    print('Installing ' + source + ' -> ' + full_link_name)

    makedirs(dirname(full_link_name))

    try:
        os.symlink(source, full_link_name)
    except OSError:
        if backup:
            os.rename(full_link_name, full_link_name + '.' + str(int(time())) + '.dotfiles_backup')
        else:
            # Try to remove this thing. Non-empty directories don't work yet.
            try:
                os.remove(full_link_name)
            except OSError as e:
                os.rmdir(full_link_name)
        os.symlink(source, full_link_name)


def here(f):
    import inspect
    me = inspect.getsourcefile(here)
    return pjoin(os.path.dirname(os.path.abspath(me)), f)


def here_to_home(name, toname=None):
    link_with_backup(here('_' + name), '~/.' + (toname if toname else name))


# Install extensions.
def nb_ext(files, subdir='', prefix='_jupyter/nbextensions', enable=True):
    if not jupyter_nb:
        print("WARNING: Couldn't import Jupyter, skipped nbext.")
        return

    # Assumption: the first entry in `files` is the main file.
    print("Jupyter nbext", pjoin(subdir, files[0]))

    makedirs(pjoin(jupyter_data_dir(), 'nbextensions', subdir))

    for fname in files:
        install_nbextension(pjoin(prefix, subdir, fname),
            destination=pjoin(subdir, fname),
            user=True,
            symlink=True,
            verbose=False)
    ConfigManager().update('notebook', {
        'load_extensions': {
            pjoin(subdir, files[0][:-3]): True if enable else None,
        }
    })


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
    here_to_home('tmux.conf')
    here_to_home('inputrc')
    here_to_home('Xresources')
    here_to_home('gitconfig')
    here_to_home('gitignore')
    here_to_home('pythonrc.py')
    here_to_home('juliarc.jl')
    here_to_home('ssh_config', 'ssh/config')
    here_to_home('config/awesome')
    here_to_home('config/htop')

    # Disabled ones don't seem to work.
    nb_ext(['autoscroll.js'], enable=False)
    nb_ext(['breakpoints.js'], enable=False)
    nb_ext(['init_cell.js'])
    nb_ext(['notify.js'])
    nb_ext(['main.js', 'button.png'], 'equation_numbering')
    nb_ext(['ExecuteTime.js', 'ExecuteTime.css'], 'execute_time')
    nb_ext(['main.js', 'main.css'], 'toc')

    if os.path.isdir(eu('~/.config/fish')):
        here_to_home('config/fish/solarized.fish')
        here_to_home('config/fish/config.fish')
        here_to_home('config/fish/functions/fish_prompt.fish')
        here_to_home('config/fish/functions/grolschnext.fish')
        here_to_home('config/fish/functions/grolschpp.fish')
        here_to_home('config/fish/functions/grolschprev.fish')
    else:
        print("WARNING: skipped fish, it seems not to be installed.")

    # Reload some stuff
    if 'DISPLAY' in os.environ:
        call(['xrdb', '-nocpp', '-merge', '~/.Xresources'], shell=True)

    print("Don't forget to possibly run the following: ")
    print("- Open vim and run `:BundleInstall` or `:BundleUpdate`")
    print("- `cd _vim/bundle/YouCompleteMe/` and `python install.py --clang-completer/--all`")

if __name__ == '__main__':
    main()
