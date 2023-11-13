-- ////////////////////////////////////////////////////////////////////////////
--
-- Neovim Configuration
--
-- Prerequisites:
--  * neovim >= 0.8 (for built-in LSP and other features)
--  * LSP and associated tools like [rust-analyzer](https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary)
--
-- Install Steps:
--  * Place this file in '$HOME/.config/nvim/'
--  * Do `$ python3 -m pip install --user --upgrade pynvim` to have provider available below
--
-- References:
--  * Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
--  * [How to Configure Neovim to make it Amazing - typecraft YouTube](https://www.youtube.com/watch?v=J9yqSdvAKXY)
--  * [Neovim from Scratch - chris@machine YouTube Series](https://www.youtube.com/playlist?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ)
--  * [Migrating from Packer.nvim to Lazy.nvim](https://www.youtube.com/watch?v=aqlxqpHs-aQ)
--  * [AstroNvim](https://github.com/AstroNvim/AstroNvim)
--  * [NvChad](https://github.com/NvChad/NvChad)
--
-- ////////////////////////////////////////////////////////////////////////////

-- Manually set the Python3 host path to make startup much faster (https://neovim.io/doc/user/provider.html)
-- This makes a drastic difference in startup time: https://www.reddit.com/r/neovim/comments/r9acxp/comment/hnbuwy7/?utm_source=share&utm_medium=web2x&context=3
-- NOTE: for now, this path should be manually changed on each system
-- NOTE: startup time can be profiled with `nvim --startuptime <filename>`
-- To debug, run `checkhealth provider` to ensure `pyneovim` can be found with 
-- given python provider below (or do `<python> -c 'import neovim'` to check for 
-- errors.
vim.g.python3_host_prog = '/usr/bin/python3'

-- Setup https://github.com/folke/lazy.nvim plugin manager & lazy loader
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Detect OS being used
local current_OS = vim.loop.os_uname().sysname

-- Use system clipboard register for shared copy/paste
if current_OS == 'Darwin' then
  vim.api.nvim_set_option("clipboard", "unnamed")
else
  vim.api.nvim_set_option("clipboard", "unnamedplus")
end

-- [[ Global Vim settings ]]
-- Set <space> as the leader key (see `:help mapleader`)
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw at the very start of your init.lua (strongly advised for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- disable nvim intro
vim.opt.shortmess:append("sI")


-- Load plugins (some lazily), under ./lua/plugins/
require('lazy').setup('plugins')

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Disable mode indicator since we show mode in statusline
vim.o.showmode = false

-- Disable mouse mode
vim.o.mouse = ''

-- Enable folding by default and fold by indent (rather than syntax or marker)
vim.o.foldenable = true
vim.o.foldmethod = "indent"
-- high value here means files open unfolded by default
vim.o.foldlevel = 99

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time for CursorHold and timeout for events
vim.o.updatetime = 250
vim.o.timeoutlen = 250
vim.wo.signcolumn = 'yes'

-- Highlight current line horizontally
vim.o.cursorline = true

-- Show tab characters in files
vim.wo.list = true
vim.wo.listchars = "tab:» ,extends:>,precedes:<,nbsp:+"

-- Use global status line (vs per window status line)
vim.o.laststatus = 3

-- Have a fixed column for the diagnostics to appear in (removes jitter of warnings/errors)
-- setting from static 'yes' -> 'number' merges number and diag's to one column
--   like -> https://www.reddit.com/r/neovim/comments/neaeej/only_just_discovered_set_signcolumnnumber_i_like/
--vim.o.signcolumn = "number"
vim.o.signcolumn = "yes:1"

-- Set spell checking on by default, as most language supports will have this check 
-- for spelling errors in code comments: https://unix.stackexchange.com/a/31162
vim.o.spell = true
vim.o.spelllang = "en_us"

vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- `jk` to escape from insert mode
-- NOTE: to reset this mapping (for instance if trying to paste a session token 
-- which just so happens to have a '..jk..` sequence in the string), do:
--  :inoremap jk jk
vim.keymap.set('i', 'jk', '<Esc>')
-- Since 'chage inner word' allows you to not have the cursor at the beginning
-- of the word, map ciw -> cw by default.
vim.keymap.set('n', 'cw', 'ciw')

-- Buffer keymaps
vim.keymap.set('n', '<leader>n', ':enew<CR>', { desc = 'Open new empty buffer', silent = true })
vim.keymap.set('n', '<leader>fl', ':bnext<CR>', { desc = 'Move to next open buffer', silent = true })
vim.keymap.set('n', '<leader>fh', ':bprevious<CR>', { desc = 'Move to previous open buffer', silent = true })
vim.keymap.set('n', '<leader>fq', ':bp <BAR> bd #<CR>', { desc = 'Close current buffer and move to previous one (similar to closing tab)', silent = true })
vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { desc = 'Vertical split (into another window) current file', silent = true })
vim.keymap.set('n', '<leader>s', ':split<CR>', { desc = 'Horizontal split (into another window) current file', silent = true })
vim.keymap.set('n', '<leader>h', '<C-w><Left>', { desc = 'Move to window left', silent = true })
vim.keymap.set('n', '<leader>l', '<C-w><Right>', { desc = 'Move to window right', silent = true })
vim.keymap.set('n', '<leader>k', '<C-w><Up>', { desc = 'Move to window up', silent = true })
vim.keymap.set('n', '<leader>j', '<C-w><Down>', { desc = 'Move to window down', silent = true })
vim.keymap.set('n', '<leader>q', ':hide<CR>', { desc = 'Close current window', silent = true })
vim.keymap.set('n', '<leader>K', ':res +10<CR>', { desc = 'Enlarge current window by 10 lines', silent = true })
vim.keymap.set('n', '<leader>J', ':res -10<CR>', { desc = 'Shrink current window by 10 lines', silent = true })
vim.keymap.set('n', '<leader>L', ':vertical resize +10<CR>', { desc = 'Enlarge current window width by 10 lines', silent = true })
vim.keymap.set('n', '<leader>H', ':vertical resize -10<CR>', { desc = 'Shrink current window widht by 10 lines', silent = true })
-- Similar, terminal-mode keymaps
vim.keymap.set('n', '<leader><leader>', ':terminal<CR>', { desc = 'Open terminal emulator buffer', silent = true })
vim.keymap.set('t', '<leader>fl', '<C-\\><C-N>:bnext<CR>', { desc = 'Move to next open buffer', silent = true })
vim.keymap.set('t', '<leader>fh', '<C-\\><C-N>:bprevious<CR>', { desc = 'Move to previous open buffer', silent = true })
vim.keymap.set('t', '<leader>fq', '<C-\\><C-N>:bd!<CR>', { desc = 'Close current terminal emulator buffer and move to previous buffer (similar to closing tab)', silent = true })
vim.keymap.set('t', '<leader>h', '<C-\\><C-N><C-w><Left>', { desc = 'Move to window left', silent = true })
vim.keymap.set('t', '<leader>l', '<C-\\><C-N><C-w><Right>', { desc = 'Move to window right', silent = true })
vim.keymap.set('t', '<leader>k', '<C-\\><C-N><C-w><Up>', { desc = 'Move to window up', silent = true })
vim.keymap.set('t', '<leader>j', '<C-\\><C-N><C-w><Down>', { desc = 'Move to window down', silent = true })
vim.keymap.set('t', '<leader>q', '<C-\\><C-N>:hide<CR>', { desc = 'Close current window', silent = true })
vim.keymap.set('t', '<leader>K', '<C-\\><C-N>:res +10<CR>', { desc = 'Enlarge current window by 10 lines', silent = true })
vim.keymap.set('t', '<leader>J', '<C-\\><C-N>:res -10<CR>', { desc = 'Shrink current window by 10 lines', silent = true })
vim.keymap.set('t', '<leader>L', '<C-\\><C-N>:vertical resize +10<CR>', { desc = 'Enlarge current window width by 10 lines', silent = true })
vim.keymap.set('t', '<leader>H', '<C-\\><C-N>:vertical resize -10<CR>', { desc = 'Shrink current window widht by 10 lines', silent = true })
-- Visual key mappings
vim.keymap.set({'n', 'v'}, '~', ':s/\\v<(.)(\\w*)/\\u\\1\\L\\2/g<CR>', { desc = 'Turn a line into title caps (first letter of each word capitalized)', silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })



-- Highlight on yank, see `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Automatically save the current session when vim is closed
-- NOTE: define what is in a session with `sessionoptions`, see `:help sessionoptions`
-- NOTE: this is a lightweight method of some other plugins like https://github.com/mhinz/vim-startify
vim.api.nvim_create_autocmd(
  "VimLeave",
  { command = "mksession! ~/.config/nvim/vim_session.vim"}
)
-- Restore saved session with <F9>
vim.keymap.set('n', '<F9>', ':source ~/.config/nvim/vim_session.vim<CR>', { desc = 'Restore saved session', silent = true })
-- Manually save current session with <F10>
vim.keymap.set('n', '<F10>', ':mksession! ~/.config/nvim/vim_session.vim<CR>:echo "Session saved!"<CR>', { desc = 'Manually save current session', silent = true })

-- Go to Last Location of Buffer on open
vim.api.nvim_create_autocmd(
  "BufReadPost",
  { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

-- Set .xdc filetype to Tcl
vim.api.nvim_create_autocmd(
  { "BufNewFile", "BufFilePre", "BufRead" },
  { pattern = "*.xdc", command = "set filetype=tcl" }
)

-- Highlight trailing whitespace as match to ExtraWhitespace
vim.api.nvim_create_autocmd(
  { "BufWinEnter", "InsertLeave" },
  { pattern = "*.{c,cpp,h,hpp,py,rs,sh,sv,v,vhd}", command = "match ExtraWhitespace /\\s\\+$/" }
)
-- Don't highlight while in insert mode and clear when leaving for performance issues
vim.api.nvim_create_autocmd(
  { "InsertEnter", "BufWinLeave" },
  { pattern = "*.{c,cpp,h,hpp,py,rs,sh,sv,v,vhd}", command = "call clearmatches()" }
)
-- Automatically remove all trailing whitespace when buffer is saved
vim.api.nvim_create_autocmd(
  "BufWritePre",
  { pattern = "*.{c,cpp,h,hpp,py,rs,sh,sv,v,vhd}", command = "%s/\\s\\+$//e" }
)

-- Commands to run when terminal opens:
--  * Go directly to insert mode when entering terminal emulator
--  * Turn off line numbering
--  * Turn off spellcheck in terminal emulator
--  * Turn off signcolumn
--  * Turn off ExtraWhitespace highlighting in terminal emulator
vim.api.nvim_create_autocmd(
  "TermOpen",
  { command = "startinsert | setlocal nonumber | setlocal nospell | setlocal scl=no | call clearmatches()" }
)

-- Set cursorline only when not in insert mode
local hcursor_group = vim.api.nvim_create_augroup('HorizCursor', { clear = true })
vim.api.nvim_create_autocmd(
  { "InsertLeave", "WinEnter" },
  { pattern = "*", command = "set cursorline", group = hcursor_group }
)
vim.api.nvim_create_autocmd(
  { "InsertEnter", "WinLeave" },
  { pattern = "*", command = "set nocursorline", group = hcursor_group }
)

-- Disable search highlighting when moving after non-search key
--  From: https://www.reddit.com/r/neovim/comments/zc720y/comment/iyvcdf0/?utm_source=share&utm_medium=web2x&context=3
vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
  end
end, vim.api.nvim_create_namespace "auto_hlsearch")


vim.api.nvim_exec(
  [[
  func! SpacesToTabs()
    setlocal noexpandtab " don't expand tabs to spaces
    %retab!              " Retabulate the whole file
    normal mzgg=G`z      " Re-indent file and keep cursor position
  endfu
  com! SpacesToTabs call SpacesToTabs()
]], true)

vim.api.nvim_exec(
  [[
  func! TabsToSpaces()
    setlocal expandtab " expand tabs to spaces
    %retab!            " Retabulate the whole file
    normal mzgg=G`z    " Re-indent file and keep cursor position
  endfu
  com! TabsToSpaces call TabsToSpaces()
]], true)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
