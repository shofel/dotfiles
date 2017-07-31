" Shovel's init.vim file (<visla.vvi@gmail.com>)
" plugins {{{
call plug#begin('~/.config/nvim/plugged')

Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'kien/ctrlp.vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ntpeters/vim-better-whitespace'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdcommenter'
Plug 'dag/vim-fish'

" symlinked
Plug 'shofel/syntastic-local-js-checkers'

" trying right now
Plug 'tommcdo/vim-exchange'
Plug 'janko-m/vim-test'
Plug 'tpope/vim-dispatch'

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

" syntax and filetypes {{{
colorscheme onedark
let g:javascript_plugin_flow = 1
augroup initvim
  autocmd!
  autocmd BufRead,BufNewFile *.js.flow setfiletype javascript
  autocmd BufWritePre * StripWhitespace
  autocmd BufRead,BufNewFile *.njk setfiletype jinja
  autocmd BufRead,BufNewFile *.nj setfiletype jinja
  autocmd Filetype clojure let b:AutoPairs = {'"': '"'}
  autocmd Filetype clojure nnoremap <buffer> <Leader>e :Eval<Return>
augroup END
" }}}

" keys {{{
" helper function to swap the option between x and y values
fun! SwapVal (name, x, y)
  execute 'let '.a:name.' = {'.a:x.':'.a:y.', '.a:y.':'.a:x.'}['.a:name.']'
endfun

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
" open buffer
nnoremap <Leader>b :b<Space>
" folding
nnoremap <Leader>zs :call SwapVal('&foldcolumn', 0, 4)<cr>

" ctrlp meets stumpwm
let g:ctrlp_prompt_mappings = { 'AcceptSelection("t")': ['<a-t>'] }

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
