" Shovel's init.vim file (<visla.vvi@gmail.com>)

" TODO key to go to github page of plugin

" plugins {{{
call plug#begin('~/.config/nvim/plugged')

" read local .vimrc files
Plug 'MarcWeber/vim-addon-local-vimrc'

" tpope
" TODO https://github.com/tpope/vim-projectionist
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" appearance
Plug 'mhinz/vim-signify'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" more editing
Plug 'tommcdo/vim-exchange'
Plug 'jiangmiao/auto-pairs'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'justinmk/vim-sneak'

" follow conventions
Plug 'editorconfig/editorconfig-vim'

" search files and inside files
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'dbakker/vim-projectroot'

" Testing
Plug 'janko-m/vim-test'

" Git
Plug 'junegunn/gv.vim', {'on': 'GV'}
Plug 'rhysd/git-messenger.vim'

" Lang
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'georgewitteman/vim-fish'
Plug 'Junegunn/vader.vim'

" draw ascii diagrams
Plug 'gyim/vim-boxdraw'

" embed to browser
Plug 'glacambre/firenvim'

" trying right now
Plug 'jez/vim-superman'
Plug 'rhysd/reply.vim'

" markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

" javascript
" TODO https://www.npmjs.com/package/eslint-pretty
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'posva/vim-vue'
Plug 'RRethy/Vim-hexokinase', { 'do': 'make hexokinase' }

" html and templates
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'mattn/emmet-vim'

" Clojure and Lisps
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

" {{{ alternative colors
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
" }}}

call plug#end()
" }}}

" general {{{
set encoding=utf-8
scriptencoding=utf-8

set signcolumn=yes
set nonumber " see also vim-numbertoggle plugin
set hidden
set list
set foldmethod=marker

set nobackup
set noswapfile
set updatetime=300 " set for vim-signify active mode

" default indentation settings
set smartindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

set guicursor=n-v-ve:block,i-c-ci-cr:ver100,o-r:hor100
set mouse=a

set noshowmode " to not duplicate lightline
set showtabline=2

" russian
set keymap=russian-dvorak
set iminsert=0
set imsearch=0
" }}}

" colors {{{

" tune colorschemes
let g:quantum_italics=1
let g:quantum_black=1
let g:one_allow_italics = 1
let g:two_firewatch_italics=1

" init colors
if (!v:vim_did_enter)
  set background=light
  set termguicolors
  colorscheme two-firewatch
endif

" hide tildas after the end of file
highlight EndOfBuffer guifg=bg guibg=none

" bold exchange.vim
highlight link ExchangeRegion Folded
" }}}

" syntax and filetypes {{{
let g:javascript_plugin_flow = 1
augroup initvim
  autocmd!

  " Javascript
  autocmd BufRead,BufNewFile *.js.flow setfiletype javascript
  autocmd Filetype javascript let b:commentary_format = "/* %s */"
  autocmd Filetype javascript let b:textwidth=80
  autocmd Filetype javascript nnoremap <buffer> K :!x-www-browser mdn.io/<c-r><c-w>
  autocmd Filetype typescript nnoremap <buffer> K :!x-www-browser mdn.io/<c-r><c-w>
  autocmd Filetype javascript nnoremap <buffer> <Leader>r :Dispatch yarn ava %<cr>

  autocmd Filetype clojure let b:AutoPairs = {'{':'}', '(':')', '"':'"'}
  autocmd Filetype clojure nnoremap <buffer> <Leader>r :Dispatch lein run<cr>
  autocmd Filetype clojure nnoremap <buffer> <Leader>e :Eval<cr>

  autocmd TermOpen * setlocal nonumber | setlocal norelativenumber
augroup END
" }}}

" vman {{{
function! s:vmanSettings()
  setlocal signcolumn=no
  setlocal showtabline=0
  setlocal ruler
  nnoremap <buffer> q <cmd>q!<cr>
endfunction

augroup vmanSettings
  autocmd Filetype man call s:vmanSettings()
augroup END
" }}}

" abbreviations {{{
abbr retrun return
" }}}

" keys {{{

let mapleader="\<Space>"
let maplocalleader="\<Space>l"

" edit .vimrc
nnoremap <Leader>ve :tabe $MYVIMRC<Return>
nnoremap <Leader>vs :source $MYVIMRC<Return>

