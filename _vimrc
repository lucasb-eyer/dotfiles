set nocompatible

" =====================
" Vundle plugin manager
" =====================
filetype off

" Syntastic (and possibly other plugins?) don't work well with fish.
set shell=bash

" Load vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" Vundle help
""""""""""""""
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles

" System
Bundle 'kana/vim-arpeggio'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-surround'
Bundle 'Valloric/YouCompleteMe'
Bundle 'wesQ3/vim-windowswap'
" See https://cirw.in/blog/bracketed-paste
Bundle 'ConradIrwin/vim-bracketed-paste'
Bundle 'scrooloose/nerdtree'
Bundle 'Xuyuanp/nerdtree-git-plugin'
Bundle 'haya14busa/vim-poweryank'

" Languages
Bundle 'scrooloose/syntastic'
"Bundle 'nvie/vim-flake8'
Bundle 'plasticboy/vim-markdown'
Bundle 'JuliaLang/julia-vim'
Bundle 'dag/vim-fish'
Bundle 'kchmck/vim-coffee-script'

" Fun, but not useful
Bundle 'ehamberg/vim-cute-python'
Bundle 'altercation/vim-colors-solarized'

" Why is this not run automatically?
source ~/.vim/bundle/vim-colors-solarized/autoload/togglebg.vim
" Toggle background using F5

" Careful with this: http://stackoverflow.com/a/16433928
syntax enable
filetype plugin indent on

" ==========================================================
" Basic Settings
" ==========================================================

set encoding=utf-8

" Add language/tool-specific paths
set rtp+=$GOROOT/misc/vim  " Go

" On silly ubuntu, they install vim stuff into that, but
" don't have that as a default vim path...
set rtp+=/usr/share/vim/addons

""" Visual
set synmaxcol=2048         " because long lines are slow!

set t_Co=16                " See http://stackoverflow.com/a/5561823
let g:solarized_termcolors=16
set background=dark        " We are using dark background in vim
colorscheme solarized      " rock on

set cursorline             " have a line indicate the cursor location
set ruler                  " show the cursor position all the time
set showmatch              " Briefly jump to a paren once it's balanced
set nowrap                 " don't wrap text
set linebreak              " don't wrap text in the middle of a word
set listchars=tab:→·,trail:·,precedes:«,extends:»  " Could also use ▸ for tab?
set list

set number                 " Display line numbers
set numberwidth=1          " using only 1 column (and 1 space) while possible
if exists('+relativenumber')
    set relativenumber     " Display relative line numbers
endif
set title                  " show title in console title bar

""" Moving Around
set nostartofline     " Don't put the cursor in the first col on pgup/down
set virtualedit=block " Let cursor move past the last char in <C-v> mode
set scrolloff=3       " Keep 3 context lines above and below the cursor
set foldmethod=indent " allow us to fold on indents
set foldlevel=99      " don't fold by default

""" Searching
set ignorecase " Ignore case when typing all lowercase...
set smartcase  " ...but match case as soon as there's one uppercase
set gdefault   " Always add a 'g' at the end: s/foo/bar/g
set incsearch  " Incrementally search while typing a /regex
set hlsearch   " Highlight all occurences of the search term. (stop with f+n)

""" Editing
set backspace=2       " Allow backspacing over autoindent, EOL, and BOL
set autoindent        " always set autoindenting on
set nosmartindent     " don't use smart indent, it is annoying with #
set smarttab          " handle tab keypresses more intelligently tho.
set tabstop=4         " <tab> inserts 4 spaces
set shiftwidth=4      " And an indent level is 4 spaces wide.
set softtabstop=4     " <BS> over an autoindent deletes both spaces.
set expandtab         " Use spaces, not tabs, for autoindent/tab key.
set shiftround        " rounds indent to a multiple of shiftwidth

"""" Reading/Writing
set hidden           " Allow having multiple files opened w/o saving (including undo history)
set noautowrite      " Never write a file unless I request it.
set noautowriteall   " NEVER.
set noautoread       " Don't automatically re-read changed files.
set modeline         " Allow vim options to be embedded in files;
set modelines=5      " they must be within the first or last 5 lines.
set ffs=unix,dos,mac " Try recognizing dos, unix, and mac line endings.

"""" Messages, Info, Status
set wildmenu         " Menu completion in command mode on <Tab>
set wildmode=full    " <Tab> cycles between all matching choices.
                     " ...except for these
