"""
""" .vimrc- VIM settings by John Gentile <johncgentile17@gmail.com>
"""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Interface & Built-In Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8 " terminal output to UTF-8 (necessary for some distros)
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
set timeoutlen=300 " Quicker timeout for events (default: 1000 ms)

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

" Built-in File Browser
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" Neovim specific
"if has('nvim')
"  " return cursor to blinking iBeam after exit (see ":help 'guicursor'")
"  au VimLeave * set guicursor=a:ver4-blinkon500
"endif


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
  au BufNewFile,BufFilePre,BufRead *.{md,tex,txt} setlocal spell spelllang=en_us

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

  " Default to LinuxCStyle for C apps
  au FileType c StyleLinuxC

augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching & Movement
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch       " search as characters are entered
set inccommand=nosplit
set hlsearch        " highlight matches
set ignorecase      " Ignore case when searching
" highlight last inserted text
nnoremap gV '[v']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key & Leader Shortcuts/Remapping
"
" ALWAYS use nonrecursive mapping to prevent unintended consequences
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:mapleader=' '
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
" Indent by indentation, not syntax or marker, some files like VHDL don't work
" will with syntax setting
set foldmethod=indent
" High-value here means files open unfolded by default
set foldlevel=99


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Backup, Swap & Undo Files in /tmp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Put backup, swap & undo tree files in /tmp with appended path ("//")
set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Distraction-Free Word Processor
func! WordProcessorMode()
  setlocal smartindent
  setlocal spell spelllang=en_us
  setlocal noexpandtab
  setlocal nonumber
  setlocal textwidth=79
  setlocal background=light
  syntax off
endfu
com! WP call WordProcessorMode()

" Apply Linux C Style guidelines
func! LinuxCStyle()
  setlocal softtabstop=8   " edit file as if tab == 8 spaces to match shiftwidth
  setlocal shiftwidth=8    " indent 8 spaces for one tab/indent
  setlocal noexpandtab     " don't expand tabs to spaces
endfu
com! StyleLinuxC call LinuxCStyle()

" Reset any Style changes
func! ResetStyle()
  setlocal softtabstop=2   " edit file as if tab == 2 spaces to match shiftwidth
  setlocal shiftwidth=2    " indent 2 spaces (instead of 8) for one tab/indent
  setlocal expandtab       " make sure tabs expand to spaces
endfu
com! StyleReset call ResetStyle()

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
" Plugin specific documentation can be found at https://github.com/<Plug>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

  " AckVim: plugin using `ag` text search ------------------------------------
  Plug 'mileszs/ack.vim'
  if executable('ag')
    " Use let g:ackprg = 'ag --vimgrep' to report every match on a line
    let g:ackprg = 'ag --nogroup --nocolor --column'
  endif


  " ALE: Async linting engine ------------------------------------------------
  " Used instead of vim-syntastic/syntastic since also using YouCompleteMe
  Plug 'w0rp/ale'
  let g:airline#extensions#ale#enabled = 1
  " to save some processing, lint only on save by uncommenting below:
  " let g:ale_lint_on_text_changed = 'never'
  " let g:ale_lint_on_enter = 0
  "" Note: cannot get this to work w/compile_commands.json generated by Bear :(
  " let g:ale_c_parse_compile_commands = 1
  let g:ale_c_parse_makefile = 1
  " set preferred linters for languages:
  let g:ale_linters = {
  \ 'vhdl': ['vcom'],
  \ 'verilog': ['vlog'],
  \}
  " For VHDL 2008, use openieee for IEEE packages:
  " https://github.com/ghdl/ghdl/issues/1255#issuecomment-619308878
  let g:ale_vhdl_ghdl_options = '--std=08 --enable-openieee'
  " vcom option defaults: https://github.com/dense-analysis/ale/blob/master/ale_linters/vhdl/vcom.vim
  " vlog option defaults: https://github.com/dense-analysis/ale/blob/master/ale_linters/verilog/vlog.vim


  " CtrlP: Full path fuzzy file, buffer, mru, tag... finder ------------------
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


  " EditorConfig: Maintain consistent coding styles for projects -------------
  Plug 'editorconfig/editorconfig-vim'
  let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']


  " Goyo: Distraction free writing -------------------------------------------
  Plug 'junegunn/goyo.vim'
  autocmd! User GoyoEnter call <SID>goyo_enter()
  autocmd! User GoyoLeave call <SID>goyo_leave()


  " Gundo: Visual 'Undo' Tree ------------------------------------------------
  Plug 'sjl/gundo.vim'


  " NerdTree: Filesystem explorer for vim ------------------------------------
  Plug 'scrooloose/nerdtree'
  " Plugin to NERDTree showing `git` status flags to files
  Plug 'Xuyuanp/nerdtree-git-plugin'
  " ranger-like key binding to NERDTree
  Plug 'hankchiutw/nerdtree-ranger.vim'


  " SuperTab: Allow all Vim plugins insert modes to be fired off of <Tab> ----
  Plug 'ervandew/supertab'
  let g:SuperTabDefaultCompletionType = '<C-n>'


  " Tabular: Easy text alignment plugin --------------------------------------
  Plug 'godlygeek/tabular'


  " TagBar: displays tags in window ordered by scope -------------------------
  Plug 'preservim/tagbar'


  " UltiSnips: Plugin for snippets -------------------------------------------
  Plug 'SirVer/ultisnips'
  " better key bindings for UltiSnipsExpandTrigger
  let g:UltiSnipsExpandTrigger = "<tab>"
  let g:UltiSnipsJumpForwardTrigger = "<tab>"
  let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"


  " Vader: Vader test framework ----------------------------------------------
  Plug 'junegunn/vader.vim'


  " VimAirline: Good looking tagline for bottom of Vim -----------------------
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


  " VimEunuch: useful UNIX shell commands w/o leaving Vim --------------------
  Plug 'tpope/vim-eunuch'


  " VimFugitive: Git helper functions for repos ------------------------------
  Plug 'tpope/vim-fugitive'


  " VimGitGutter: for showing diffs and other features in sidebar ------------
  Plug 'airblade/vim-gitgutter'
  " Only check on file save/load
  let g:gitgutter_realtime = 0
  let g:gitgutter_eager = 0


  " VimGo: Go plugin for syntax, completion and other helpful functions ------
  "Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }


  " VimGutentags: manages & auto-(re)generates tag files for project ---------
  Plug 'ludovicchabant/vim-gutentags'
  set statusline+=%{gutentags#statusline()}


  " VimHighlightedYank: Highlights recently yanked text ----------------------
  Plug 'machakann/vim-highlightedyank'
  " ms to keep highlighted, -1 to persist until edit or new yank
  let g:highlightedyank_highlight_duration = -1


  " VimMarkdown: Markdown highlighting ---------------------------------------
  Plug 'plasticboy/vim-markdown'
  set conceallevel=2
  let g:vim_markdown_math = 1
  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_new_list_item_indent = 0


  " VimOutdatedPlugins: Auto check if Vim plugins need to be updated ---------
  Plug 'semanser/vim-outdated-plugins'
  " Do not show any message if all plugins are up to date. 0 by default
  let g:outdated_plugins_silent_mode = 1


  " VimSearchIndex: Display # of search matches & index of current match -----
  Plug 'google/vim-searchindex'


  " VimPolyglot: a collection of language packs
  Plug 'sheerun/vim-polyglot'


  " VimSnippets: Language snippets for UltiSnips plugin
  Plug 'honza/vim-snippets'


  " VimSurround: Plugin to quickly edit brackers, quotes, tags, etc. ---------
  Plug 'tpope/vim-surround'


  " VimTex: LaTeX writing support
  Plug 'lervag/vimtex'
  if (g:my_os == "Darwin")
    let g:vimtex_view_method='skim'
    let g:vimtex_view_general_viewer='/Applications/Skim.app/Contents/SharedSupport/displayline'
    let g:vimtex_view_general_options='-r @line @pdf @tex'
    " This adds a callback hook that updates Skim after compilation
    " 2021-10-18: updated from deprecated g:vimtex_compiler_callback_hooks
    " like in https://github.com/jdhao/nvim-config/blob/master/core/plugins.vim

    augroup vimtex_mac
      autocmd!
      autocmd User VimtexEventCompileSuccess call UpdateSkim()
    augroup END

    function! UpdateSkim(status)
      if !a:status | return | endif

      let l:out = b:vimtex.out()
      let l:tex = expand('%:p')
      let l:cmd = [g:vimtex_view_general_viewer, '-r']
      if !empty(system('pgrep Skim'))
        call extend(l:cmd, ['-g'])
      endif
      if has('nvim')
        call jobstart(l:cmd + [line('.'), l:out, l:tex])
      elseif has('job')
        call job_start(l:cmd + [line('.'), l:out, l:tex])
      else
        call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
      endif
    endfunction
  else
    let g:latex_view_general_viewer='zathura'
    let g:vimtex_view_method='zathura'
  endif
  let g:tex_flavor='latex'
  let g:vimtex_quickfix_open_on_warning=0
  let g:vimtex_quickfix_mode=2
  set conceallevel=1
  let g:tex_conceal='abdmg'
  " use nvr to support `--servername` sync
  if has('nvim')
    let g:vimtex_compiler_progname = 'nvr'
  endif


  " YouCompleteMe: Smart code-completion engine ------------------------------
  " for special installation considerations, see GitHub page for
  " more information https://github.com/Valloric/YouCompleteMe
  "Plug 'Valloric/YouCompleteMe'
  " remove limit on YCM diagnostics to display
  " if running into issues, drop down to sensible # (default = 30)
  "let g:ycm_max_diagnostics_to_display = 0
  "let g:ycm_autoclose_preview_window_after_completion = 1
  "let g:ycm_collect_identifiers_from_tags_files = 1
  "" make YCM compatible with UltiSnips (using supertab)
  "let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  "let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors (loaded last)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme monokai