" get to execute visually selected text
vnoremap <F6> y:"

" TODO leverage more from LSP
nnoremap <Leader>fe :ALEFix<Return>
nnoremap <Leader>fd :ALEGoToDefinition<Return>
nnoremap <Leader>fr :ALEFindReferences<Return>
nnoremap <M-s> :set number! relativenumber!<Return>

" emmet {{{
let g:user_emmet_install_global = 0

augroup ShovelEmmet
  autocmd FileType css EmmetInstall
  autocmd FileType html EmmetInstall
  autocmd FileType htmldjango EmmetInstall
augroup END
" }}}

" Switch tabs and windows.
" Tabs : <Leader>+number
" Windows : <Leader>+arrow

" switch tab {{{
nnoremap <Leader>1 :tabn 1<Return>
nnoremap <Leader>2 :tabn 2<Return>
nnoremap <Leader>3 :tabn 3<Return>
nnoremap <Leader>4 :tabn 4<Return>
nnoremap <Leader>5 :tabn 5<Return>
nnoremap <Leader>6 :tabn 6<Return>
nnoremap <Leader>7 :tabn 7<Return>
nnoremap <Leader>8 :tabn 8<Return>
nnoremap <Leader>9 :tabn 9<Return>
" }}}

" switch window {{{
nnoremap <Leader><Left>  <C-w><C-h>
nnoremap <Leader><Right> <C-w><C-l>
nnoremap <Leader><Down>  <C-w><C-j>
nnoremap <Leader><Up>    <C-w><C-k>
" }}}

" some commands
nnoremap <Leader>s   :w<Return>
nnoremap <Leader>o   :only<Return>
nnoremap <Leader>kk  :bwipeout!<Return>

" git & bufsync
nnoremap <Leader>gs :vert Gstatus<Return>
nnoremap <Leader>ga :Gwrite <CR>:sleep 1m<CR>: SignifyRefresh<Return>
nnoremap <Leader>gp :Gpush<Return>
nnoremap <Leader>gP :Git push --force-with-lease<Return>
nnoremap <Leader>gb <cmd>echo 'git branch:' ShovelGitBranch()<cr>
nnoremap <Leader>gv <cmd>call Shovel_glog()<cr>
nnoremap <Leader>gV :GV!<Return>

" TODO sum GV and glog
function! Shovel_glog() abort
  exe('tabe +term\ glog')
  exe('setlocal bufhidden=wipe')
  exe('tnoremap <buffer> q <c-\><c-n><c-w>c')
  exe('startinsert')
endfun

" Navigate by signs in signcolumn
nnoremap <Leader>jl <cmd>ALENextWrap<cr>
nnoremap <Leader>kl <cmd>ALEPreviousWrap<cr>
nmap     <Leader>kc <Plug>(signify-prev-hunk)
nmap     <Leader>jc <Plug>(signify-next-hunk)

nnoremap <Leader>gd :SignifyHunkDiff<cr>

augroup shovel-fugitive
  autocmd Filetype fugitive nmap <buffer> s <Plug>Sneak_s
  autocmd Filetype fugitive nmap <buffer> S <Plug>Sneak_S
  autocmd Filetype git      nmap <buffer>   <Up> <c-p>
  autocmd Filetype git      nmap <buffer> <Down> <c-n>
  autocmd Filetype GV       nmap <buffer>   <Up> <c-p>
  autocmd Filetype GV       nmap <buffer> <Down> <c-n>
augroup END

nnoremap <Leader>c  :checkt<Return>
nnoremap <Leader>s  :write<Return>

" skip empty lines, when navigating with arrows
onoremap <Up> {
nnoremap <Up> {
vnoremap <Up> {
onoremap <Down> }
nnoremap <Down> }
vnoremap <Down> }

" X buffers.
" TODO make an opeartor to enable motions.
" X clipboard
xnoremap <Leader>y "+y<Return>
nnoremap <Leader>p "+]p<Return>
xnoremap <Leader>p "+]p<Return>
" X selection
xnoremap <Leader>Y "*y<Return>
nnoremap <Leader>P "*]p<Return>
xnoremap <Leader>P "*]p<Return>

