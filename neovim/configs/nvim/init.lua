vim.loader.enable()

-- Namespace for personal tweaks
_G.Slava = {}

-- I suspect they are broken
vim.g.mapleader = '<Space>'
vim.g.localleader = ','

-- Search down into subfolders
vim.opt.path = vim.o.path .. '**'

vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.showmatch = true -- Highlight matching parentheses, etc
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.spelllang = 'en'

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.history = 2000
vim.opt.nrformats = 'bin,hex' -- 'octal'
vim.opt.undofile = true
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.colorcolumn = '100'


vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')

require('user.diagnostic')
