-- Shovel's init.lua file (<visla.vvi@gmail.com>)
-- vim: set fdm=marker :

--[[
  TODO the config
      3 bootstrap with nyoom to get support of fennel
      4 extract a file with plugins to watch correctly

  TODO plugins
      1 DONE manage keys with which-key
      2 preview markdown https://github.com/ellisonleao/glow.nvim

  TODO fixup regressions of config
      1 random string of 8 chars by <Leader>R
      2 exit from terminal. ? and from floating terminal window?

  TODO colors
    : a single file or modules? => template is lush or zenbones
    1 copy-paste all the old colors
    2 diffrent cursor colors fon language-mapping

  TODO adopt workspaces and sessions
       + edit init.vim as a part of workspace/dotfiles project

  TODO migrate to packer

  TODO easy-keys.fnl

  TODO autocomplete

  TODO look at the symbol under the cursor
]]--

-- plugins {{{
vim.cmd([[
call plug#begin('~/.config/nvim/plugged')

" ide
Plug 'simrat39/symbols-outline.nvim'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

" Git
Plug 'junegunn/gv.vim', {'on': 'GV'}
Plug 'rhysd/git-messenger.vim'

" Languages {{{
Plug 'neovim/nvim-lspconfig'
" We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'rhysd/reply.vim'

Plug 'georgewitteman/vim-fish'
Plug 'Olical/conjure'
Plug 'mattn/emmet-vim', { 'for': ['css', 'scss', 'html'] }
Plug 'kmonad/kmonad-vim'
" }}} Languages


" draw ascii diagrams
Plug 'gyim/vim-boxdraw'

" embed to browser
Plug 'glacambre/firenvim'

Plug 'akinsho/toggleterm.nvim'

" my favourite colors
" https://github.com/mcchrish/vim-no-color-collections
" my fork of vim-two-firewatch
Plug 'https://github.com/shofel/vim-two-firewatch'
Plug 'https://github.com/mcchrish/zenbones.nvim'
Plug 'https://github.com/rktjmp/lush.nvim'

Plug 'https://github.com/dstein64/vim-startuptime'

call plug#end()
]])
-- }}}

-- general {{{
vim.o.shell='fish'

vim.o.signcolumn = 'yes'
vim.o.number = false
vim.o.hidden = true
vim.o.list = true
vim.o.foldmethod='marker'

vim.o.backup = false
vim.o.backupcopy = 'yes'
vim.o.swapfile = false

-- default indentation settings
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop=2
vim.o.softtabstop=2
vim.o.shiftwidth=2

vim.o.guicursor = ''
   .. 'n-v-ve:block-Cursor,'
   .. 'i-c-ci-cr:ver100-Cursor,'
   .. 'o-r:hor100-Cursor'

vim.o.mouse='a'

-- russian
vim.o.keymap='russian-dvorak'
vim.o.iminsert=0
vim.o.imsearch=0
-- }}}

-- colors {{{

vim.o.termguicolors = true
vim.o.background = 'dark'
vim.cmd("colorscheme two-firebones")

vim.cmd([[
  " hide tildas after the end of file
  highlight EndOfBuffer guifg=bg guibg=none

  " bold exchange.vim
  highlight link ExchangeRegion Folded
]])
-- }}}

-- syntax and filetypes {{{

vim.cmd([[
  let g:javascript_plugin_flow = 1

augroup initvim
  autocmd!

  " Vimscript
  autocmd Filetype lua nnoremap <buffer> <Leader>gf :!open https://github.com/<c-r><c-f><cr>

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

  autocmd TermOpen * setlocal nonumber | setlocal norelativenumber
  autocmd TermOpen * tnoremap <buffer> <Escape><Escape> 
augroup END
]])
-- }}}

-- keys {{{

vim.cmd([[
let mapleader="\<Space>"
let maplocalleader=","

nnoremap ; g;

" edit .vimrc
nnoremap <Leader>ve <cmd>tabe ~/.config/nvim/init.lua<cr>
nnoremap <Leader>vs <cmd>source ~/.config/nvim/init.lua<cr>

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

let g:user_emmet_leader_key = '<Leader>e'
let g:user_emmet_install_global = 0
augroup ShovelEmmet
  autocmd FileType html,css,scss EmmetInstall
augroup END

" switch window {{{
nnoremap <M-Left>   <C-w><C-h>
nnoremap <M-Right>  <C-w><C-l>
nnoremap <M-Down>   <C-w><C-j>
nnoremap <M-Up>     <C-w><C-k>
nnoremap <M-h>  <C-w><C-h>
nnoremap <M-n>  <C-w><C-n>
nnoremap <M-t>  <C-w><C-j>
nnoremap <M-c>  <C-w><C-k>
" }}}

" Another access to unimpaired
nmap <Leader>k [
nmap <Leader>j ]
" Navigate diagnostics
nmap [d <cmd>lua vim.diagnostic.goto_prev()<cr>
nmap ]d <cmd>lua vim.diagnostic.goto_next()<cr>
" Navigate git hunks
nmap ]h <cmd>lua require('gitsigns').next_hunk({preview = true})<cr>
nmap [h <cmd>lua require('gitsigns').prev_hunk({preview = true})<cr>

augroup shovel-fugitive
  autocmd!
  " where to open files. See fugitive_gO and below
  autocmd Filetype fugitive nmap <buffer> <cr> <cr>
  " `s` for lightspeed
  autocmd Filetype fugitive nmap <buffer> s <Plug>Lightspeed_s
  autocmd Filetype fugitive xmap <buffer> s <Plug>Lightspeed_s
augroup END
]])

-- clipboard {{{

-- `x` in visual modes does not save the deleted text
vim.keymap.set({'v', 'x'},         'x', '"_x')
-- X clipboard
vim.keymap.set({     'x'}, '<Leader>y', '"+y' , {remap = true})
vim.keymap.set({'n', 'x'}, '<Leader>p', '"+]p', {remap = true})
-- X selection
vim.keymap.set({     'x'}, '<Leader>Y', '"*y' , {remap = true})
vim.keymap.set({'n', 'x'}, '<Leader>P', '"*]p', {remap = true})

-- }}} clipboard

-- TS TreeSitter {{{
require'nvim-treesitter.configs'.setup {
  -- list of parsers {{{
  ensure_installed = ,
  -- }}}

-- search and replace {{{
vim.cmd([[
set ignorecase
set smartcase
set incsearch
set inccommand=nosplit
nnoremap <Leader>n :nohlsearch<cr>
nnoremap / /\v
]])
-- }}}

-- toggleterm {{{
-- TODO persist terminals across sourcing vimrc
require("toggleterm").setup{
  direction = 'float',
}

local Terminal = require('toggleterm.terminal').Terminal

local fish  = Terminal:new {cmd = 'fish', hidden = false}
local serve = Terminal:new {cmd = 'fish'}

vim.keymap.set({'n'}, '<leader>ts', function () fish:toggle() end)
vim.keymap.set({'n'}, '<leader>tf', function () serve:toggle() end)

vim.keymap.set({'n'}, '<leader>th', '<cmd>ToggleTermToggleAll<cr>')

-- }}} toggleterm
