" Vundle setup - MUST be at the top
set nocompatible              " required
filetype off                  " required

" enable syntax highlighting
syntax enable

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Load plugins from bundle files (includes Vundle.vim plugin declaration)
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif
if filereadable(expand("~/.vimrc.bundles.local"))
  source ~/.vimrc.bundles.local
endif

" All plugins must be added before this line
call vundle#end()

" ensure ftdetect et al work by including this after the Vundle stuff
filetype plugin indent on

set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamed                                        " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                                " expand tabs to spaces
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set shiftwidth=2                                             " normal mode indentation commands use 2 spaces
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=2                                            " insert mode tab and backspace use 2 spaces
set tabstop=8                                                " actual tabs occupy 8 characters
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
  set ttymouse=xterm2
endif

" .vimrc.local settings
set nocursorline " don't highlight current line
set tags+=gems.tags
set hlsearch
set splitbelow
set splitright

" keyboard shortcuts
let mapleader = ','
inoremap jj <ESC>

" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0

" use the new SnipMate parser
let g:snipMate = { 'snippet_version' : 1 }

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" File type settings
augroup filetype_settings
  autocmd!
  " fdoc is yaml
  autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
  " md is markdown
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile *.md set spell
augroup END

" Rails.vim helpers
augroup rails_helpers
  autocmd!
  autocmd User Rails silent! Rnavcommand decorator      app/decorators            -glob=**/* -suffix=_decorator.rb
  autocmd User Rails silent! Rnavcommand observer       app/observers             -glob=**/* -suffix=_observer.rb
  autocmd User Rails silent! Rnavcommand feature        features                  -glob=**/* -suffix=.feature
  autocmd User Rails silent! Rnavcommand job            app/jobs                  -glob=**/* -suffix=_job.rb
  autocmd User Rails silent! Rnavcommand mediator       app/mediators             -glob=**/* -suffix=_mediator.rb
  autocmd User Rails silent! Rnavcommand stepdefinition features/step_definitions -glob=**/* -suffix=_steps.rb
augroup END

" Window management
augroup window_management
  autocmd!
  " automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =
augroup END

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" gui settings
if (&t_Co == 256 || has('gui_running'))
  if ($TERM_PROGRAM == 'iTerm.app')
    colorscheme solarized
  else
    colorscheme desert
  endif
endif

" Disambiguate ,a & ,t from the Align plugin, making them fast again.
"
" This section is here to prevent AlignMaps from adding a bunch of mappings
" that interfere with the very-common ,a and ,t mappings. This will get run
" at every startup to remove the AlignMaps for the *next* vim startup.
"
" If you do want the AlignMaps mappings, remove this section, remove
" ~/.vim/bundle/Align, and re-run rake in maximum-awesome.
function! s:RemoveConflictingAlignMaps()
  if exists("g:loaded_AlignMapsPlugin")
    AlignMapsClean
  endif
endfunction
command! -nargs=0 RemoveConflictingAlignMaps call s:RemoveConflictingAlignMaps()
silent! autocmd VimEnter * RemoveConflictingAlignMaps

" Move current window between tabs
function MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    sp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < l:tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    sp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc
nnoremap <leader>mn :call MoveToNextTab()<CR><C-w>H
nnoremap <leader>mp :call MoveToPrevTab()<CR><C-w>H

