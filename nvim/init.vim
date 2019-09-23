" Shovel's init.vim file (<visla.vvi@gmail.com>)

" TODO fzf-preview https://github.com/yuki-ycino/fzf-preview.vim
" TODO fzf: use the git repo of the current file

" plugins {{{
call plug#begin('~/.config/nvim/plugged')

" read local .vimrc files
Plug 'MarcWeber/vim-addon-local-vimrc'

" tpope
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'

" appearance
Plug 'mhinz/vim-signify'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" more editing
Plug 'tommcdo/vim-exchange'
Plug 'jiangmiao/auto-pairs'

" follow conventions
Plug 'ntpeters/vim-better-whitespace'
Plug 'editorconfig/editorconfig-vim'

" search files and inside files
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'dbakker/vim-projectroot'

" Testing
Plug 'janko-m/vim-test'

" Languages
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'georgewitteman/vim-fish'

" trying right now
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-eunuch'
Plug 'jez/vim-superman'

" javascript
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'posva/vim-vue'
Plug 'ap/vim-css-color'

" html and templates
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'mattn/emmet-vim'

" Clojure and Lisps
Plug 'guns/vim-sexp',    {'for': 'clojure'}
Plug 'tpope/vim-fireplace',    {'for': 'clojure'}

" Python TODO clean up and review
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
set signcolumn=yes
set nonumber " see also vim-numbertoggle plugin
set hidden
set list
set fdm=marker

set nobackup
set noswapfile
set updatetime=300 " set for vim-signify active mode

set smartindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set guicursor=n-v-ve:block,i-c-ci-cr:ver100,o-r:hor100

set noshowmode " to not duplicate lightline
set showtabline=2

" russian
set keymap=russian-dvorak
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
" }}}

" colors {{{

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
  autocmd BufRead,BufNewFile *.js let b:commentary_format = "/* %s */"
  autocmd BufRead,BufNewFile *.js let b:textwidth=80
  autocmd BufRead,BufNewFile *.js let b:textwidth=80

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
nnoremap <Leader>ve :tabe $MYVIMRC<Return>
nnoremap <Leader>vs :source $MYVIMRC<Return>

" get to execute visually selected text
vnoremap <F6> y:"

" edit code
nnoremap <Leader>fs :StripWhitespace<Return>
nnoremap <Leader>fe :ALEFix<Return>
nnoremap <Leader>fj :ALENextWrap<Return>
nnoremap <M-s> :set number! relativenumber!<Return>

" quickfix window
nnoremap <Leader>q :copen<Return>
nnoremap <Leader>Q :cclose<Return>
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
nnoremap <Leader>o   :only<Return>
nnoremap <Leader>wq  <C-w>c
nnoremap <Leader>bK  :bwipeout!<Return>

" tabs
nnoremap <Leader>tk gt
nnoremap <Leader>tj gT
nnoremap <Leader>te :tabe<Space>

" git
nnoremap <Leader>gs :Gstatus<Return>
nnoremap <Leader>ga :Gwrite <CR>:sleep 1m<CR>: SignifyRefresh<Return>
nnoremap <Leader>gp :Gpush<Return>
nnoremap <Leader>c  :checkt<Return>

" skip empty lines, when navigating with arrows
onoremap <Up> {
nnoremap <Up> {
vnoremap <Up> {
onoremap <Down> }
nnoremap <Down> }
vnoremap <Down> }

" Mouse clipboard: yank and print.
" TODO make an opeartor to enable motions.
vnoremap <Leader>y "*y<Return>
nnoremap <Leader>p "*]p<Return>

" in terminal
" @see http://neovim.io/doc/user/nvim_terminal_emulator.html
" @see https://github.com/junegunn/fzf.vim/issues/544
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<c-g>" : "<c-\><c-n>"

" close with `q`
augroup ShovelClose_q
  autocmd Filetype help nnoremap <buffer> q :close<CR>
augroup END
" }}}

" Asynchronous Lint Engine {{{

" Always show the list when there are some errors
let g:ale_linters = {
\ 'javascript': ['flow-language-server', 'eslint'],
\ 'python': ['pyflakes', 'pyls', 'mypy', 'pylint'],
\}
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'python': [],
\}

"More goodness of language servers.
let g:ale_completion_enabled = 1
" }}}

" Lightline {{{
let g:lightline = {}

let g:lightline.colorscheme = 'one'

" ALE integration
let g:lightline.component_expand = {
\  'linter_checking': 'lightline#ale#checking',
\  'linter_warnings': 'lightline#ale#warnings',
\  'linter_errors': 'lightline#ale#errors',
\  'linter_ok': 'lightline#ale#ok',
\ }
let g:lightline.component_type = {
\     'linter_checking': 'left',
\     'linter_warnings': 'warning',
\     'linter_errors': 'error',
\     'linter_ok': 'left',
\ }
let g:lightline#ale#indicator_checking = "..."
let g:lightline#ale#indicator_warnings = "W:"
let g:lightline#ale#indicator_errors = "E:"
let g:lightline#ale#indicator_ok = " ✔ "

" assemble the status line

let g:lightline.active = {
      \ 'left': [ [ 'mode', 'paste' ],
      \           [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \           [ 'filename', 'readonly' ] ],
      \ 'right': [ [ 'lineinfo' ],
      \            [ 'percent' ],
      \            [ 'fileformat', 'fileencoding', 'filetype' ] ] }
let g:lightline.inactive = {
      \ 'left': [ [ 'filename' ] ],
      \ 'right': [ [ 'lineinfo' ],
      \            [ 'percent' ] ] }
let g:lightline.tabline = {
      \ 'left': [ [ 'tabs' ] ],
      \ 'right': [ [ 'close' ] ] }
" }}}

" Signify {{{
let g:signify_vcs_list = [ 'git', 'hg' ]
let g:signify_realtime = 1
" }}}

" various plugins {{{
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

" fzf {{{
" @depends_on: fdfind:  https://github.com/sharkdp/fd
" @depends_on: ripgrep: https://github.com/BurntSushi/ripgrep

" https://github.com/junegunn/fzf.vim/commit/29db9ea1408d6cdaeed2a8b212fb3896392a8631
" let g:fzf_buffers_jump = 1

" Files
function! Shofel_fzf_Files()
  call fzf#run(fzf#wrap('files',
      \ {'source': 'fdfind --type=file --hidden --no-ignore',
      \  'dir': projectroot#get() }))
endfunction

" GFiles
function! Shofel_fzf_GFiles()
  call fzf#run(fzf#wrap('gfiles',
      \ {'source': 'fdfind --type=file',
      \  'dir': projectroot#get() }))
endfunction

" Rg with preview
" @see https://sidneyliebrand.io/blog/how-fzf-and-ripgrep-improved-my-workflow
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..', 'dir': projectroot#get()}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..', 'dir': projectroot#get()}, 'right:50%:hidden', '?'),
  \   <bang>0)

nnoremap <C-p> :call Shofel_fzf_GFiles()<Return>
command! PFiles call Shofel_fzf_Files()

nnoremap <Leader>bm :Buffers<Return>
nnoremap <Leader>/ :BLines

nnoremap <Leader>wm :Windows<Return>
" }}}

" terminals {{{

function! Shofel_terminal(label)
endfunction

command! -nargs=? Terminal
      \ call termopen(&shell . ' ;# ' . <q-args>)

nnoremap <Leader>T :Terminal 
" }}}

" sneak {{{
nmap <Leader>j <Plug>Sneak_s
nmap <Leader>k <Plug>Sneak_S
" }}}

" vim: set fdm=marker :
