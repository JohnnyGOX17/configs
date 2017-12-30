" File              : .vimrc
" Author            : John Gentile <johncgentile17@gmail.com>
" Date              : 06.12.2017
" Last Modified Date: 29.12.2017
" Last Modified By  : John Gentile <johncgentile17@gmail.com>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Interface & Editing Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256        " turn on 256 colors
set number          " turn on line numbering
set hidden          " hide buffers instead of closing them
syntax enable       " turn on syntax highlighting
set cindent         " use C-style indenting
set shiftwidth=2    " indent 2 spaces (instead of 8) for one tab
set expandtab       " keep Vim from converting 8 spaces into tabs
set backspace=2     " make backspace work like most other text editors
set cursorline      " highlight current line horizontally
set wildmenu        " visual autocomplete for command menu
set showmatch       " highlight [{()}] matching
set visualbell      " turn on visual flashes instead of audible bell
set laststatus=2    " always shows status line (usefule for Airline plugin)
set noshowmode      " turn off default mode indicator since we have plugin
" Autoload changes to file whenever switching buffers or gaining focus
set autoread
au FocusGained, BufEnter * :silent! !
" Autosave when leaving a buffer or vim (but run no save hooks to be faster)
au FocusLost, WinLeave * :silent! noautocmd w
" automatically associate *.md files with Markdown syntax
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
colorscheme gmonokai

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
let mapleader=" "   " leader is comma
" jk to escape
inoremap jk <esc>
" Remove all trailing whitespace by pressing F5
nnoremap <F7> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" Fast saving
nnoremap <leader>w :w!<CR>
" turn off search highlighting
nnoremap <leader><space> :nohlsearch<CR>
" turn on spell checking
nnoremap <F5> :set spell spelllang=en_us<CR>
" Open new empty buffer
nmap <leader>n :enew<CR>
" Move to next open buffer
nmap <leader>l :bnext<CR>
" Move to previous buffer
nmap <leader>h :bprevious<CR>
" Close current buffer and move to previous one (similar to closing tab)
nmap <leader>bq :bp <BAR> bd #<CR>
" Show all open buffers and their status
nmap <leader>bl :ls<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldenable      " enable folding by default
" Space toggles opening/closing one layer of folds
nnoremap <space> za
" Leader_key+Space toggles opening/closing an entire layer of folds
nnoremap <leader><space> zA
set foldmethod=manual " or fold based on indent level

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
" toggle gundo
nnoremap <leader>u :GundoToggle<CR>

" Full path fuzzy file, buffer, mru, tag... finder
Plug 'ctrlpvim/ctrlp.vim'
" open CtrlP fuzzy search tool
nnoremap <leader>p :CtrlP<CR>
" Set cwd as top level of source control if available
let g:ctrlp_working_path_mode = 'r'
" Setup file ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}
" Ignore files called out in `.gitignore`
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Smart code-completion engine
" NOTE: there are some special installation considerations, see GitHub page for
" more information https://github.com/Valloric/YouCompleteMe
Plug 'Valloric/YouCompleteMe'

" Good looking tagline for bottom of Vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Enable the list of currently open buffers at the top
let g:airline#extensions#tabline#enabled = 1
" Show just the filename of open buffers
let g:airline#extensions#tabline#fnamemod = ':t'
" Only show tabline when 2 or more buffers are open
let g:airline#extensions#tabline#buffer_min_count = 2
" NOTE: Powerline fonts might be weird in some systems, look at FAQ link below
" https://github.com/vim-airline/vim-airline/wiki/FAQ
let g:airline_powerline_fonts = 1 " turn on powerline fonts
" if !exists('g:airline_symbols')
"   let g:airline_symbols = {}
" endif
" let g:airline_symbols.space = "\ua0"

" Plugin for snippets
Plug 'SirVer/ultisnips'

" Sublime-text like multiple-cursor use
Plug 'terryma/vim-multiple-cursors'

" Git wrapper
Plug 'tpope/vim-fugitive'

" Git gutter for showing diffs and other features
Plug 'airblade/vim-gitgutter'

call plug#end()
