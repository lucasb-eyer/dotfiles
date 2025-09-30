-------------------------------------------------------------------------------
-- SETTINGS SETTINGS SETTINGS SETTINGS SETTINGS SETTINGS SETTINGS SETTINGS S --

vim.opt.cursorline = true  -- Have a line indicate the cursor location
vim.opt.showmatch = true   -- Briefly jump to a paren once it's balanced
vim.opt.wrap = false       -- Don't wrap text
vim.opt.linebreak = true   -- don't wrap text in the middle of a word
vim.opt.list = true
vim.opt.listchars:append {
  -- multispace = '▏ ',
  tab = '→·',
  trail = '·',
  nbsp = '·',
  precedes = '«',
  extends = '»',
}
vim.opt.title = true  -- Set console title.

vim.opt.relativenumber = true  -- Show line distance from current in margin
vim.opt.number = true          -- But for current one, show line number.

-- Editing/tabbing
vim.opt.tabstop = 2           -- <tab> inserts 4 spaces
vim.opt.shiftwidth = 2        -- And an indent level is 4 spaces wide.
vim.opt.softtabstop = 2       -- <BS> over an autoindent deletes both spaces.
vim.opt.expandtab = true      -- Use spaces, not tabs, for autoindent/tab key.
vim.opt.shiftround = true     -- rounds indent to a multiple of shiftwidth
vim.opt.virtualedit = 'block' -- In C-v mode, allow moving past EOL.

-- Browsing/navigating
vim.opt.scrolloff = 3          -- Keep 3 context lines above and below the cursor
vim.opt.foldmethod = 'indent'  -- allow us to fold on indents
vim.opt.foldlevel = 99         -- but don't fold anything right away!
vim.opt.autoread = false       -- Don't automatically re-read changed files, ask!

vim.opt.gdefault = true  -- /g on by default, writing /g turns it off.

-- vv splits the window vertically
vim.keymap.set('', 'vv', '<C-w>v<C-w>l')