" XM customised key mappings
" Vim abbreviation
abbr rld Rails.logger.debug ""<esc>1b
abbr rli Rails.logger.info ""<esc>1b
abbr rle Rails.logger.error ""<esc>1b
abbr rlw Rails.logger.warning ""<esc>1b
abbr cl console.log("")<esc>1b
abbr { {}<esc>i
abbr ## #{}<esc>i
abbr ins inspect
abbr treu true
abbr teh the
abbr seperate separate
abbr xwm Xiangwei Meng

" https://vim.fandom.com/wiki/Dictionary_completions
:set complete+=k
:set dictionary+=/usr/share/dict/words

" Go to last active tab
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <leader>lt :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <leader>lt :exe "tabn ".g:lasttab<cr>

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>
noremap <leader>n :tabnext<cr>
noremap <leader>, :tabnext<cr>
noremap <leader>,, :tabp<cr>
nnoremap <silent> <c-n> gt<cr>
nnoremap <silent> <c-p> gT<cr>
noremap <leader>tp :tabp<cr>
noremap <leader>new :tabnew<cr>
noremap <leader>j 10j
noremap <leader>k 10k

" close tab
noremap <leader>ct :tabclose<cr>

" quickfix window XM: Don't use the below as they will make : very slow
noremap <leader>co :copen<CR>
noremap <leader>cc :cclose<CR>

nnoremap <silent> <c-s> :w<cr>
nnoremap <silent> <c-t> :tabnew<cr>
" Move current tab to first position
nnoremap <silent> <leader>tf :tabm 0<CR>
" Move current tab to previous position (one position to the left)
nnoremap <silent> <leader>tl :tabm -<CR>
" Move current tab to next position (one position to the right)
nnoremap <silent> <leader>tr :tabm +<CR>

" maximize current split pane
if exists(':MaximizerToggle')
  nnoremap <silent> mm :MaximizerToggle<CR>
endif

" Vim navigation
nnoremap th  :tabfirst<CR>
nnoremap tl  :tablast<CR>
nnoremap tm  :tabm<Space>
nnoremap tn :tabnew<CR>
nnoremap tt :tab ter<CR>

" nnoremap H gT
" nnoremap L gt
nnoremap H :bp<cr>
nnoremap L :bn<cr>

" Additional keyboard shortcuts from main .vimrc
nnoremap <leader>al :Align
nnoremap <leader>a :Ag<space>
nnoremap <leader>bl :CtrlPBuffer<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <leader>p :CtrlP<CR>
nnoremap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
nnoremap <leader>gg :GitGutterToggle<CR>
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" Use leader-w[hjkl] to select the active split!
nmap <leader>wh :wincmd h<CR>
nmap <leader>wj :wincmd j<CR>
nmap <leader>wk :wincmd k<CR>
nmap <leader>wl :wincmd l<CR>

" Save to Session.vim. The following is not working
" nnoremap <lead>q :mks!<CR> :q<CR>

" You might want to set these session options in your vimrc. Especially options is annoying when you've changed your vimrc after you've saved the session.
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds

" relative path (src/foo.txt)
nnoremap <leader>cr :let @*=expand("%")<CR>
" absolute path (/something/src/foo.txt)
nnoremap <leader>ca :let @*=expand("%:p")<CR>
" filename (foo.txt)
nnoremap <leader>cf :let @+=expand("%:t")<CR>
" directory name (/something/src)
nnoremap <leader>cd :let @*=expand("%:p:h")<CR>

" rubytest.vim
" https://www.vim.org/scripts/script.php?script_id=2612#:~:text=Unzip%20downloaded%20file%20and%20copy,vim%2Fplugin%20directory.&text=After%20installation%2C%20press,editing%20a%20ruby%20test%20file.
" change from <Leader>t to <Leader>\
map <leader>\ <Plug>RubyTestRun
" change from <Leader>T to <Leader>]
" map <leader>] <Plug>RubyFileRun
map <leader>[ <Plug>RubyFileRun
" change from <Leader>l to <Leader>/
map <leader>/ <Plug>RubyTestRunLast

" You might want to set these session options in your vimrc. Especially options is annoying when you've changed your vimrc after you've saved the session.
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds


" Git
function GitDiff()
    :silent write
    :silent execute '!git diff --color=always -- ' . shellescape(expand('%:p')) . ' | less --RAW-CONTROL-CHARS'
    :redraw!
endfunction

" Vimscript

nnoremap <leader>gd :call GitDiff()<cr>

" Open vimrc
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Open vimrc.local
:nnoremap <leader>el :vsplit $MYVIMRC.local<cr>
" Source vimrc
:nnoremap <leader>sv :source $MYVIMRC<cr>

" Surround the word with double quotes
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
" Remove double quotes from the word
nnoremap <leader>"" viw<esc>lxbhx

" Surround the word with single quotes
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
" Remove single quotes from the word
nnoremap <leader>'' viw<esc>lxbhx

" Use jk to exit insert mode
:inoremap jk <esc>

" Delete all the text inside the parentheses
:onoremap p i(
" Delete all the text inside the single quotes
:onoremap q i'
" Delete all the text inside the double quotes
:onoremap qq i"

" Delete the entire body of the function
:onoremap b /end<cr>

" Window navigation with Ctrl + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Better tab navigation
nnoremap <S-Tab> :tabprevious<CR>
nnoremap <Tab> :tabnext<CR>

" Quick buffer switching
nnoremap <leader>bb :b#<CR>        " Switch to last buffer
" Vimscript file settings ---------------------- {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" vim-which-key configuration (only if plugin is loaded)
if exists('g:loaded_which_key')
  nnoremap <silent> <leader> :<c-u>WhichKey ','<CR>
  vnoremap <silent> <leader> :<c-u>WhichKeyVisual ','<CR>
endif
set timeoutlen=500

" Define which-key dictionary
let g:which_key_map = {}

" Tab navigation group
let g:which_key_map['1'] = 'tab-1'
let g:which_key_map['2'] = 'tab-2'
let g:which_key_map['3'] = 'tab-3'
let g:which_key_map['4'] = 'tab-4'
let g:which_key_map['5'] = 'tab-5'
let g:which_key_map['6'] = 'tab-6'
let g:which_key_map['7'] = 'tab-7'
let g:which_key_map['8'] = 'tab-8'
let g:which_key_map['9'] = 'tab-9'
let g:which_key_map['0'] = 'tab-last'
let g:which_key_map['n'] = 'tab-next'
let g:which_key_map['p'] = 'ctrlp'
let g:which_key_map['tp'] = 'tab-prev'
let g:which_key_map[','] = 'tab-next'
let g:which_key_map['new'] = 'new-tab'
let g:which_key_map['lt'] = 'last-active-tab'

" Files and buffers
let g:which_key_map['a'] = 'ag-search'
let g:which_key_map.b = {
      \ 'name' : '+buffers',
      \ 'b' : 'last-buffer',
      \ 'l' : 'buffer-list',
      \ }
let g:which_key_map['d'] = 'nerdtree-toggle'
let g:which_key_map['f'] = 'nerdtree-find'
let g:which_key_map['T'] = 'ctrlp-clear'

" Copy paths, quickfix, and close tab
let g:which_key_map.c = {
      \ 'name' : '+copy/quickfix/close',
      \ 'r' : 'copy-rel-path',
      \ 'a' : 'copy-abs-path',
      \ 'f' : 'copy-filename',
      \ 'd' : 'copy-directory',
      \ 'o' : 'quickfix-open',
      \ 'c' : 'quickfix-close',
      \ 't' : 'close-tab',
      \ }

" Git
let g:which_key_map.g = {
      \ 'name' : '+git',
      \ 'd' : 'diff',
      \ 'g' : 'gutter-toggle',
      \ }

" Vim config
let g:which_key_map.e = {
      \ 'name' : '+edit-config',
      \ 'v' : 'vimrc',
      \ 'l' : 'vimrc-local',
      \ }

let g:which_key_map.s = {
      \ 'name' : '+source',
      \ 'v' : 'source-vimrc',
      \ }

" Tab and window management
let g:which_key_map.t = {
      \ 'name' : '+tab-move',
      \ 'f' : 'move-tab-first',
      \ 'l' : 'move-tab-left',
      \ 'r' : 'move-tab-right',
      \ }

let g:which_key_map.m = {
      \ 'name' : '+move-window',
      \ 'n' : 'move-next-tab',
      \ 'p' : 'move-prev-tab',
      \ }

let g:which_key_map.w = {
      \ 'name' : '+windows',
      \ 'h' : 'window-left',
      \ 'j' : 'window-down',
      \ 'k' : 'window-up',
      \ 'l' : 'window-right',
      \ }

" Testing (rubytest)
let g:which_key_map['\'] = 'run-test'
let g:which_key_map['['] = 'run-file'
let g:which_key_map['/'] = 'run-last-test'

" Other
let g:which_key_map['al'] = 'align'
let g:which_key_map['j'] = 'down-10'
let g:which_key_map['k'] = 'up-10'
let g:which_key_map[']'] = 'tagbar-toggle'
let g:which_key_map[' '] = 'strip-whitespace'
let g:which_key_map['V'] = 'reload-vimrc'
let g:which_key_map['"'] = 'quote-word'
let g:which_key_map["'"] = 'single-quote-word'

" Register the dictionary (only if which-key is loaded)
if exists('g:loaded_which_key')
  call which_key#register(',', "g:which_key_map")
endif

" vim-which-key styling
let g:which_key_use_floating_win = 0
let g:which_key_max_size = 0
let g:which_key_position = 'botright'
let g:which_key_vertical = 0

" Custom colors for which-key
augroup which_key_colors
  autocmd!
  autocmd FileType which_key set laststatus=0 noshowmode noruler
  autocmd FileType which_key autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

" Better color scheme for which-key window
highlight WhichKey guifg=#61afef ctermfg=75
highlight WhichKeySeparator guifg=#98c379 ctermfg=114
highlight WhichKeyGroup guifg=#c678dd ctermfg=176
highlight WhichKeyDesc guifg=#abb2bf ctermfg=249
highlight WhichKeyFloating guibg=#282c34 ctermbg=235


