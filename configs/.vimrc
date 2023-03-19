"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""
""" .vimrc- VIM settings by John Gentile <johncgentile17@gmail.com>
"""
"""  Minimal .vimrc (no plugins) for lightweight systems like Raspberry Pi
"""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Interface & Built-In Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8 " terminal output to UTF-8 (necessary for some distros)
set t_Co=256       " turn on 256 colors
set number         " turn on line numbering
set hidden         " hide buffers instead of closing them
syntax enable      " turn on syntax highlighting
filetype indent on " use indentation based on filetype in $RUNTIME/indent
set tabstop=4      " tab char == 4 spaces
set softtabstop=4  " edit file as if tab == 4 spaces to match shiftwidth
set shiftwidth=4   " indent 4 spaces (instead of 8) for one tab
set expandtab      " make sure tabs expand to spaces
set backspace=2    " make backspace work like most other text editors
set cursorline     " highlight current line horizontally
set wildmenu       " visual autocomplete for command menu
set showmatch      " highlight [{()}] matching
set visualbell     " turn on visual flashes instead of audible bell
set laststatus=2   " always shows status line (usefule for Airline plugin)
set noshowmode     " turn off default mode indicator since we have plugin
set autoread       " Autoload changes when switching buffers or gaining focus
set timeoutlen=300 " Quicker timeout for events (default: 1000 ms)
set updatetime=300 " Set updatetime for CursorHold
set shortmess+=c   " Avoid showing extra messages when using completion
set mouse=         " disable mouse/cursor movements
" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Determine OS being used (NOTE: `uname` not present on Windows)
if !exists("g:my_os")
  if has ("win64") || has("win32") || has("win16")
    let g:my_os = "Windows"
  else
    let g:my_os = substitute(system('uname'), '\n', '', '')
  endif
endif

" Use system CLIPBOARD register. Vim must be built w/clipboard support
if (g:my_os == "Darwin") || (g:my_os == "Windows")
  set clipboard=unnamed
else
  " *nix OS
  set clipboard=unnamedplus
endif

" Turn off background color erase (BCE) so that color schemes work within tmux
" (prevalent in CentOS 7.* where background bars are seen) based on term
" setting, see: https://superuser.com/questions/457911/in-vim-background-color-changes-on-scrolling
if &term =~ 'tmux-256color'
  " Can also manually be done via Ctrl+l
  set t_ut=
endif

" For VHDL syntax highlighting, indent similar to C-syntax operation
" (e.g. by shiftwidth())
let g:vhdl_indent_genportmap = 0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable folding by default
set foldenable
" Indent by indentation, not syntax or marker, some files like VHDL don't work
" will with syntax setting
set foldmethod=indent
" High-value here means files open unfolded by default
set foldlevel=99
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Backup, Swap & Undo Files in /tmp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Put backup, swap & undo tree files in /tmp with appended path ("//")
set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: to debug tab/spaces/EOLs in a file use `:set list`
func! SpacesToTabs()
  setlocal noexpandtab     " don't expand tabs to spaces
  %retab!                  " Retabulate the whole file
  " Re-indent file to new shiftwidth and keep cursor position
  normal mzgg=G`z
endfu
com! SpacesToTabs call SpacesToTabs()

func! TabsToSpaces()
  setlocal expandtab       " make sure tabs expand to spaces
  %retab!                  " Retabulate the whole file
  " Re-indent file to new shiftwidth and keep cursor position
  normal mzgg=G`z
endfu
com! TabsToSpaces call TabsToSpaces()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



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
  " versions of Vim)
  au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
  au BufNewFile,BufFilePre,BufRead *.{md,tex,txt} setlocal spell spelllang=en_us
  " Don't number lines on these text files
  au BufNewFile,BufFilePre,BufRead *.{md,tex,txt} set nonu

  " Show tabs in files
  set list
  set listchars=tab:\»\ ,extends:>,precedes:<,nbsp:+

  " Automatically remove all trailing whitespace when buffer is saved
  " except for the file extensions in `trail_blk_list`
  let g:trail_blk_list = ['markdown', 'text']
  au BufWritePre * if index(g:trail_blk_list, &ft) < 0 | %s/\s\+$//e
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

  " Execute current Python buffer (https://stackoverflow.com/a/18948530)
  au FileType python map <buffer> <F9> :up<CR>:exec '!python3' shellescape(@%, 1)<CR>
  au FileType python imap <buffer> <F9> <esc>:up<CR>:exec '!python3' shellescape(@%, 1)<CR>

  " Build & execute current Rust project
  au FileType rust map <buffer> <F9> :up<CR>:exec '!cargo run'<CR>
  au FileType rust imap <buffer> <F9> <esc>:up<CR>:exec '!cargo run'<CR>

augroup END
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching & Movement
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch       " search as characters are entered
if has('nvim')
  set inccommand=nosplit
endif
set hlsearch        " highlight matches
set ignorecase      " Ignore case when searching
" highlight last inserted text
nnoremap gV '[v']
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key & Leader Shortcuts/Remapping
"
" ALWAYS use nonrecursive mapping to prevent unintended consequences
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:mapleader=' '
" `jk` to escape
inoremap jk <esc>
" Since 'chage inner word' allows you to not have the cursor at the beginning
" of the word, map ciw -> cw by default.
nnoremap cw ciw
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors & Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Favorites are 'nord' || 'monokai'
colorscheme monokai
" show trailing whitespace as red
hi ExtraWhitespace ctermfg=NONE ctermbg=red cterm=NONE guifg=NONE guibg=red gui=NONE
" italicize comments
hi Comment cterm=italic gui=italic
hi SpecialComment cterm=italic gui=italic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

