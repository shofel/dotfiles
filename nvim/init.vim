" Shovel's init.vim file (<visla.vvi@gmail.com>)

" plugins
call plug#begin('/home/shovel/.config/nvim/plugged')

Plug 'scrooloose/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdcommenter'
Plug 'kien/ctrlp.vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ntpeters/vim-better-whitespace'

" languages
Plug 'pangloss/vim-javascript'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'dag/vim-fish'

" colors
Plug 'joshdick/onedark.vim'
Plug 'sjl/badwolf'

" Plug 'terryma/vim-expand-region'
" Plug 'scrooloose/nerdtree'
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
au BufRead,BufNewFile *.nj setfiletype jinja

" keys
let mapleader="\<SPACE>"
nnoremap <c-s> :w<Return>
nnoremap <F2> :w<Return>
nnoremap <Leader>q :copen<Return>
nnoremap <Leader>Q :cclose<Return>

" syntactic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" js style
let g:syntastic_javascript_checkers = ['standard'] " requires npm -g i standard
" TODO make it exclusively for a project
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
