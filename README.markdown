These are my linux configuration files I want to take with me wherever I go.

It all started reading http://sontek.net/turning-vim-into-a-modern-python-ide

Installing
==========

1. Clone this repo.
2. Infect your system:
    1. The easy way: run `python install.py` and answer any questions.
    2. The manual way: replace your original dotfiles by a link to the corresponding file in the repo (use a leading dot, not underscore).

Updating
========

1. Get new version of stuff: `git pull`.
2. Create new links, get new submodules etc: `python install.py`

TODO
====

1. Waiting for an IPython 3.0 theme for solarized, then add theme switching: https://www.pfenninger.org/posts/ipython-notebook-extensions-to-ease-day-to-day-work/.
