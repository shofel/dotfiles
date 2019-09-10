" Shovel's init.vim file (<visla.vvi@gmail.com>)
"
" TODO unmap S from sneak to default
" TODO grepping http://ellengummesson.com/blog/2015/08/01/dropping-ctrlp-and-other-vim-plugins/
" TODO autoformat js code by paragraph. https://github.com/prettier/prettier-eslint

" plugins {{{
call plug#begin('~/.config/nvim/plugged')

" tpope
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'

" appearance
Plug 'mhinz/vim-signify'
Plug 'itchyny/lightline.vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" more editing
Plug 'tommcdo/vim-exchange'
Plug 'prendradjaja/vim-vertigo'
Plug 'jiangmiao/auto-pairs'

" follow conventions
Plug 'ntpeters/vim-better-whitespace'
Plug 'editorconfig/editorconfig-vim'

" search files and inside files
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mileszs/ack.vim'

" Languages
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'

" trying right now TODO cleanup
" Plug 'janko-m/vim-test'
" Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'jez/vim-superman'

" javascript
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'gutenye/json5.vim'
Plug 'posva/vim-vue'
Plug 'ap/vim-css-color'

" html and templates
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'mattn/emmet-vim'

" Clojure and Lisps
Plug 'guns/vim-sexp',    {'for': 'clojure'}
Plug 'tpope/vim-fireplace',    {'for': 'clojure'}

" Python
" Plug 'idanarye/vim-vebugger'
Plug 'vim-python/python-syntax'
Plug 'vim-scripts/indentpython.vim'
Plug 'tweekmonster/django-plus.vim'

" Go lang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" my favourite colors
Plug 'https://github.com/shofel/vim-two-firewatch.git' " my fork
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'rakr/vim-one' " one

" dark themes
" Plug 'joshdick/onedark.vim'
" Plug 'ErichDonGubler/vim-sublime-monokai'
" Plug 'abra/vim-obsidian'

" a framework and a huge collection of themes
" Plug 'chriskempson/base16-vim'

" also good colors
" Plug 'frankier/neovim-colors-solarized-truecolor-only'
" Plug 'NLKNguyen/papercolor-theme' " PaperColor
" Plug 'rakr/vim-colors-rakr'

" colorschemes without colors
" Plug 'yankcrime/direwolf'
" Plug 'endel/vim-github-colorscheme'
" Plug 'reedes/vim-colors-pencil'

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
set guicursor=n-v-ve:block,i-c-ci-cr:ver100,o-r:hor100

" to not duplicate lightline
set noshowmode

" russian
set keymap=russian-dvorak
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
" }}}

" colors {{{

let g:lightline = {
\ 'colorscheme': 'one'}

" tune colorschemes
let g:quantum_italics=1
let g:quantum_black=1
let g:one_allow_italics = 1
let g:two_firewatch_italics=1

" init colors
set background=light
set termguicolors
colorscheme two-firewatch

" the better diff colors
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

" abbreviations {{{
abbr retrun return
" }}}

" keys {{{
" helper function to swap the option between x and y values
fun! SwapVal (name, x, y)
  execute 'let '.a:name.' = {'.a:x.':'.a:y.', '.a:y.':'.a:x.'}['.a:name.']'
endfun

let mapleader="\<Space>"

" write file
nnoremap <Leader>s :w<Return>
" edit .vimrc
nnoremap <Leader>ev :e $MYVIMRC<Return>
nnoremap <Leader>vs :source $MYVIMRC<Return>

" execute visually selected text
vnoremap <F6> y:"

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
nnoremap <Leader>tt :b term<Tab><Return>i

" git
nnoremap <Leader>gs :Gstatus<Return>
nnoremap <Leader>ga :Gwrite<Return>
nnoremap <Leader>gp :Gpush<Return>
nnoremap <Leader>gr :SignifyRefresh<Return>

"
onoremap <Up> {
nnoremap <Up> {
vnoremap <Up> {
onoremap <Down> }
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

" Asynchronous Lint Engine {{{

" Always show the list when there are some errors
let g:ale_open_list = 1

let g:ale_linters = {
\ "javascript": ['flow-language-server', 'eslint', 'standard', 'xo']
\}

"More goodness of language servers.
let g:ale_completion_enabled = 1
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

  " ack.vim
  let g:ackprg = 'ag --vimgrep --smart-case'
  cnoreabbrev Ag Ack

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif
" }}}

" vim: set fdm=marker :