set wildignore+=*.o,*.obj,.git
set wildignore+=*.pyc,eggs/**,*.egg-info/**

set lazyredraw       " This speeds up repeated macro execution.

" TODO: Use airline for statusline?
set ls=2         " always show status line
set confirm      " Y-N-C prompt if closing with unsaved changes.
set showcmd      " Show incomplete normal mode commands as I type.
set report=0     " : commands always print changed line count.
set shortmess+=a " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler        " Show some info, even without statuslines.
set laststatus=2 " Always show statusline, even if only 1 window.

set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})
" %{fugitive#statusline()} shows the current git branch.
autocmd VimEnter * if exists('fugitive') | set statusline+=\ %{fugitive#statusline()} | endif

" ==========================================================
" Keymaps
" ==========================================================

" Better automatic brackets
inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap        {  {}<Left>
inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap        [  []<Left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"

call arpeggio#load()

" For versions before 7.3.487, arpeggio will screp up jk columns.
" On ubuntu, use https://launchpad.net/~nmi/+archive/vim-snapshots
" Or just use a saner distro, like arch...

" j and k at the same time instead of escape to leave edit mode
call arpeggio#map('i', '', 1, 'jk', '<Esc>')

" jo opens the ctrl-p file opener, fe the NERDTree.
call arpeggio#map('niv', '', 1, 'jo', ':CtrlP<cr>')
call arpeggio#map('niv', '', 1, 'fe', ':NERDTreeFocus<cr>')

" jc toggles the current line's comment state.
call arpeggio#map('nv', '', 1, 'jc', '<leader>c<space>')
call arpeggio#map('i', '', 1, 'jc', '<ESC><leader>c<space>a')
" f+n for stopping highlighting of search results.
call arpeggio#map('n', '', 1, 'fn', ':noh<CR>')

" map w+hjkl to window movement.
call arpeggio#map('nv', '', 1, 'wh', '<C-W>h')
call arpeggio#map('nv', '', 1, 'wj', '<C-W>j')
call arpeggio#map('nv', '', 1, 'wk', '<C-W>k')
call arpeggio#map('nv', '', 1, 'wl', '<C-W>l')

" map f+hjkl to home/pgup/down/end
call arpeggio#map('nv', '', 1, 'fh', '^')
call arpeggio#map('nv', '', 1, 'fj', '<C-D>')
call arpeggio#map('nv', '', 1, 'fk', '<C-U>')
call arpeggio#map('nv', '', 1, 'fl', '$')

" Makes it easy to un-highlight the previous search.
call arpeggio#map('nv', '', 1, 'fw', ':noh<cr>')

" Run pep8
"let g:pep8_map='<leader>8'

" vv splits the window vertically
map vv <C-w>v<C-w>l

" Yank over SSH
map <Leader>y <Plug>(operator-poweryank-osc52)

" For mac os x if the terminal is setup as in
" http://od-eon.com/blogs/liviu/macos-vim-controlarrow-functionality/
" Still isn't perfect.
noremap <Esc>A <C-W>k
noremap <Esc>C <C-W>l
noremap <Esc>D <C-W>h
noremap <Esc>B <C-W>j

" Next and Last
" -------------

" Motion for "next/last object". For example, "din(" would go to the next "()" pair
" and delete its contents.
" Taken from http://news.ycombinator.com/item?id=3122084

onoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>

onoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>

function! s:NextTextObject(motion, dir)
  let c = nr2char(getchar())

  if c ==# "b"
      let c = "("
  elseif c ==# "B"
      let c = "{"
  elseif c ==# "d"
      let c = "["
  endif

  exe "normal! ".a:dir.c."v".a:motion.c
endfunction

" Allow saving of files as sudo when I forgot to start vim using sudo.
" Thank you http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap w!! w !sudo tee > /dev/null %

" ===========================================================
" Other plugin-specific settings
" ===========================================================

" Not sure what's up with Py3, watching https://github.com/Valloric/YouCompleteMe/issues/1278
" YouCompleteMe doesn't work with python3, which is the default on Arch.
"let g:ycm_path_to_python_interpreter = '/usr/bin/python2'
" Doesn't the name say it all already?
let g:ycm_autoclose_preview_window_after_insertion = 1

" Sensible "current dir" behaviour for ctrlp. ("nearest .git, ...")
let g:ctrlp_working_path_mode = 'r'

"let g:flake8_show_in_file=1

" ===========================================================
" add more file types
" ===========================================================
au! Syntax opencl source ~/.vim/syntax/opencl.vim
au BufRead,BufNewFile *.cl set filetype=opencl

" ===========================================================
" FileType specific changes
" ===========================================================

" Markdown: don't fold anything initially.
let g:vim_markdown_initial_foldlevel=5

" Coffee: Fold using indentation
autocmd BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable
" Coffee: use 2-space indentation by default.
autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab

" Python: Don't let pyflakes use the quickfix window
"let g:pyflakes_use_quickfix = 0

" Tell supercomplete to be context-sensitive and show the doc
"au FileType python set omnifunc=pythoncomplete#Complete
"let g:SuperTabDefaultCompletionType = "context"
"set completeopt=menuone,longest,preview

" Python: Add the virtualenv's site-packages to vim path
if has('python')
    py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    base = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(base, 'bin/activate_this.py')
    try:
        execfile(activate_this, dict(__file__=activate_this))
    except IOError:
        # With pyvenv, `activate_this.py` doesn't exist anymore.
        # This is a mediocre replacement that works for me.
        os.environ['PATH'] = os.path.join(base, 'bin') + os.pathsep + os.environ['PATH']
        site_packages = os.path.join(base, 'lib', 'python%s' % sys.version[:3], 'site-packages')
        prev_sys_path = list(sys.path)
        import site
        site.addsitedir(site_packages)
        sys.real_prefix = sys.prefix
        sys.prefix = base
        # Move the added items to the front of the path:
        new_sys_path = []
        for item in list(sys.path):
            if item not in prev_sys_path:
                new_sys_path.append(item)
                sys.path.remove(item)
        sys.path[:0] = new_sys_path
EOF
endif

" PTX: (Nvidia's gpu assembler) tab=8 because 4 looks ugly as fuck.
au BufNewFile,BufRead *.ptx set tabstop=8

" LaTeX: Enable wordwrapping
au BufNewFile,BufRead *.tex set wrap
au BufNewFile,BufRead *.tex set nolist

" HTML: Match < to > just like ( to )
au FileType html set matchpairs+=<:>

" Fish: fold blocks
autocmd FileType fish setlocal foldmethod=expr

" ===========================================================
" Load local vimrc file if there is one
" ===========================================================
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
