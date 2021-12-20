" Shovel's init.vim file (<visla.vvi@gmail.com>)

" TODO a key which: 1.reads termname 2.executes Term

" plugins {{{
call plug#begin('~/.config/nvim/plugged')

" read local .vimrc files
Plug 'MarcWeber/vim-addon-local-vimrc'

" tpope
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" guttor
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'mhinz/vim-signify'

" statusline and tabline
Plug 'nvim-lualine/lualine.nvim'

" text decorations
Plug 'norcalli/nvim-colorizer.lua'

" more editing
Plug 'tommcdo/vim-exchange'
Plug 'jiangmiao/auto-pairs'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
" motion
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

" Languages {{{
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'neovim/nvim-lspconfig'
" Plug 'p00f/nvim-ts-rainbow'


Plug 'georgewitteman/vim-fish'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'tpope/vim-fireplace',    {'for': 'clojure'}
" Web Dev
Plug 'mattn/emmet-vim'
Plug 'kmonad/kmonad-vim'
" }}} Languages

" draw ascii diagrams
Plug 'gyim/vim-boxdraw'

" embed to browser
Plug 'glacambre/firenvim'

" trying right now
Plug 'jez/vim-superman'
Plug 'rhysd/reply.vim'

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

set shell=/usr/bin/fish

set signcolumn=yes
set nonumber " see also vim-numbertoggle plugin
set hidden
set list
set foldmethod=marker

set nobackup
set backupcopy=yes
set noswapfile
set updatetime=300 " set for vim-signify active mode

" default indentation settings
set smartindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

set guicursor=n-v-ve:block-Cursor
            \,i-c-ci-cr:ver100-Cursor
            \,o-r:hor100-Cursor
set mouse=a

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

" colorizer
lua  <<EOF
require'colorizer'.setup()
EOF

" }}}

" syntax and filetypes {{{
let g:javascript_plugin_flow = 1
augroup initvim
  autocmd!

  " Vimscript
  autocmd Filetype vim nnoremap <buffer> <Leader>gf :!open https://github.com/<c-r><c-f><cr>

  " Javascript
  autocmd BufRead,BufNewFile *.js.flow setfiletype typescript
  autocmd Filetype javascript let b:commentary_format = "/* %s */"
  autocmd Filetype javascript let b:textwidth=80
  autocmd Filetype javascript nnoremap <buffer> K :!x-www-browser mdn.io/<c-r><c-w><Return>
  autocmd Filetype javascript xnoremap <buffer> K "0y:!x-www-browser mdn.io/<c-r><c-r>0<Return>
  autocmd Filetype javascript nnoremap <buffer> <Leader>t :w<cr>:!yarn ava %<cr>
  autocmd Filetype javascript nnoremap <buffer> <Leader>T :w<cr>:Dispatch yarn ava<cr>
  autocmd BufNewFile,BufRead *.json5 set filetype=json5

  autocmd Filetype clojure let b:AutoPairs = {'{':'}', '(':')', '"':'"'}
  autocmd Filetype clojure nnoremap <buffer> <Leader>r :Dispatch lein run<cr>
  autocmd Filetype clojure nnoremap <buffer> <Leader>e :Eval<cr>

  autocmd Filetype ps1 let b:AutoPairs = {'{':'}', '(':')', '"':'"'}
  autocmd Filetype vim let b:AutoPairs = {'{':'}', '(':')', "'":"'"}

  " Fugitive : open files in a vertical split.
  autocmd Filetype fugitive nmap <buffer> <cr> gO

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

" switch keymap in normal mode
nnoremap <Leader>0 a<esc>:echom 'Keymap switched'<cr>

" fixup search
nnoremap / /\v

" REPLy
nnoremap <Leader>e :ReplSend<Return>
xnoremap <Leader>e :ReplSend<Return>
nnoremap <Leader>E :Repl<Return>

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
nnoremap <Leader>th <cmd>tabprevious<Return>
nnoremap <Leader>tl <cmd>tabnext<Return>
nnoremap <Leader>1 <cmd>tabn 1<Return>
nnoremap <Leader>2 <cmd>tabn 2<Return>
nnoremap <Leader>3 <cmd>tabn 3<Return>
nnoremap <Leader>4 <cmd>tabn 4<Return>
nnoremap <Leader>5 <cmd>tabn 5<Return>
nnoremap <Leader>6 <cmd>tabn 6<Return>
nnoremap <Leader>7 <cmd>tabn 7<Return>
nnoremap <Leader>8 <cmd>tabn 8<Return>
nnoremap <Leader>9 <cmd>tabn 9<Return>
" }}}

" switch window {{{
nnoremap <Leader>h       <C-w><C-h>
nnoremap <Leader>l       <C-w><C-l>
nnoremap <Leader><Down>  <C-w><C-j>
nnoremap <Leader><Up>    <C-w><C-k>
" }}}

" some commands
nnoremap <Leader>s   <cmd>w<Return>
nnoremap <Leader>o   <cmd>only<Return>
nnoremap <Leader>kk  <cmd>bdelete!<Return>