" in terminal
" @see http://neovim.io/doc/user/nvim_terminal_emulator.html
" @see https://github.com/junegunn/fzf.vim/issues/544
" map <c-g> for fzf is because it closes fzf window faster than <Esc>.
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<c-g>" : "<c-\><c-n>"

" Git messager
nnoremap <Leader>gm <cmd>GitMessenger<cr>
" }}}

" ALE Asynchronous Lint Engine {{{

" @see https://github.com/dense-analysis/ale/issues/1700#issuecomment-402807012
set completeopt+=noinsert

" Python
let g:ale_python_auto_pipenv= 1

" Linters and fixers.
let g:ale_linters = {}
let g:ale_fixers = {}

let g:ale_linters.python = ['pylint', 'pyls']
let g:ale_fixers.python = []

let g:ale_linters.javascript = ['flow-language-server', 'eslint']
" TODO use importjs separately. I suspect performance issue here.
let g:ale_fixers.javascript = ['eslint', 'importjs']

let g:ale_linters.fish = []

"More goodness of language servers.
let g:ale_completion_enabled = 1
" }}}

" Lightline {{{
let g:lightline = {}

let g:lightline.colorscheme = 'one'

" ALE integration
"
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

let g:lightline#ale#indicator_checking = '...'
let g:lightline#ale#indicator_warnings = 'W:'
let g:lightline#ale#indicator_errors = 'E:'
let g:lightline#ale#indicator_ok = ' ✔ '

let s:linter_components = [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]

" Git

cabbrev  Gfa Git fetch --all --prune --tags
cabbrev  Gclean Git clean -fd
cabbrev  Gpushup Git push -u origin
command! Ghash echo ShovelGitHash()

function! ShovelGitHash ()
  let l:_ = system('git rev-parse --short HEAD')
  return substitute(l:_, '^\(\w\+\).*', '\1', '')
endfunc

" @param first line of `git status --short`
function! ShovelGitParseBranch (x)
  let l:_ = split(a:x)[1]
  return substitute(l:_, '\([^.]\{-}\)\.\{3}.*$', '\1', '')
endfunc

function! ShovelGitUnsyncStatus (x)
  let l:x = a:x

  " Sample inputs for tests.
  " let l:x = '## master...origin/master [ahead 4]^@'
  " let l:x = '## master...origin/master [behind 4]^@'
  " let l:x = '## xmas...origin/xmas^@'

  let l:uptodate = -1 == match(l:x, '\(ahead\|behind\)')

  if (l:uptodate)
    return ''
  endif

  " Arrow and number.
  let l:_ = substitute(l:x, '^[^[]\{-}\[\(ahead\|behind\) \(\d\+\)\].*$', '\1 \2', '')
  let [l:arrow, l:number] = split(l:_)
  let l:arrow = get({'ahead': '↑', 'behind': '↓'}, l:arrow, '')

  " Branch name.
  let l:branch = ShovelGitParseBranch(l:x)

  " Concat together.
  return l:branch .' '. l:arrow . l:number
endfunc

function ShovelGitRawStatus ()
  return system('git status --short --branch | head -n 1')
endfunc

function! ShovelGitStatusLine ()
  return ShovelGitUnsyncStatus(ShovelGitRawStatus())
endfunc

function! ShovelGitBranch ()
  return ShovelGitParseBranch(ShovelGitRawStatus())
endfunc

let g:lightline.component_expand.gitstatus = 'ShovelGitStatusLine'
let g:lightline.component_type.gitstatus = 'error'

" assemble the status line

let g:lightline.active = {
      \ 'left': [ [ 'mode', 'paste' ] +
      \             s:linter_components,
      \           [ 'gitstatus' ],
      \           [ 'filename', 'readonly' ] ],
      \ 'right': [ [ 'lineinfo' ],
      \            [ 'percent' ],
      \            [ 'filetype' ] ] }
let g:lightline.inactive = {
      \ 'left': [ [ 'filename' ] ],
      \ 'right': [ [ 'lineinfo' ],
      \            [ 'percent' ] ] }
let g:lightline.tabline = {
      \ 'left': [ [ 'tabs' ] ],
      \ 'right': [ [ 'close' ] ] }
" }}}

" Refresh when reloading
if (v:vim_did_enter)
  call lightline#init()
  call lightline#update()
endif

