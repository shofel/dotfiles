" Shovel's init.vim file (<visla.vvi@gmail.com>)

" TODO next: tabs:
" - tag tabs with a custom name
" - switch between them fuzzy find by that title
" - better contrast on tabline and inactive statusline

" TODO remap g; and g, to just ; and ,

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
Plug 'ggandor/lightspeed.nvim'

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
Plug 'Olical/conjure'
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

" statusline and tabline {{{
lua <<EOF
local function hide_tabline()
  vim.go.showtabline = 0
end

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'onelight',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = ' ', right = ' '},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
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
  tabline = { hide_tabline() },
  extensions = {'fugitive'}
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
nnoremap <Leader>gs <cmd>vert Git<Return>
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
  autocmd!
  " where to open files. See fugitive_gO and below
  autocmd Filetype fugitive nmap <buffer> <cr> <cr>
  " `s` for lightspeed
  autocmd Filetype fugitive nmap <buffer> s <Plug>Lightspeed_s
  autocmd Filetype fugitive xmap <buffer> s <Plug>Lightspeed_s
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

" lightspeed.nvim {{{
lua <<EOF
--[[ To contribute:
- [ ] why do they differ: labels and safe_labels?
- [ ] explain auto-jump. (is it:? https://github.com/ggandor/lightspeed.nvim#jump-on-partial-input)
- [ ] explain `smart mode` https://github.com/ggandor/lightspeed.nvim#other-quality-of-life-features
- [ ] readme:`grouping matches by distance`: reference to mapping name
--]]

--[[ Choose the best labels:
  1. Sort all the letters from easy to hard (to reach)
  1.1. staggered or ortholinear
  1.2. layout (qwerty dvorak colemak workman)
  2. Safe labels are those represent motions: one unlikely need a motion right after a jump
  3. Unsafe labels are those represent editing: obviously you make a jump to edit there

  ?: should we use capitals?
     + pros: get more labels
     - cons: they are effectively a chords, not a single keys

  ?: what if not mix caps with lowercase, but exclusively use caps?
     + pros: significantly less likely to clash with a command right after jump

  ?: should we use punctuation?
     + pros: get more labels (only a little bit)
     - cons: ? letters are better to pronounce ?
 
- [ ] list the keys, which are considered frequently used right after jump: -another jump; -insertion. They should be either excluded or moved to the end of the list
--]]

local function labels ()
  local keyboard = {
    staggered = [[
      4 2 2 3 4 5 3 2 2 4
       1 1 1 1 3 3 1 1 1 1
        4 4 3 2 5 3 2 3 4 4
    ]],
    ortholinear = [[
      4 2 2 3 4 4 3 2 2 4
      1 1 1 1 3 3 1 1 1 1
      4 4 3 2 4 4 2 3 4 4
    ]],
    dactyl = [[
      4 2 2 3 3   3 3 2 2 4
      1 1 1 1 3   3 1 1 1 1
      4 4 3 2 3   3 2 3 4 4
    ]],
  }

  local layout = {
    qwerty = [[
      q w e r t y u i o p
      a s d f g h j k l ;
      z x c v b n m , . /
    ]],
    dvorak = [[
     \' , . p y f g c r l
      a o e u i d h t n s
      ; q j k x b m w v z
    ]],
    colemak = [[
      q w f p g j l u y ;
      a r s t d h n e i o
      z x c v b k m , . /
    ]],
    workman = [[
      q d r w b j f u p ;
      a s h t g y n e o i
      z x m c v k l , . /
    ]],
  }

  local nonletters = {"'", ',', ';', '.'}

  --[[ TODO build a table with labels
            1. combine keyboard and layout
            2. sort by effort
            3. ? cut by effort ?
            4. remove nonletters
  --]]


  -- NOTE safe_jump is to be followed by esc or lookup
  --      it is almost like `esc` is the first jump label

  -- ??? : unsafe_labels are those which clash with commands likely to be used right after auto-jump ???

  --[[ UX
  -- 1. look at the target. Identify the two letters xy
  -- 2. press sxy
  -- 3. already arrived? then probably edit something. Otherwise:
  -- 4. read the label and press it.
  --]]

  local edits = {
    'p', 'y', -- paste and copy
    '.', -- repeat
    'd', 'x', 'r', -- delete and replace
    'a', 'i', 'o', 'c', -- enter insert mode
  }

  local motions = {
    'h', 'j', 'k', 'l', -- charwise
    'f', 't', ',', ';', -- bread and butter of lightspeed
    's', -- the bread and butter too?
    'n', -- search
    'b', 'e', 'w', -- wordwise
  }

  local edits_grouped = {
    {'d', 'c', 'a', 'i', 'o'}, -- very common right after a jump (proof?)
    {'r', 'x', 'p', 'y', '.'}, -- maybe a bit less common (proof?)
  }

  local motions_grouped = {
    {'h', 'l', -- correcting a by-one error
     'k', 'j', -- maybe when hunting for an empty line?
    },
    {'b', 'e', 'w', 'n', -- looks meaningless after a jump. When correcting a selection?
     ',', ';', -- non-sense: repeat one-letter search in the middle of two-letter-one
     'f', 't', -- non-sense: start a search right in the middle of a search? Nah!:)
    },
  }

  local others = {
    {'g', -- likely to be used. At least `gd`
     'z', -- also a start of many commands. Suggest for spelling fixes z=
     'v', 'q', 'm', -- why not?
    },
    {'u'}, -- unlikely to undo right after a jump, as well as after any motion
  }

  return nil
end

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
  safe_labels = labels(),
  labels = labels(),
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
