" File              : .vimrc
" Author            : John Gentile <johncgentile17@gmail.com>
" Date              : 06.12.2017
" Last Modified Date: 07.02.2018
" Last Modified By  : John Gentile <johncgentile17@gmail.com>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Interface & Editing Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible    " noop when loading from ~/ but needed when $ vim -u .vimrc
set t_Co=256        " turn on 256 colors
set number          " turn on line numbering
set hidden          " hide buffers instead of closing them
syntax enable       " turn on syntax highlighting
set cindent         " use C-style indenting
set shiftwidth=2    " indent 2 spaces (instead of 8) for one tab
set expandtab       " make sure tabs expand to spaces
set backspace=2     " make backspace work like most other text editors
set cursorline      " highlight current line horizontally
set wildmenu        " visual autocomplete for command menu
set showmatch       " highlight [{()}] matching
set visualbell      " turn on visual flashes instead of audible bell
set laststatus=2    " always shows status line (usefule for Airline plugin)
set noshowmode      " turn off default mode indicator since we have plugin
set autoread        " Autoload changes when switching buffers or gaining focus

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme monokai
highlight ExtraWhitespace ctermbg=red guibg=red

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands
"
" Use autocommand enclosures to prevent double-loading of autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DEBUG: Be verbose when executing autocommands (mostly keep commented out)
"set verbose=9

augroup multi_buffer
  au!
  au FocusGained, BufEnter * :silent! !
  " Autosave when leaving a buffer or vim (but run no save hooks to be faster)
  au FocusLost, WinLeave * :silent! noautocmd w
augroup END

augroup code_extensions_and_syntax
  au!
  " automatically associate *.md files with Markdown syntax (maybe NA for newer
  " versions of Vim) and launch `Goyo` plugin automatically
  au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
  au BufNewFile,BufFilePre,BufRead *.md Goyo
  " Automatically remove all trailing whitespace when buffer is saved for
  " certain text-based programming file extensions
  au BufWritePre *.{c,cpp,h,hpp,sh,vhd} %s/\s\+$//e
  " Matching autocommand for highlighting extra whitespace in red
  " Uncomment below to match while typing (little aggressive)
  "match ExtraWhitespace /\s\+$/
  au BufWinEnter *.{c,cpp,h,hpp,sh,vhd} match ExtraWhitespace /\s\+$/
  au InsertEnter *.{c,cpp,h,hpp,sh,vhd} match ExtraWhitespace /\s\+\%#\@<!$/
  au InsertLeave *.{c,cpp,h,hpp,sh,vhd} match ExtraWhitespace /\s\+$/
  " Clear when leaving for performance issues
  au BufWinLeave * call clearmatches()

  " Close vim automatically if the only window left open is `NERDTree` plugin
  au bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching & Movement
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch       " search as characters are entered
set hlsearch        " highlight matches
set ignorecase      " Ignore case when searching
" highlight last inserted text
nnoremap gV '[v']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key & Leader Shortcuts/Remapping
"
" ALWAYS use nonrecursive mapping to prevent unintended consequences
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=" "
" `jk` to escape
inoremap jk <esc>
" Remove all trailing whitespace by pressing F7 (also see above for autoremove
" trailing whitespace on buffer save for specific filetypes)j
nnoremap <F7> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" Toggle spell checking (default off)
nnoremap <F5> :set spell! spelllang=en_us<CR>
" Open new empty buffer
nnoremap <leader>n :enew<CR>
" Move to next open buffer
nnoremap <leader>l :bnext<CR>
" Move to previous buffer
nnoremap <leader>h :bprevious<CR>
" Close current buffer and move to previous one (similar to closing tab)
nnoremap <leader>q :bp <BAR> bd #<CR>
" Show all open buffers and their status
nnoremap <leader>bl :ls<CR>
" Open/toggle `NERDTree` file viewer plugin
nnoremap <leader>t :NERDTreeToggle<CR>
" Toggle `gundo` undo search plugin
nnoremap <leader>u :GundoToggle<CR>
" Open `CtrlP` plugin fuzzy search tool
nnoremap <leader>p :CtrlP<CR>
" Add Header to top of file with `vim-header` plugin
nnoremap <F4> :AddHeader<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable folding by default
set foldenable
" Space toggles opening/closing one layer of folds
nnoremap <leader>kj za
" Leader_key+Space toggles opening/closing an entire layer of folds
nnoremap <leader>KJ zA
set foldmethod=syntax
set foldlevel=99

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
  setlocal nonumber
  setlocal tw=79
  setlocal background=light
  syntax off
endfu
com! WP call WordProcessorMode()

" Apply Linux C Style guidelines
func! LinuxCStyle()
  setlocal shiftwidth=8
  " Re-indent file to new shiftwidth and keep cursor position
  normal mzgg=G`z
endfu
com! LinuxC call LinuxCStyle()

" Functions for `Goyo` plugin to quit even when `:q` is called
function! s:goyo_enter()
  silent !tmux set status off
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM-Plug Commands
"
" Go to https://github.com/junegunn/vim-plug for install instructions
" Plugin specific documentation can be found at https://github.com/_PLUG_
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Visual 'Undo' Tree
Plug 'sjl/gundo.vim'

" Full path fuzzy file, buffer, mru, tag... finder
Plug 'ctrlpvim/ctrlp.vim'
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

" Filesystem explorer for vim
Plug 'scrooloose/nerdtree'
" Plugin to NERDTree showing `git` status flags to files
Plug 'Xuyuanp/nerdtree-git-plugin'

" Plugin for snippets
Plug 'SirVer/ultisnips'
" set ultisnips to use a key that doesn't conflict with YCM
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" Sublime-text like multiple-cursor use
Plug 'terryma/vim-multiple-cursors'

" Git wrapper
Plug 'tpope/vim-fugitive'

" Git gutter for showing diffs and other features
Plug 'airblade/vim-gitgutter'
" Only check on file save/load
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
" unmap git gutter keys so that <leader>h works faster
autocmd VimEnter * unmap <leader>hp
autocmd VimEnter * unmap <leader>hr
autocmd VimEnter * unmap <leader>hu
autocmd VimEnter * unmap <leader>hs

" Header generator
Plug 'alpertuna/vim-header'
let g:header_field_author = 'John Gentile'
let g:header_field_author_email = 'johncgentile17@gmail.com'
let g:header_max_size = 12

" Markdown highlighting
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
set conceallevel=2
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2

" Distraction free writing
Plug 'junegunn/goyo.vim'
autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()

call plug#end()

" Applied last to override any comment settings
highlight Comment cterm=italic