" git & bufsync
nnoremap <Leader>gs <cmd>tab Git<Return>
nnoremap <Leader>ga <cmd>Gwrite<Return>
nnoremap <Leader>gp <cmd>Dispatch git push<Return>
nnoremap <Leader>gf <cmd>Dispatch git fetch --all --prune<Return>
nnoremap <Leader>gP <cmd>Dispatch git push --force-with-lease<Return>
nnoremap <Leader>gu <cmd>SignifyHunkUndo<Return>
nnoremap <Leader>gv <cmd>call Shovel_glog()<cr>
nnoremap <Leader>gV <cmd>GV!<Return>

function! Shovel_glog() abort
  exe('tabe +term\ glog')
  exe('setlocal bufhidden=wipe')
  exe('tnoremap <buffer> q <c-\><c-n>:bdelete!<cr>')
  exe('startinsert')
endfun

" Another access to unimpaired
nmap <Leader>k [
nmap <Leader>j ]
" Navigate between signs in signcolumn
nmap [d <cmd>lua vim.diagnostic.goto_prev()<cr>
nmap ]d <cmd>lua vim.diagnostic.goto_next()<cr>
nmap [c <Plug>(signify-prev-hunk)
nmap ]c <Plug>(signify-next-hunk)

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

" X clipboard
xnoremap <Leader>y "+y<Return>
nnoremap <Leader>p "+]p<Return>
xnoremap <Leader>p "+]p<Return>
" X selection
xnoremap <Leader>Y "*y<Return>
nnoremap <Leader>P "*]p<Return>
xnoremap <Leader>P "*]p<Return>

" Insert random string
function! Shovel_insert_random()
  let l:x = systemlist('pwgen 8 1')
  " echom map(l:x, "'|' . v:val . '|'")
  execute 'normal! a' . join(l:x)
endfunction

nnoremap <Leader>R <cmd>call Shovel_insert_random()<cr>

" in terminal
" @see http://neovim.io/doc/user/nvim_terminal_emulator.html
" @see https://github.com/junegunn/fzf.vim/issues/544
" map <c-g> for fzf is because it closes fzf window faster than <Esc>.
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<c-g>" : "<c-\><c-n>"

" Git messager
nnoremap <Leader>gm <cmd>GitMessenger<cr>
" }}}

" Neovim LSP {{{
" @see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
lua <<EOF
local util = require'lspconfig'.util

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }

  -- navigation and doc
  buf_set_keymap('n', '<Leader>dec', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<Leader>def', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>di', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<Leader>dt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>ds', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<Leader>dh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<Leader>dr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<Leader>dR', '<cmd>Rg! <c-r><c-w><CR>', opts)
  -- diagnostic
  buf_set_keymap('n', '<Leader>dk', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<Leader>dj', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>dw', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<Leader>dq', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<Leader>df', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  -- workspace
  buf_set_keymap('n', '<Leader>Wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>Wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>Wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf
  buf_set_keymap('n', '<Leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<Leader>da', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

require'lspconfig'.powershell_es.setup{
  on_attach = on_attach,
  bundle_path = '/home/shovel/opt/PowerShellEditorServices/',
}

require'lspconfig'.flow.setup{
  on_attach = on_attach,
  cmd = { 'yarn', 'flow', 'lsp' }
}

require'lspconfig'.eslint.setup{
  on_attach = function() vim.api.nvim_command('autocmd BufWritePre <buffer> EslintFixAll') end
}

require'lspconfig'.stylelint_lsp.setup{
    cmd = { "yarn", "dlx", "-p", "stylelint-lsp", "stylelint-lsp", "--stdio" },
    filetypes = { "css", "less", "scss", "sugarss", "vue", "wxss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_dir = util.root_pattern('.stylelintrc', 'package.json'),
    settings = {}
}

require'lspconfig'.hls.setup{}
require'lspconfig'.rnix.setup{}
require'lspconfig'.vimls.setup{}
require'lspconfig'.yamlls.setup{}
EOF
" }}}

" TS TreeSitter {{{
lua  <<EOF
--[[
require'nvim-treesitter.configs'.setup {
  rainbow = {
    enable = true,
    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
  }
}
]]
EOF
" }}} TS TreeSitter

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

nnoremap <Leader>f <cmd>PGFiles<Return>
nnoremap <Leader>F <cmd>PFiles<Return>
nnoremap <Leader>b <cmd>Buffers<Return>
nnoremap <Leader>w <cmd>Windows<Return>
nnoremap <Leader>/ <cmd>BLines<Return>
nnoremap <Leader>: <cmd>Commands<Return>
" }}}

" terminals {{{

command! -bar BarTerm term

command! -nargs=1 -bar Terminal
      \ BarTerm |
      \ file term:<args>

nnoremap <Leader>~ :tabe +Terminal\ 
" }}}

" sneak & clever-f {{{
let g:sneak#prompt = 'sneak>'
let g:sneak#label = 1
let g:sneak#target_labels = 'gfdhtnsiyiueoa'
" Be like rhysd/clever-f.vim 
let g:sneak#s_next = 1

" These are defaults:
nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S
omap z <Plug>Sneak_s
omap Z <Plug>Sneak_S
" This one is not default.
xmap z <Plug>Sneak_s
xmap Z <Plug>Sneak_S
" Map fFTt to a one-char sneaks.
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
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
