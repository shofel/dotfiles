" Shovel's init.vim file (<visla.vvi@gmail.com>)

" TODO adopt workspaces and sessions
"      + edit init.vim as a part of workspace/dotfiles project

" TODO discoverable keys

" TODO migrate to packer
"      + switch to init.lua

" TODO easy-keys.fnl

" TODO autocomplete

" TODO colors for treesitter

" TODO explore mini.nvim collection https://github.com/echasnovski/mini.nvim
" TODO keymap tree <leader>v to input digraphs
" TODO preserve layout when killing a buffer

" plugins {{{
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
Plug 'tommcdo/vim-exchange' " gbprod/substitute.nvim

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
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'rhysd/reply.vim'

Plug 'georgewitteman/vim-fish'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
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
Plug 'https://github.com/shofel/vim-two-firewatch.git' " my fork
Plug 'https://github.com/rebelot/kanagawa.nvim'

Plug 'https://github.com/dstein64/vim-startuptime'

call plug#end()
" }}}

" general {{{
set encoding=utf-8
scriptencoding=utf-8

set shell=fish

set signcolumn=yes
set nonumber " see also vim-numbertoggle plugin
set hidden
set list
set foldmethod=marker

set nobackup
set backupcopy=yes
set noswapfile

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

" russian
set keymap=russian-dvorak
set iminsert=0
set imsearch=0
" }}}

" colors {{{

" tune colorschemes
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

" statusline and tabline {{{
lua <<EOF
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'onelight',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = {'branch'},
    lualine_b = {'b:gitsigns_status', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {'tabs'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'b:gitsigns_status_dict.root'}
  },
  extensions = {'fugitive', 'toggleterm'}
}
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

  autocmd TermOpen * setlocal nonumber | setlocal norelativenumber
augroup END
" }}}

" keys {{{

let mapleader="\<Space>"
let maplocalleader=","

nnoremap ; g;

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

" git & bufsync
nnoremap <Leader>gs <cmd>vert Git<Return>
nnoremap <Leader>ga <cmd>Gwrite<Return>
nnoremap <Leader>gp <cmd>Dispatch git push<Return>
nnoremap <Leader>gP <cmd>Dispatch git push --force-with-lease<Return>
nnoremap <Leader>gV <cmd>GV!<Return>
nnoremap <Leader>gv <cmd>TermExec cmd='glog; exit'<cr>

" Another access to unimpaired
nmap <Leader>k [
nmap <Leader>j ]
" Navigate between signs in signcolumn
nmap [d <cmd>lua vim.diagnostic.goto_prev()<cr>
nmap ]d <cmd>lua vim.diagnostic.goto_next()<cr>

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

" clipboard {{{
" X clipboard
xmap <Leader>y "+y<Return>
nmap <Leader>p "+]p<Return>
xmap <Leader>p "+]p<Return>
" X selection
xmap <Leader>Y "*y<Return>
nmap <Leader>P "*]p<Return>
xmap <Leader>P "*]p<Return>
" }}} clipboard

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
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

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
require'lspconfig'.rnix.setup{}
require'lspconfig'.terraformls.setup{}
require'lspconfig'.vimls.setup{}
require'lspconfig'.yamlls.setup{}
EOF
" }}}

" TS TreeSitter {{{
lua  <<EOF
require'nvim-treesitter.configs'.setup {
  -- list of parsers {{{
  ensure_installed = {
    "bash",
    "clojure",
    "cmake",
    "comment",
    "commonlisp",
    "css",
    "dart",
    "dockerfile",
    "erlang",
    "fennel",
    "fish",
    "go",
    "html",
    "http",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "latex",
    "lua",
    "make",
    "markdown",
    "ninja",
    "nix",
    "org",
    "pascal",
    "perl",
    "php",
    "python",
    "regex",
    "ruby",
    "rust",
    "scheme",
    "scss",
    "teal",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vue",
    "yaml",
    },
  -- }}}

  sync_install = false, 
  ignore_install = { "" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
    disable = { "yaml" }
  },
  rainbow = {
    enable = false,
    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
  }
}
EOF
" }}} TS TreeSitter

lua require'gitsigns'.setup()
lua require'trouble'.setup { icons = false }
lua require'colorizer'.setup()

" search and replace {{{
set ignorecase
set smartcase
set incsearch
set inccommand=nosplit
nnoremap <Leader>n :nohlsearch<cr>
nnoremap / /\v
" }}}

lua<<EOF
  -- `x` in visual modes does not save the deleted text
  vim.keymap.set({'n', 'v', 'x'}, 'x', '"_x')
EOF

" toggleterm {{{
lua <<EOF
require("toggleterm").setup{
  direction = 'float',
}

local Terminal = require('toggleterm.terminal').Terminal

local fish  = Terminal:new {cmd = 'fish', hidden = false}
local serve = Terminal:new {cmd = 'fish'}

vim.keymap.set({'n'}, '<leader>ts', function () fish:toggle() end)
vim.keymap.set({'n'}, '<leader>tf', function () serve:toggle() end)

vim.keymap.set({'n'}, '<leader>th', '<cmd>ToggleTermToggleAll<cr>')

EOF

" }}} toggleterm

" fzf {{{
lua <<LUA

local fzf = require('fzf-lua')

local fzf_files = function()
  fzf.files({fd_opts = '--no-ignore --hidden'})
end

vim.keymap.set({'n'}, '<leader>ff', fzf.git_files)
vim.keymap.set({'n'}, '<leader>fF', fzf_files)
vim.keymap.set({'n'}, '<leader>fg', fzf.live_grep)
vim.keymap.set({'n'}, '<leader>fh', fzf.help_tags)
vim.keymap.set({'n'}, '<leader>fH', fzf.command_history)
vim.keymap.set({'n'}, '<leader>fc', fzf.commands)
vim.keymap.set({'n'}, '<leader>f,', fzf.builtin)
vim.keymap.set({'n'}, "<leader>f'", fzf.marks)
vim.keymap.set({'n'}, '<leader>fk', fzf.keymaps)
vim.keymap.set({'n'}, '<leader>f.', fzf.resume)
vim.keymap.set({'n'}, '<leader>fw', fzf.grep_cword)
vim.keymap.set({'n'}, '<leader>fW', fzf.grep_cWORD)

vim.keymap.set({'n'},  '<leader>/', fzf.blines)
vim.keymap.set({'n'},  '<leader>b', fzf.buffers)

LUA

if (!executable('fd')) | echoerr 'fd (fd-find) executable not found' | endif
if (!executable('rg')) | echoerr 'rg (ripgrep) executable not found' | endif
" }}} fzf

" lightspeed.nvim {{{
lua <<EOF

require'lightspeed'.setup {
  ignore_case = false,
  exit_after_idle_msecs = {
    labeled = nil,
    unlabeled = 1500,
  },

  -- s/x
  jump_to_unique_chars = true,
  match_only_the_start_of_same_char_seqs = true,
  substitute_chars = { ['\r'] = '¬' },
  -- Leaving the appropriate list empty effectively disables
  -- "smart" mode, and forces auto-jump to be on or off.
  safe_labels = nil,
  labels = nil,

  -- f/t
  limit_ft_matches = 4,
  repeat_ft_with_target_char = false,
}
EOF
" }}} lightspeed.nvim

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
augroup shovel_firenvim
  autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
augroup END
" }}}

augroup shovel_home.nix
  autocmd BufRead home.nix,init.vim nnoremap <buffer> <leader>r <cmd>Dispatch home-manager switch --flake ./home-nix/<cr>
augroup END

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
