These are my linux configuration files I want to take with me wherever I go.

It all started reading http://sontek.net/turning-vim-into-a-modern-python-ide

Installing
==========

1. Clone this repo.
2. Infect your system:
    1. The easy way: run install.py and answer any questions.
    2. The manual way: replace your original dotfiles by a link to the corresponding file in the repo (use a leading dot, not underscore).

Adding vim pathogen plugins
===========================

> git submodule add https://github.com/tpope/vim-fugitive.git \_vim/bundle/vim-fugitive
