-- Shovel's init.lua file (<visla.vvi@gmail.com>)
-- vim: set fdm=marker :

--[[
  TODO the config
      3 bootstrap with nyoom to get support of fennel
      4 extract a file with plugins to watch correctly

  DONE plugins
      1 manage keys with which-key
      x preview markdown https://github.com/ellisonleao/glow.nvim

  TODO fixup regressions of config
      1 random string of 8 chars by <Leader>R

  TODO colors
    : a single file or modules? => template is lush or zenbones
    1 copy-paste all the old colors
    2 diffrent cursor colors fon language-mapping

  DONE migrate to packer

  TODO easy-keys.fnl

  DONE autocomplete

  TODO look at the symbol under the cursor
]]

-- plugins {{{
vim.cmd([[
call plug#begin('~/.config/nvim/plugged')

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

" mini
Plug 'echasnovski/mini.nvim'

" gutter
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

Plug 'folke/trouble.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-lualine/lualine.nvim'

" more editing
Plug 'ggandor/lightspeed.nvim'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'jiangmiao/auto-pairs'
Plug 'tommcdo/vim-exchange' " TODO gbprod/substitute.nvim

" follow conventions
Plug 'editorconfig/editorconfig-vim'

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
  autocmd Filetype javascript nnoremap <buffer> K :!x-www-browser mdn.io/<c-r><c-w><Return>
  autocmd Filetype javascript xnoremap <buffer> K "0y:!x-www-browser mdn.io/<c-r><c-r>0<Return>
  autocmd Filetype javascript nnoremap <buffer> <Leader>t :w<cr>:!yarn ava %<cr>
  autocmd Filetype javascript nnoremap <buffer> <Leader>T :w<cr>:Dispatch yarn ava<cr>
  autocmd BufNewFile,BufRead *.json5 set filetype=json5

  autocmd TermOpen * setlocal nonumber | setlocal norelativenumber
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

" some commands
nnoremap <Leader>s   <cmd>w<Return>
nnoremap <Leader>o   <cmd>only<Return>
nnoremap <Leader>kk  <cmd>bdelete!<Return>
nnoremap <Leader>kc  <cmd>lua require('mini.bufremove').delete()<Return>

" git & bufsync
nnoremap <Leader>gs <cmd>vert Git<Return>
nnoremap <Leader>ga <cmd>Gwrite<Return>
nnoremap <Leader>gp <cmd>Dispatch git push<Return>
nnoremap <Leader>gP <cmd>Dispatch git push --force-with-lease<Return>
nnoremap <Leader>gm <cmd>GitMessenger<cr>
nnoremap <Leader>gV <cmd>GV!<Return>
nnoremap <Leader>gv <cmd>TermExec cmd='glog; exit'<cr>

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

nnoremap <Leader>c  :checkt<Return>
nnoremap <Leader>s  :write<Return>
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

-- Neovim LSP {{{
-- @see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
local util = require'lspconfig'.util

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = {buffer = bufnr}

  -- navigation and doc
  vim.keymap.set({'n'}, '<Leader>dec', vim.lsp.buf.declaration, opts)
  vim.keymap.set({'n'}, '<Leader>def', vim.lsp.buf.definition, opts)
  vim.keymap.set({'n'}, '<Leader>di', vim.lsp.buf.implementation, opts)
  vim.keymap.set({'n'}, '<Leader>dt', vim.lsp.buf.type_definition, opts)
  vim.keymap.set({'n'}, '<Leader>ds', vim.lsp.buf.signature_help, opts)
  vim.keymap.set({'n'}, '<Leader>dh', vim.lsp.buf.hover, opts)
  vim.keymap.set({'n'}, '<Leader>dr', vim.lsp.buf.references, opts)
  -- diagnostic
  vim.keymap.set({'n'}, '<Leader>dk', vim.diagnostic.goto_prev, opts)
  vim.keymap.set({'n'}, '<Leader>dj', vim.diagnostic.goto_next, opts)
  vim.keymap.set({'n'}, '<Leader>dw', vim.diagnostic.open_float, opts)
  vim.keymap.set({'n'}, '<Leader>dq', vim.diagnostic.setloclist, opts)
  vim.keymap.set({'n'}, '<Leader>df', vim.lsp.buf.formatting, opts)
  -- workspace
  vim.keymap.set({'n'}, '<Leader>Wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set({'n'}, '<Leader>Wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set({'n'}, '<Leader>Wl', print(vim.inspect(vim.lsp.buf.list_workspace_folders())), opts)
  -- buf
  vim.keymap.set({'n'}, '<Leader>r',  vim.lsp.buf.rename, opts)
  vim.keymap.set({'n'}, '<Leader>da', vim.lsp.buf.code_action, opts)
  -- reassign some native mappings
  vim.keymap.set({'n'}, 'K',  vim.lsp.buf.hover, opts)
  vim.keymap.set({'n'}, 'gd', vim.lsp.buf.definition, opts)
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
require'lspconfig'.sumneko_lua.setup{
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}
require'lspconfig'.rnix.setup{}
require'lspconfig'.terraformls.setup{}
require'lspconfig'.vimls.setup{}
require'lspconfig'.yamlls.setup{}
-- }}}

--[[

augroup shovel_home.nix
  autocmd BufRead home.nix,init.vim nnoremap <buffer> <leader>r <cmd>Dispatch home-manager switch --flake ./home-nix/<cr>
augroup END

" Debug highlighing.
" @see https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function! Synstack()
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

--]]
