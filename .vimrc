set nocursorline " don't highlight current line
set tags+=gems.tags

set hlsearch
set splitbelow
set splitright

" keyboard shortcuts
inoremap jj <ESC>



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
noremap <leader>p :tabp<cr>
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

" Use leader-[hjkl] to select the active split!
" nmap <leader>k :wincmd k<CR>
" nmap <leader>j :wincmd j<CR>
nmap <leader>h :wincmd h<CR>
nmap <leader>l :wincmd l<CR>

" Save to Session.vim. The following is not working
" nnoremap <lead>q :mks!<CR> :q<CR>

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

" vim-which-key configuration
nnoremap <silent> <leader> :<c-u>WhichKey ','<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual ','<CR>
set timeoutlen=500

" Define which-key dictionary
let g:which_key_map = {}

" Tab navigation group
let g:which_key_map['1'] = 'tab-1'
let g:which_key_map['2'] = 'tab-2'
" let g:which_key_map['3'] = 'tab-3'
" let g:which_key_map['4'] = 'tab-4'
" let g:which_key_map['5'] = 'tab-5'
" let g:which_key_map['6'] = 'tab-6'
" let g:which_key_map['7'] = 'tab-7'
" let g:which_key_map['8'] = 'tab-8'
" let g:which_key_map['9'] = 'tab-9'
let g:which_key_map['0'] = 'tab-last'
let g:which_key_map['n'] = 'tab-next'
let g:which_key_map['p'] = 'tab-prev'
let g:which_key_map[','] = 'tab-next'
let g:which_key_map['new'] = 'new-tab'
let g:which_key_map['lt'] = 'last-active-tab'

" Files and buffers
let g:which_key_map['a'] = 'ag-search'
let g:which_key_map['b'] = 'buffer-list'
let g:which_key_map['bb'] = 'last-buffer'
let g:which_key_map['d'] = 'nerdtree-toggle'
let g:which_key_map['f'] = 'nerdtree-find'
let g:which_key_map['t'] = 'ctrlp'
let g:which_key_map['T'] = 'ctrlp-clear'

" Copy paths
let g:which_key_map.c = {
      \ 'name' : '+copy-paths',
      \ 'r' : 'relative-path',
      \ 'a' : 'absolute-path',
      \ 'f' : 'filename',
      \ 'd' : 'directory',
      \ 'o' : 'quickfix-open',
      \ 'c' : 'quickfix-close',
      \ 't' : 'close-tab',
      \ }

" Git
let g:which_key_map.g = {
      \ 'name' : '+git',
      \ 'd' : 'diff',
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

" Window management
let g:which_key_map.t = {
      \ 'name' : '+tabs',
      \ 'f' : 'move-tab-first',
      \ 'l' : 'move-tab-left',
      \ 'r' : 'move-tab-right',
      \ }

let g:which_key_map.m = {
      \ 'name' : '+move/maximize',
      \ 'n' : 'move-next-tab',
      \ 'p' : 'move-prev-tab',
      \ }

" Testing (rubytest)
let g:which_key_map['\'] = 'run-test'
let g:which_key_map['['] = 'run-file'
let g:which_key_map['/'] = 'run-last-test'

" Other
let g:which_key_map['l'] = 'align'
let g:which_key_map['j'] = 'down-10'
let g:which_key_map['k'] = 'up-10'
let g:which_key_map['h'] = 'window-left'
let g:which_key_map[']'] = 'tagbar-toggle'
let g:which_key_map[' '] = 'strip-whitespace'
let g:which_key_map['V'] = 'reload-vimrc'
let g:which_key_map['"'] = 'quote-word'
let g:which_key_map["'"] = 'single-quote-word'

" Register the dictionary
call which_key#register(',', "g:which_key_map")

" vim-which-key styling
let g:which_key_use_floating_win = 0
let g:which_key_max_size = 0
let g:which_key_position = 'botright'
let g:which_key_vertical = 0

" Custom colors for which-key
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Better color scheme for which-key window
highlight WhichKey guifg=#61afef ctermfg=75
highlight WhichKeySeperator guifg=#98c379 ctermfg=114
highlight WhichKeyGroup guifg=#c678dd ctermfg=176
highlight WhichKeyDesc guifg=#abb2bf ctermfg=249
highlight WhichKeyFloating guibg=#282c34 ctermbg=235


