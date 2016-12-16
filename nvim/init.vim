" Shovel's init.vim file (<visla.vvi@gmail.com>)

" plugins
call plug#begin('/home/shovel/.config/nvim/plugged')

Plug 'scrooloose/syntastic'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'kien/ctrlp.vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdcommenter'
Plug 'editorconfig/editorconfig-vim'

" pligins I don't use
" Plug 'terryma/vim-expand-region'
" Plug 'scrooloose/nerdtree'
" Plug 'Valloric/YouCompleteMe'

" languages
" Plug 'Shougo/deoplete.nvim'
" Plug 'carlitux/deoplete-ternjs'
Plug 'pangloss/vim-javascript'
Plug 'ternjs/tern_for_vim' " needs 'npm i' inside of the cloned repo
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'leafgarland/typescript-vim'
Plug 'dag/vim-fish'
Plug 'gutenye/json5.vim'
Plug 'mattn/emmet-vim'

" colors
Plug 'joshdick/onedark.vim'
Plug 'sjl/badwolf'
" other nice colorschemes: obsidian tomorrow-night-bright monokai

call plug#end()

" generol
set number
set hidden
set nobackup
set noswapfile

" colors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
syntax on
colorscheme onedark

" colors for nunjucks
au BufRead,BufNewFile *.njk setfiletype jinja
au BufRead,BufNewFile *.nj setfiletype jinja

" keys
let mapleader="\<SPACE>"
nnoremap <c-s> :w<Return>
nnoremap <F2> :w<Return>
nnoremap <Leader>q :copen<Return>
nnoremap <Leader>Q :cclose<Return>
nnoremap <Leader>d :TernDef<Return>

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" js style
let g:syntastic_javascript_eslint_exec = 'eslint'
let g:syntastic_javascript_flow_exe = 'flow'
let g:syntastic_javascript_checkers = ['eslint', 'flow'] " requires them to be installed


" other plugins
let g:deoplete#enable_at_startup = 1
let NERDSpaceDelims=1
let g:EditorConfig_exclude_patterns = ['fugitive://.*']


set smartindent
set expandtab
set softtabstop=2
set shiftwidth=2

" search
set ignorecase
set smartcase
set incsearch

" The Silver Searcher
" @see https://robots.thoughtbot.com/faster-grepping-in-vim
if executable('ag')
  " Use ag over grep
  set grepprg=ag

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" strip white space
autocmd BufWritePre * StripWhitespace