" Signify {{{
let g:signify_vcs_list = [ 'git', 'hg' ]
let g:signify_realtime = 1

omap ic <Plug>(signify-motion-inner-pending)
xmap ic <Plug>(signify-motion-inner-visual)
omap ac <Plug>(signify-motion-outer-pending)
xmap ac <Plug>(signify-motion-outer-visual)
" }}}

" various plugins {{{
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let test#strategy = 'dispatch'
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
" @see https://www.freecodecamp.org/news/fzf-a-command-line-fuzzy-finder-missing-demo-a7de312403ff/
"
" Changes
" - search files in git repo of the current file
"   (Files->PFiles, GFiles->PGFiles, Rg)
" - Rg: with preview
" - Commits: the way fzf.vim determines gitroot is unmodifiable :/
"
" These changes depend on
" - fdfind:  https://github.com/sharkdp/fd
" - ripgrep: https://github.com/BurntSushi/ripgrep
" TODO Fixup sticky comments on i_o.

if (!executable('fd'))  | echoerr 'fd (fd-find) executable not found'  | endif
if (!executable('rg')) | echoerr 'rg (ripgrep) executable not found' | endif
" https://github.com/junegunn/fzf.vim/commit/29db9ea1408d6cdaeed2a8b212fb3896392a8631
" let g:fzf_buffers_jump = 1

" Files inside gitroot of the current file.
function! PFiles()
  call fzf#run(fzf#wrap('files',
      \ {'source': 'fd --type=file --hidden --no-ignore',
      \  'dir': projectroot#get() }))
endfunction

" GFiles inside gitroot of the current file.
function! PGFiles()
  call fzf#run(fzf#wrap('gfiles',
      \ {'source': 'fd --type=file',
      \  'dir': projectroot#get() }))
endfunction

" Rg with preview
" @see https://sidneyliebrand.io/blog/how-fzf-and-ripgrep-improved-my-workflow
" +edited: set dir to gitroot.
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..', 'dir': projectroot#get()}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..', 'dir': projectroot#get()}, 'right:50%:hidden', '?'),
  \   <bang>0)

command! PGFiles call PGFiles()
command! PFiles  call PFiles()

nnoremap <c-p>     <cmd>PGFiles<Return>
nnoremap <Leader>b <cmd>Buffers<Return>
nnoremap <Leader>w <cmd>Windows<Return>
" TODO mimic to / and ?
nnoremap / <cmd>BLines<cr>
nnoremap <Leader>/ /\v
nnoremap <Leader>* :BLines <c-r><c-w><Return>
" }}}

" terminals {{{

function! Shofel_terminal(label)
endfunction

command! -nargs=? -bar Terminal
      \ enew |
      \ call termopen(&shell . ' ;# ' . <q-args>) |
      \ f <q-args>

nnoremap <Leader>T :Terminal _
" }}}

" sneak {{{
let g:sneak#prompt = 'sneak>'
" These are defaults:
nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S
omap z <Plug>Sneak_s
omap Z <Plug>Sneak_S
" This one is not default.
xmap z <Plug>Sneak_s
xmap Z <Plug>Sneak_S
" Map f and F to a one-char sneak.
map f <Plug>Sneak_f
map F <Plug>Sneak_F
" }}}

" firenvim {{{
" TODO: extract to 1.detection and 2.effect
" TODO: commit back to firenvim repo.
function! OnUIEnter(event)
    let l:ui = nvim_get_chan_info(a:event.chan)
    if has_key(l:ui, 'client') && has_key(l:ui.client, 'name')
      if l:ui.client.name ==? 'Firenvim'
        set signcolumn=no
        set laststatus=0
        set showtabline=1
        set nowrap
      endif
    endif
endfunction

" invoke onuienter
autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
" }}}

" Hexokinase {{{
let g:Hexokinase_refreshEvents = [
      \ 'BufWrite', 'BufCreate',
      \ 'TextChanged', 'InsertLeave']
" }}}

" markdown-preview.nvim {{{
let g:mkdp_browser = 'google-chrome-beta'
augroup markdown-preview.nvim
  autocmd Filetype markdown  nnoremap <buffer> <Leader>fp <cmd>MarkdownPreview<cr>
augroup END
" }}}

" Debug highlighing.
" @see https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function! Synstack()
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" vim: set fdm=marker :
