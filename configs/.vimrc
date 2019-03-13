"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Interface & Editing Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8 " terminal output to UTF-8 (necessary for some distros)
set nocompatible   " noop when loading from ~/ but needed when $ vim -u .vimrc
set t_Co=256       " turn on 256 colors
set number         " turn on line numbering
set hidden         " hide buffers instead of closing them
syntax enable      " turn on syntax highlighting
filetype indent on " use indentation based on filetype in $RUNTIME/indent
set tabstop=8      " tab char == default 8 spaces
set softtabstop=2  " edit file as if tab == 2 spaces to match shiftwidth
set shiftwidth=2   " indent 2 spaces (instead of 8) for one tab
set expandtab      " make sure tabs expand to spaces
set backspace=2    " make backspace work like most other text editors
set cursorline     " highlight current line horizontally
set wildmenu       " visual autocomplete for command menu
set showmatch      " highlight [{()}] matching
set visualbell     " turn on visual flashes instead of audible bell
set laststatus=2   " always shows status line (usefule for Airline plugin)
set noshowmode     " turn off default mode indicator since we have plugin
set autoread       " Autoload changes when switching buffers or gaining focus
" Use system clipboard register
" Note: Vim >7.3 can also set to `unnamedplus` for `+` X window register
set clipboard=unnamed
" For VHDL syntax highlighting, indent similar to C-syntax operation
" (e.g. by shiftwidth())
let g:vhdl_indent_genportmap = 0

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
  "au BufNewFile,BufFilePre,BufRead *.md Goyo
  au BufNewFile,BufFilePre,BufRead *.{md,txt} setlocal spell spelllang=en_us

  " Automatically remove all trailing whitespace when buffer is saved
  " except for the file extensions in `trail_blk_list`
  let trail_blk_list = ['markdown', 'text']
  au BufWritePre * if index(trail_blk_list, &ft) < 0 | %s/\s\+$//e
  " Matching autocommand for highlighting extra whitespace in red
  " Uncomment below to match while typing (little aggressive)
  "match ExtraWhitespace /\s\+$/
  au BufWinEnter * if index(trail_blk_list, &ft) < 0 | match ExtraWhitespace /\s\+$/
  au InsertEnter * if index(trail_blk_list, &ft) < 0 | match ExtraWhitespace /\s\+\%#\@<!$/
  au InsertLeave * if index(trail_blk_list, &ft) < 0 | match ExtraWhitespace /\s\+$/
  " Clear when leaving for performance issues
  au BufWinLeave * call clearmatches()

  " Close vim automatically if the only window left open is `NERDTree` plugin
  au bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

  " Set cursorline only when not in insert mode
  au InsertLeave,WinEnter * set cursorline
  au InsertEnter,WinLeave * set nocursorline

  " Set .xdc to TCL
  au BufNewFile,BufFilePre,BufRead *.xdc set filetype=tcl

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
" Map arrow keys to graphical movements
nnoremap <Up> gk
nnoremap <Down> gj
" Remove all trailing whitespace by pressing F7 (also see above for autoremove
" trailing whitespace on buffer save for specific filetypes)j
nnoremap <F7> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" Toggle spell checking (default off)
nnoremap <F5> :set spell! spelllang=en_us<CR>

" Open new empty buffer
nnoremap <leader>n :enew<CR>
" Move to next open buffer (`f` for home row)
nnoremap <leader>fl :bnext<CR>
" Move to previous buffer (`f` for home row)
nnoremap <leader>fh :bprevious<CR>
" Close current buffer and move to previous one (similar to closing tab)
nnoremap <leader>fq :bp <BAR> bd #<CR>
" Vertical split (into another window) current file
nnoremap <leader>v :vsplit<CR>
" Horizontal split (into another window) current file
nnoremap <leader>s :split<CR>
" Move to window left
nnoremap <leader>h <C-w><Left>
" Move to window right
nnoremap <leader>l <C-w><Right>
" Move to window up
nnoremap <leader>k <C-w><Up>
" Move to window down
nnoremap <leader>j <C-w><Down>
" Close current window
nnoremap <leader>q :hide<CR>
" Enlarge current window height by 10 lines
nnoremap <leader>K :res +10<CR>
" Shrink current window height by 10 lines
nnoremap <leader>J :res -10<CR>
" Enlarge current window width by 10 lines
nnoremap <leader>L :vertical resize +10<CR>
" Shrink current window width by 10 lines
nnoremap <leader>H :vertical resize -10<CR>

