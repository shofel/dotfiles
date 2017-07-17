" Shovel's init.vim file (<visla.vvi@gmail.com>)

" plugins {{{
call plug#begin('~/.config/nvim/plugged')

Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'kien/ctrlp.vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ntpeters/vim-better-whitespace'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/syntastic'
Plug 'shofel/syntastic-local-eslint.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'dag/vim-fish'

" trying right now
Plug 'tommcdo/vim-exchange'

" javascript
" Plug 'Shougo/deoplete.nvim'
" Plug 'carlitux/deoplete-ternjs'
Plug 'ternjs/tern_for_vim' " needs 'npm i' inside of the cloned repo
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'gutenye/json5.vim'

" html and templates
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'mattn/emmet-vim'

" Clojure and Lisps
Plug 'guns/vim-clojure-static'
Plug 'bhurlow/vim-parinfer'
Plug 'tpope/vim-fireplace'

" colors
Plug 'joshdick/onedark.vim'
Plug 'sjl/badwolf'
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
set softtabstop=2
set shiftwidth=2

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0 " block cursor always
" }}}

" syntax and filetypes {{{
colorscheme onedark
let g:javascript_plugin_flow = 1
augroup initvim
  autocmd!
  autocmd BufWritePre * StripWhitespace
  autocmd BufRead,BufNewFile *.njk setfiletype jinja
  autocmd BufRead,BufNewFile *.nj setfiletype jinja
  autocmd Filetype clojure let b:AutoPairs = {'"': '"'}
  autocmd Filetype clojure nnoremap <buffer> <Leader>e :Eval<Return>
augroup END
" }}}

" keys {{{
let mapleader="\<Space>"
" esc
" inoremap <Leader>' <Esc>
" vnoremap <Leader>' <Esc>
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
" }}}

" syntastic {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_flow_exec = 'flow' " eslint_exec: see shofel/syntastic-local-eslint.vim
let g:syntastic_javascript_checkers = ['eslint', 'flow'] " requires them to be installed
" }}}

" various plugins {{{
let g:deoplete#enable_at_startup = 1
let NERDSpaceDelims=1
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
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