-- " Better automatic brackets
-- inoremap        (  ()<Left>
-- inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
-- inoremap        {  {}<Left>
-- inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
-- inoremap        [  []<Left>
-- inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"

-- " Yank over SSH
-- map <Leader>y <Plug>(operator-poweryank-osc52)

-- " For mac os x if the terminal is setup as in
-- " http://od-eon.com/blogs/liviu/macos-vim-controlarrow-functionality/
-- " Still isn't perfect.
-- noremap <Esc>A <C-W>k
-- noremap <Esc>C <C-W>l
-- noremap <Esc>D <C-W>h
-- noremap <Esc>B <C-W>j

-------------------------------------------------------------------------------
-- PLUGINS PLUGINS PLUGINS PLUGINS PLUGINS PLUGINS PLUGINS PLUGINS PLUGINS P --

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup {
  spec = {
    -- ARPEGGIO!! Can't live without!!
    ----------------------------------
    { 'kana/vim-arpeggio',
      lazy = false,
      config = function(_, opts)
        vim.fn['arpeggio#load']()

        -- j and k at the same time instead of escape to leave edit mode
        vim.fn['arpeggio#map']('i', '', 1, 'jk', '<Esc>')

        -- Navigation: w+hjkl to window movement.
        vim.fn['arpeggio#map']('nv', '', 1, 'wh', '<C-W>h')
        vim.fn['arpeggio#map']('nv', '', 1, 'wj', '<C-W>j')
        vim.fn['arpeggio#map']('nv', '', 1, 'wk', '<C-W>k')
        vim.fn['arpeggio#map']('nv', '', 1, 'wl', '<C-W>l')

        -- Navigation: f+hjkl to home/pgup/down/end
        vim.fn['arpeggio#map']('nv', '', 1, 'fh', '^')
        vim.fn['arpeggio#map']('nv', '', 1, 'fj', '<C-D>')
        vim.fn['arpeggio#map']('nv', '', 1, 'fk', '<C-U>')
        vim.fn['arpeggio#map']('nv', '', 1, 'fl', '$')

        -- " jo opens the ctrl-p file opener, fe the NERDTree.
        -- call arpeggio#map('niv', '', 1, 'jo', ':CtrlP<cr>')

        -- " jc toggles the current line's comment state.
        vim.fn['arpeggio#map']('n', '', 1, 'jc', 'gcc')
        vim.fn['arpeggio#map']('v', '', 1, 'jc', 'gc')
        -- vim.fn['arpeggio#map']('i', '', 1, 'jc', '<ESC>gcca')

        -- " f+n for stopping highlighting of search results.
        vim.fn['arpeggio#map']('n', '', 1, 'fn', ':noh<CR>')
      end
    },

    -- Colorschemes
    ---------------

    -- add your plugins here
    -- {
    --   'maxmx03/solarized.nvim',
    --   lazy = false,
    --   priority = 1000,
    --   ---@type solarized.config
    --   opts = {},
    --   config = function(_, opts)
    --     vim.o.termguicolors = true
    --     vim.o.background = 'dark'  -- light or dark
    --     require('solarized').setup(opts)
    --     vim.cmd.colorscheme 'solarized'
    --   end,
    -- },
    -- Current preferred (nicer python, but can I make colors violet?)
    -- Also, is a complete port of solarized8, most direct port of OG.
    {
      'ishan9299/nvim-solarized-lua',
      lazy = false,
      priority = 1000,
      ---@type solarized.config
      opts = {},
      config = function(_, opts)
        vim.g.solarized_statusline = 'flat'
        vim.o.termguicolors = true

        -- Quite a bit of logic to watch the color-file and auto-switch when it changes:
        -- See https://felix-kling.de/blog/2021/linux-toggle-dark-mode.html

        local colorFile = vim.fn.stdpath("config") .. "/color"
        local function reload()
          vim.cmd("source ".. colorFile)
        end
        local w = vim.loop.new_fs_event()
        local on_change
        local function watch_file(fname)
          w:start(fname, {}, vim.schedule_wrap(on_change))
        end
        on_change = function()
          reload()
          w:stop()  -- Debounce: stop/start.
          watch_file(colorFile)
        end
        watch_file(colorFile)
        reload()

        vim.cmd.colorscheme 'solarized'

        vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { link = "DiffAdd", bold = true })
        vim.api.nvim_set_hl(0, "MiniDiffSignChange", { link = "DiffChange", bold = true })
        vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { link = "DiffDelete", bold = true })
        local curr = vim.api.nvim_get_hl_by_name("DiffChange", true)
        curr.bold = true
        vim.api.nvim_set_hl(0, "MiniDiffSignChange", curr)
        local curr = vim.api.nvim_get_hl_by_name("DiffDelete", true)
        curr.bold = true
        vim.api.nvim_set_hl(0, "MiniDiffSignDelete", curr)
        local curr = vim.api.nvim_get_hl_by_name("DiffAdd", true)
        curr.bold = true
        vim.api.nvim_set_hl(0, "MiniDiffSignAdd", curr)

      end,
    },
    -- Almost! But import is white+bold, why!? Pretty numbers in violet though.
    -- {
    --   "shaunsingh/solarized.nvim",
    --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
    --   priority = 1000, -- make sure to load this before all the other start plugins
    --   config = function()
    --     -- vim.g.solarized_borders = true
    --     vim.cmd [[ colorscheme solarized ]]
    --   end
    -- },

    -- Languages
    ------------
    -- treesitter for syntax highlighting
    -- * auto-installs the parser for python
    {
      "nvim-treesitter/nvim-treesitter",
      -- automatically update the parsers with every new release of treesitter
      build = ":TSUpdate",

      opts = {
        highlight = { enable = true }, -- enable treesitter syntax highlighting
        indent = { enable = true }, -- better indentation behavior
        ensure_installed = {
          "fish",
          "markdown",
          "markdown_inline",
          "python",
        },
      },
      config = function(_, opts)
        require("nvim-treesitter.install").prefer_git = true
        require("nvim-treesitter.configs").setup(opts)
      end,
    },

    -- Many cool plugins from mini!
    -------------------------------

    -- More "a"round/"i"n targets, like "n"ext and "p"rev.
    { 'echasnovski/mini.ai', version = false, config = true },
    { 'echasnovski/mini.animate', version = false, opts = { cursor = { enable = false } } },
    { 'echasnovski/mini.cursorword', version = false, opts = { delay = 1000 } },
    { 'echasnovski/mini.diff', version = false, config = true, opts = { view = { style = "sign", signs = { add = '+', change = '▒', delete = '-' }, } } },
    { 'echasnovski/mini.surround', version = false, config = true },

    { 'vim-scripts/CursorLineCurrentWindow' },

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "solarized" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
}

-------------------------------------------------------------------------------
-- FILETYPES FILETYPES FILETYPES FILETYPES FILETYPES FILETYPES FILETYPES FIL --

-- The filetype-autocmd runs a function when opening a file with the filetype
-- "python". This method allows you to make filetype-specific configurations. In
-- there, you have to use `opt_local` instead of `opt` to limit the changes to
-- just that buffer. (As an alternative to using an autocmd, you can also put those
-- configurations into a file `/after/ftplugin/{filetype}.lua` in your
-- nvim-directory.)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python", -- filetype for which to run the autocmd
  callback = function()
    -- use pep8 standards
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    
    -- folds based on indentation https://neovim.io/doc/user/fold.html#fold-indent
    -- if you are a heavy user of folds, consider using `nvim-ufo`
    vim.opt_local.foldmethod = "indent"
  end,
})