" Open/toggle `NERDTree` file viewer plugin
nnoremap <leader>t :NERDTreeToggle<CR>
" Open/toggle `Tagbar` tag viewer plugin
nnoremap <leader>y :TagbarToggle<CR>
" Toggle `gundo` undo search plugin
nnoremap <leader>u :GundoToggle<CR>
" Open `CtrlP` plugin fuzzy search tool
nnoremap <leader>p :CtrlP<CR>
" Remap `GitGutter` keys that conflict with <Space/leader>+h
nnoremap <leader>gsh <Plug>GitGutterStageHunk
nnoremap <leader>guh <Plug>GitGutterUndoHunk
nnoremap <leader>gph <Plug>GitGutterPreviewHunk
" ALE navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" Start using Ack.vim (targeting `ag`) but don't jump to 1st match
nnoremap <leader>a :Ack!<Space>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable folding by default
set foldenable
" Space toggles opening/closing one layer of folds
nnoremap <leader>kj za
" Leader_key+Space toggles opening/closing an entire layer of folds
nnoremap <leader>KJ zA
set foldmethod=indent
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
  " set 80 chars/line
  set textwidth=0
  if exists('&colorcolumn')
    set colorcolumn=80
  endif
endfu
com! StyleLinuxC call LinuxCStyle()

" Reset any Style changes
func! ResetStyle()
  setlocal shiftwidth=2
  " Re-indent file to new shiftwidth and keep cursor position
  normal mzgg=G`z
endfu
com! StyleReset call ResetStyle()

" NOTE: to debug tab/spaces/EOLs in a file use `:set list`
func! SpacesToTabs()
  setlocal softtabstop=8   " edit file as if tab == 8 spaces to match shiftwidth
  setlocal shiftwidth=8    " indent 8 spaces for one tab/indent
  setlocal noexpandtab     " don't expand tabs to spaces
  %retab!                  " Retabulate the whole file
endfu
com! SpacesToTabs call SpacesToTabs()

func! TabsToSpaces()
  setlocal softtabstop=2   " edit file as if tab == 2 spaces to match shiftwidth
  setlocal shiftwidth=2    " indent 2 spaces (instead of 8) for one tab/indent
  setlocal expandtab       " make sure tabs expand to spaces
  %retab!                  " Retabulate the whole file
endfu
com! TabsToSpaces call TabsToSpaces()

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

  " Ack.vim plugin using `ag` text search
  Plug 'mileszs/ack.vim'
  if executable('ag')
    " Use let g:ackprg = 'ag --vimgrep' to report every match on a line
    let g:ackprg = 'ag --nogroup --nocolor --column'
  endif

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

  " Async linting engine
  " Used instead of vim-syntastic/syntastic since also using YouCompleteMe
  Plug 'w0rp/ale'
  let g:airline#extensions#ale#enabled = 1
  " to save some processing, lint only on save by uncommenting below:
  " let g:ale_lint_on_text_changed = 'never'
  " let g:ale_lint_on_enter = 0

  " Allow all Vim plugins insert modes to be fired off of <Tab>
  Plug 'ervandew/supertab'

  " displays tags in window ordered by scope
  Plug 'majutsushi/tagbar'

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

  " Sublime-text like multiple-cursor use
  " Plug 'terryma/vim-multiple-cursors'

  " Git wrapper with lots of helper functions when working in git repos
  Plug 'tpope/vim-fugitive'

  " Git gutter for showing diffs and other features
  Plug 'airblade/vim-gitgutter'
  " Only check on file save/load
  let g:gitgutter_realtime = 0
  let g:gitgutter_eager = 0

  " Header generator- decided not to use as it had some issues with tracking updates
  " and IMO, the things it was stating were already tracked via source control;
  " anything else in the header of files besides succinct documentation or necessary
  " meta (like shebangs for shell scripts) is a waste of space, readability and needs
  " to be kept up-to-date (inefficient)
  "Plug 'alpertuna/vim-header'
  "let g:header_field_author = 'John Gentile'
  "let g:header_field_author_email = 'johncgentile17@gmail.com'
  "let g:header_max_size = 5

  " Easy text alignment plugin
  Plug 'godlygeek/tabular'

  " Markdown highlighting
  Plug 'plasticboy/vim-markdown'
  set conceallevel=2
  let g:vim_markdown_math = 1
  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_new_list_item_indent = 0

  " Distraction free writing
  Plug 'junegunn/goyo.vim'
  autocmd! User GoyoEnter call <SID>goyo_enter()
  autocmd! User GoyoLeave call <SID>goyo_leave()

  " Highlights recently yanked text
  Plug 'machakann/vim-highlightedyank'
  " ms to keep highlighted, -1 to persist until edit or new yank
  let g:highlightedyank_highlight_duration = -1

  " Vader test framework
  Plug 'junegunn/vader.vim'

  " Auto check if Vim plugins need to be updated
  Plug 'semanser/vim-outdated-plugins'
  " Do not show any message if all plugins are up to date. 0 by default
  let g:outdated_plugins_silent_mode = 1

  " Display # of search matches & index of current match
  Plug 'google/vim-searchindex'

call plug#end()

" Applied last to override any comment settings
highlight Comment cterm=italic
