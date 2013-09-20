set nocompatible

" ==========================================================
" Pathogen - Allows us to organize our vim plugins
" ==========================================================
" Load pathogen with docs for all plugins
filetype off

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []

" UltiSnips needs python > 3 in vim. I just disable it until they fixed it
if !has('python3')
    call add(g:pathogen_disabled, 'ultisnips')
endif
" Python-mode wants a python enabled vim, they check themselves but print an
" annoying error if it's not present.
if !has('python')
    call add(g:pathogen_disabled, 'python-mode')
endif

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" ==========================================================
" Basic Settings
" ==========================================================

" Add language/tool-specific paths
set rtp+=$GOROOT/misc/vim  " Go

" On silly ubuntu, they install vim stuff into that, but
" don't have that as a default vim path...
set rtp+=/usr/share/vim/addons

syntax on                  " syntax highlighing
" See http://stackoverflow.com/a/5561823
set t_Co=16
let g:solarized_termcolors=16
set background=dark        " We are using dark background in vim
colorscheme solarized      " rock on

filetype on                " try to detect filetypes
filetype plugin on         " enable loading filetype plugins
filetype plugin indent on  " enable loading indent file for filetype
set number                 " Display line numbers
set numberwidth=1          " using only 1 column (and 1 space) while possible
if exists('+relativenumber')
    set relativenumber     " Display relative line numbers
endif
set title                  " show title in console title bar
set wildmenu               " Menu completion in command mode on <Tab>
set wildmode=full          " <Tab> cycles between all matching choices.

" Ignore these files when completing
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**

""" Moving Around/Editing
" (commented out ones go nuts on my console, trying them on other consoles.)
" set cursorline        " have a line indicate the cursor location
set ruler             " show the cursor position all the time
"set nostartofline     " Avoid moving cursor to BOL when jumping around
set virtualedit=block " Let cursor move past the last char in <C-v> mode
set scrolloff=3       " Keep 3 context lines above and below the cursor
set backspace=2       " Allow backspacing over autoindent, EOL, and BOL
set showmatch         " Briefly jump to a paren once it's balanced
set nowrap            " don't wrap text
set linebreak         " don't wrap text in the middle of a word
set autoindent        " always set autoindenting on
set nosmartindent     " don't use smart indent, it is annoying with #
set tabstop=4         " <tab> inserts 4 spaces
set shiftwidth=4      " And an indent level is 4 spaces wide.
set softtabstop=4     " <BS> over an autoindent deletes both spaces.
set expandtab         " Use spaces, not tabs, for autoindent/tab key.
set shiftround        " rounds indent to a multiple of shiftwidth
set foldmethod=indent " allow us to fold on indents
set foldlevel=99      " don't fold by default

"""" Reading/Writing
set noautowrite      " Never write a file unless I request it.
set noautowriteall   " NEVER.
set noautoread       " Don't automatically re-read changed files.
set modeline         " Allow vim options to be embedded in files;
set modelines=5      " they must be within the first or last 5 lines.
set ffs=unix,dos,mac " Try recognizing dos, unix, and mac line endings.

"""" Messages, Info, Status
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

" displays tabs with :set list & displays when a line runs off-screen
" Add eol:$ to display line endings
set listchars=tab:>-,trail:-,precedes:<,extends:>
set list

""" Searching and Patterns
set smarttab   " Handle tabs more intelligently
set incsearch  " Incrementally search while typing a /regex

" ==========================================================
" Automatic brackets
" ==========================================================
:inoremap ( ()<Esc>i
:inoremap { {}<Esc>i
:inoremap [ []<Esc>i
autocmd FileType python,c,cpp,html,js,css :inoremap ' ''<Esc>i
:inoremap " ""<Esc>i

" ==========================================================
" Shortcuts
" ==========================================================

call arpeggio#load()

" j and k at the same time instead of escape to leave edit mode
call arpeggio#map('i', '', 1, 'jk', '<Esc>')
" jo opens the ctrl-p file opener.
call arpeggio#map('niv', '', 1, 'jo', '<C-p>')
" jc toggles the current line's comment state.
call arpeggio#map('n', '', 1, 'jc', 'gcc')
call arpeggio#map('v', '', 1, 'jc', 'gc')
call arpeggio#map('i', '', 1, 'jc', '<ESC>gcca')

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

let g:tcommentOpModeExtra = '#'
let g:tcommentModeExtra = '#'

" shift-tab unindents
imap <S-Tab> <C-o><<

" Run pep8
let g:pep8_map='<leader>8'

" vv splits the window vertically
map vv <C-w>v<C-w>l

" For mac os x if the terminal is setup as in
" http://od-eon.com/blogs/liviu/macos-vim-controlarrow-functionality/
" Still isn't perfect.
:noremap <Esc>A <C-W>k
:noremap <Esc>C <C-W>l
:noremap <Esc>D <C-W>h
:noremap <Esc>B <C-W>j
" Use control+arrows to switch windows.
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1

" Go to the function definition (python)
map <leader>j :RopeGotoDefinition<CR>

" Rename the thing below the cursor (python)
map <leader>r :RopeRename<CR>

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

" ===========================================================
" Add more file types
" ===========================================================
au! Syntax opencl source ~/.vim/syntax/opencl.vim
au BufRead,BufNewFile *.cl set filetype=opencl

" Use GitHub-flavored Markdown by default.
au BufRead,BufNewFile *.markdown,*.md set filetype=ghmarkdown

" ===========================================================
" FileType specific changes
" ===========================================================

" Python
" Don't let pyflakes use the quickfix window
let g:pyflakes_use_quickfix = 0

" Tell supercomplete to be context-sensitive and show the doc
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

" Add the virtualenv's site-packages to vim path
if has('python')
    py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif

" PTX (nvidia's gpu assembler)
au BufNewFile,BufRead *.ptx set tabstop=8 " Because 4 looks ugly as fuck.

" Enable wordwrapping for latex files
au BufNewFile,BufRead *.tex set wrap
au BufNewFile,BufRead *.tex set nolist
" Make the up/down keys go up/down a visual line instead of an actual line.
au BufNewFile,BufRead *.tex nnoremap <Down> gj
au BufNewFile,BufRead *.tex nnoremap <Up> gk
au BufNewFile,BufRead *.tex vnoremap <Down> gj
au BufNewFile,BufRead *.tex vnoremap <Up> gk
au BufNewFile,BufRead *.tex inoremap <Down> <C-o>gj
au BufNewFile,BufRead *.tex inoremap <Up> <C-o>gk

au FileType html set matchpairs+=<:>   " Match < to > just like ( to ) in HTML

" ===========================================================
" Load local vimrc file if there is one
" ===========================================================
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

