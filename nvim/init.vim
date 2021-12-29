" Shovel's init.vim file (<visla.vvi@gmail.com>)

" TODO next: tabs:
" - tag tabs with a custom names

" TODO ? use , as a localleader ?

" TODO discoverable keys

" TODO migrate to packer
"      + switch to init.lua

" TODO easy-keys.fnl

" TODO autocomplete

" TODO colors for treesitter

" TODO explore mini.nvim collection https://github.com/echasnovski/mini.nvim

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

" gutter
Plug 'jeffkreeftmeijer/vim-numbertoggle'
""""
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

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
Plug 'ggandor/lightspeed.nvim'

" follow conventions
Plug 'editorconfig/editorconfig-vim'

" search files and inside files
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'dbakker/vim-projectroot'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Git
Plug 'junegunn/gv.vim', {'on': 'GV'}
Plug 'rhysd/git-messenger.vim'

" Languages {{{
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'rhysd/reply.vim'
Plug 'sheerun/vim-polyglot'

Plug 'folke/trouble.nvim'

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

Plug 'jez/vim-superman'

Plug 'akinsho/toggleterm.nvim'

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
"
" Everforest is a green based color scheme, it's designed to be warm and soft in order to protect developers' eyes.
" Plug 'sainnhe/everforest'
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

" statusline and tabline {{{
lua <<EOF
local function hide_tabline()
  vim.go.showtabline = 0
end

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'onelight',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'branch'},
    lualine_b = {'diff', 'diagnostics'},
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
    lualine_z = {'mode'}
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

" vman {{{
function! s:vmanSettings()
  setlocal nonumber
  setlocal signcolumn=no
  setlocal showtabline=0
  setlocal ruler
  nnoremap <buffer> q <cmd>q!<cr>
endfunction

augroup vmanSettings
  autocmd!
  autocmd Filetype man call s:vmanSettings()
augroup END
" }}}

" abbreviations {{{
abbr retrun return
" }}}

" keys {{{

let mapleader="\<Space>"
let maplocalleader="\<Space>\<Space>"

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
" }}}

" some commands
nnoremap <Leader>s   <cmd>w<Return>
nnoremap <Leader>o   <cmd>only<Return>
nnoremap <Leader>kk  <cmd>bdelete!<Return>

" git & bufsync
nnoremap <Leader>gs <cmd>vert Git<Return>
nnoremap <Leader>ga <cmd>Gwrite<Return>
nnoremap <Leader>gp <cmd>Dispatch git push<Return>
nnoremap <Leader>gf <cmd>Dispatch git fetch --all --prune<Return>
nnoremap <Leader>gP <cmd>Dispatch git push --force-with-lease<Return>
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
  buf_set_keymap('n', '<Leader>r',  '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<Leader>da', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- reassign some native mappings
  buf_set_keymap('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
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

" toggleterm {{{
lua<<EOF
require("toggleterm").setup{
  direction = 'float',
  hidden = true,
}

local Terminal = require('toggleterm.terminal').Terminal

local fish  = Terminal:new {cmd = 'fish', hidden = false}
local git   = Terminal:new {cmd = 'lazygit'}
local serve = Terminal:new {cmd = 'fish'}

function shovel_terminal_fish()  fish:toggle(); end
function shovel_terminal_git()   git:toggle(); end
function shovel_terminal_serve() serve:toggle(); end

vim.api.nvim_set_keymap('n', '<leader>tg', '<cmd>lua shovel_terminal_git()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gt', '<leader>tg', {noremap = false})
vim.api.nvim_set_keymap('n', '<leader>ts', '<cmd>lua shovel_terminal_fish()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>tf', '<cmd>lua shovel_terminal_fish()<cr>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>tt', '<cmd>ToggleTermToggleAll<cr>',        {noremap = true, silent = true})
EOF
" }}} toggleterm

" telescope {{{

" from the readme
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" my custom
nnoremap <Leader>f: <cmd>Telescope command_history<cr>
nnoremap <Leader>f? <cmd>Telescope builtin<cr>
nnoremap <Leader>fc <cmd>Telescope commands<cr>
nnoremap <Leader>fm <cmd>Telescope marks<cr>
nnoremap <leader>fB <cmd>Telescope file_browser<cr>
nnoremap <leader>fF <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fk <cmd>Telescope keymaps<cr>

" short keys, without the `f` prefix
nnoremap <leader>b  <cmd>Telescope buffers<cr>
nnoremap <Leader>/  <cmd>Telescope current_buffer_fuzzy_find<cr>

" TODO replace this one with telescope
nnoremap <Leader>w <cmd>Windows<Return>
" TODO implement a finder for fd --no-ignore --hidden

" TODO map <esc> to <esc><esc>
" TODO map / to <cr> in file_browser

if (!executable('fd')) | echoerr 'fd (fd-find) executable not found' | endif
if (!executable('rg')) | echoerr 'rg (ripgrep) executable not found' | endif
" }}} telescope

" lightspeed.nvim {{{
lua <<EOF

require'lightspeed'.setup {
  ignore_case = false,
  exit_after_idle_msecs = {
    labeled = nil,
    unlabeled = 1500,
  },

  -- s/x
  grey_out_search_area = true,
  highlight_unique_chars = true,
  match_only_the_start_of_same_char_seqs = true,
  jump_on_partial_input_safety_timeout = 400,
  substitute_chars = { ['\r'] = '¬' },
  -- Leaving the appropriate list empty effectively disables
  -- "smart" mode, and forces auto-jump to be on or off.
  safe_labels = nil,
  labels = {},
  cycle_group_fwd_key = '<space>',
  cycle_group_bwd_key = '<tab>',

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
