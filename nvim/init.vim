" Shovel's init.vim file (<visla.vvi@gmail.com>)
"
" TODO unmap S from sneak to default
" TODO grepping http://ellengummesson.com/blog/2015/08/01/dropping-ctrlp-and-other-vim-plugins/
" TODO autoformat js code by paragraph. https://github.com/prettier/prettier-eslint

" plugins {{{
call plug#begin('~/.config/nvim/plugged')

Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ntpeters/vim-better-whitespace'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/syntastic'
Plug 'dag/vim-fish'
Plug 'tommcdo/vim-exchange'
Plug 'prendradjaja/vim-vertigo'

" symlinked
Plug 'shofel/syntastic-local-js-checkers'

" trying right now
" Plug 'janko-m/vim-test'
" Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
" Plug 'justinmk/vim-sneak'
Plug 'jez/vim-superman'

" javascript
" Plug 'Shougo/deoplete.nvim'
" Plug 'carlitux/deoplete-ternjs'
" Plug 'ternjs/tern_for_vim' " needs 'npm i' inside of the cloned repo
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'gutenye/json5.vim'

" html and templates
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'mattn/emmet-vim'

" Clojure and Lisps
Plug 'bhurlow/vim-parinfer'
Plug 'tpope/vim-fireplace'

" colors
Plug 'joshdick/onedark.vim'
Plug 'altercation/vim-colors-solarized'
" Plug 'sjl/badwolf'
" Plug 'junegunn/seoul256.vim'
" other nice colorschemes: obsidian tomorrow-night-bright monokai

call plug#end()
" }}}

" general {{{
set number " see also vim-numbertoggle plugin
set hidden
set list
set fdm=marker

set nobackup
set noswapfile

set smartindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0 " block cursor always

" russian
set keymap=russian-dvorak
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
" }}}

" colors {{{
colorscheme onedark

" fix up diff colors
hi DiffAdd          ctermbg=235  ctermfg=108  guibg=#262626 guifg=#c8e6c9 cterm=reverse        gui=reverse
hi DiffChange       ctermbg=235  ctermfg=103  guibg=#262626 guifg=#8787af cterm=reverse        gui=reverse
hi DiffDelete       ctermbg=235  ctermfg=131  guibg=#262626 guifg=#ffcdd2 cterm=reverse        gui=reverse
hi DiffText         ctermbg=235  ctermfg=108  guibg=#262626 guifg=#c8e6c9 cterm=reverse        gui=reverse

" }}}

" syntax and filetypes {{{
let g:javascript_plugin_flow = 1
augroup initvim
  autocmd!

  " Javascript
  autocmd BufRead,BufNewFile *.js.flow setfiletype javascript
  autocmd BufRead,BufNewFile *.js set commentstring=/*\ %s\ */
  autocmd BufRead,BufNewFile *.js let b:textwidth=80
  autocmd BufRead,BufNewFile *.js let b:textwidth=80

  autocmd BufWritePre * StripWhitespace
  autocmd BufRead,BufNewFile *.njk setfiletype jinja
  autocmd BufRead,BufNewFile *.nj setfiletype jinja
  autocmd Filetype text let b:AutoPairs = {'"(': '")'}
  autocmd Filetype clojure let b:AutoPairs = {'"': '"'}
  autocmd Filetype clojure nnoremap <buffer> <Leader>e :Eval<Return>
  autocmd TermOpen * setlocal nonumber | setlocal norelativenumber
augroup END
" }}}

" keys {{{
" helper function to swap the option between x and y values
fun! SwapVal (name, x, y)
  execute 'let '.a:name.' = {'.a:x.':'.a:y.', '.a:y.':'.a:x.'}['.a:name.']'
endfun

let mapleader="\<Space>"

" ctrl-s
nnoremap <c-s> :w<Return>
nnoremap <Leader>s :w<Return>
inoremap <c-s> <c-o>:w<Return>
" edit .vimrc
nnoremap <Leader>ev :e $MYVIMRC<Return>
nnoremap <Leader>sv :source $MYVIMRC<Return>
" quickfix window
nnoremap <Leader>q :copen<Return>
nnoremap <Leader>Q :cclose<Return>
nnoremap <Leader>d :TernDef<Return>
" folding
nnoremap <Leader>zs :call SwapVal('&foldcolumn', 0, 4)<cr>
" execute command
nnoremap <Leader>; :

" grep with K
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" windows

" basic movements
nnoremap <Leader>wl  <C-w><C-l>
nnoremap <Leader>wh  <C-w><C-h>
nnoremap <Leader>wj  <C-w><C-j>
nnoremap <Leader>wk  <C-w><C-k>

" some commands
nnoremap <Leader>wt  <C-w>T
nnoremap <Leader>wq  <C-w>c
nnoremap <Leader>wz  ZZ

" tabs
nnoremap <Leader>tl gt
nnoremap <Leader>th gT
nnoremap <Leader>te :tabe<Space>

" buffers
nnoremap <Leader>bw :bwipeout!
nnoremap <Leader>b<Space> :b<Space>

" git
nnoremap <Leader>gs :Gstatus<Return>
nnoremap <Leader>gp :Gpush<Return>
nnoremap <Leader>gr :SignifyRefresh<Return>

"
nnoremap <Up> {
vnoremap <Up> {
nnoremap <Down> }
vnoremap <Down> }

" Mouse clipboard: yank and print.
" TODO to work with motions etc.
vnoremap <Leader>y "*y<Return>
nnoremap <Leader>p "*]p<Return>

" in terminal
" http://neovim.io/doc/user/nvim_terminal_emulator.html
tnoremap <Esc> <C-\><C-n>

" vim-vertigo
let g:Vertigo_homerow = 'aoeuidhtns'
nnoremap <silent> <Leader>j :<C-U>VertigoDown n<CR>
vnoremap <silent> <Leader>j :<C-U>VertigoDown v<CR>
onoremap <silent> <Leader>j :<C-U>VertigoDown o<CR>
nnoremap <silent> <Leader>k :<C-U>VertigoUp n<CR>
vnoremap <silent> <Leader>k :<C-U>VertigoUp v<CR>
onoremap <silent> <Leader>k :<C-U>VertigoUp o<CR>
" }}}

" syntastic {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint', 'flow']
let g:syntastic_local_javascript_checkers_politeness = 1
" }}}

" Signify {{{
let g:signify_vcs_list = [ 'git', 'hg' ]
let g:signify_realtime = 0
" }}}

" various plugins {{{
let g:deoplete#enable_at_startup = 1
let NERDSpaceDelims=1
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let test#strategy = "dispatch"
" }}}

" search and replace {{{
set ignorecase
set smartcase
set incsearch
set inccommand=nosplit
nnoremap <Leader>n :nohlsearch<cr>
nnoremap / /\v
" }}}

" The Silver Searcher {{{
" @see https://robots.thoughtbot.com/faster-grepping-in-vim
if executable('ag')
  " Use ag over :grep
  set grepprg=ag

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif
" }}}

" vim: set fdm=marker :
