"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc Config File for Vim Text Editor
"
" Author: John Gentile
" Date: 1-11-2017
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Interface & Editing Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256        " turn on 256 colors
set number          " turn on line numbering
set laststatus=2    " always shows status line (usefule for Airline plugin)
set noshowmode      " turn off default mode indicator since we have plugin
" NOTE: Powerline fonts might be weird in some systems, look at FAQ link below
" https://github.com/vim-airline/vim-airline/wiki/FAQ
" let g:airline_powerline_fonts = 1 " turn on powerline fonts
" if !exists('g:airline_symbols')
"   let g:airline_symbols = {}
" endif
" let g:airline_symbols.space = "\ua0"
syntax enable       " turn on syntax highlighting
set cindent         " use C-style indenting
set shiftwidth=2    " indent 2 spaces (instead of 8) for one tab
set expandtab       " keep Vim from converting 8 spaces into tabs
" set cursorline      " highlight current line horizontally
set wildmenu        " visual autocomplete for command menu
set showmatch       " highlight [{()}] matching
set visualbell      " turn on visual flashes instead of audible bell
colorscheme gmonokai 
" automatically associate *.md files with Markdown syntax
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching & Movement
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch       " search as characters are entered
set hlsearch        " highlight matches
set ignorecase      " Ignore case when searching
" highlight last inserted text
nnoremap gV '[v']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key & Leader Shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=","   " leader is comma
" jk to escape
inoremap jk <esc>
" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" toggle gundo
nnoremap <leader>u :GundoToggle<CR>
" save current windows/session
nnoremap <leader>s :mksession<CR>
" open ag.vim (the_silver_searcher)
nnoremap <leader>a :Ag 
" open CtrlP fuzzy search tool
nnoremap <leader>p :CtrlP<CR>
" Fast saving
nnoremap <leader>w :w!<CR>
" turn off search highlighting
nnoremap <leader><space> :nohlsearch<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldenable      " enable folding
" Space toggles opening/closing one layer of folds
nnoremap <space> za
" Leader_key+Space toggles opening/closing an entire layer of folds
nnoremap <leader><space> zA
set foldmethod=indent " fold based on indent level

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Backups (move '~' appended files to temp dir)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp//*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Distraction-Free Word Processor
func! WordProcessorMode()
  setlocal smartindent
  setlocal spell spelllang=en_us
  setlocal noexpandtab
endfu
com! WP call WordProcessorMode()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM-Plug Commands
"
" Go to https://github.com/junegunn/vim-plug for install instructions
" Plugin specific documentation can be found at https://github.com/_PLUG_
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Visual 'Undo' Tree
Plug 'sjl/gundo.vim'

" Code search plugin for the_silver_searcher
Plug 'rking/ag.vim'

" Full path fuzzy file, buffer, mru, tag... finder
Plug 'kien/ctrlp.vim'

" Smart code-completion engine
" NOTE: there are some special installation considerations, see GitHub page for
" more information
Plug 'Valloric/YouCompleteMe'

" Good looking tagline for bottom of Vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Plugin for snippets
Plug 'SirVer/ultisnips'

" Sublime-text like multiple-cursor use
Plug 'terryma/vim-multiple-cursors'

" Git wrapper
Plug 'tpope/vim-fugitive'

" Git gutter for showing diffs and other features
Plug 'airblade/vim-gitgutter'

" CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

call plug#end()
