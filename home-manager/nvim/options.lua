
-- Leader kevs
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Shell
vim.opt.shell = "fish"

--- Global options
vim.opt.hidden = true
vim.opt.list   = true
vim.opt.timeoutlen = 500
vim.opt.shortmess  = "filnxtToOFatsc"
vim.opt.inccommand = "nosplit"
vim.opt.cmdheight = 0

-- Use clipboard outside Neovim
vim.opt.clipboard = "unnamedplus"

-- Enable mouse input
vim.opt.mouse = "a"

--[[
-- Disable swapfiles and enable undofiles
(set-opts! {:backup false :backupcopy "yes"
            :swapfile false :updatetime 20
            :undofile true})

--; UI-related options
(vim.opt.ruler false)

-- Numbering
(vim.opt.number false)

-- True-color
(vim.opt.termguicolors true)

-- Cols and chars
(vim.opt.signcolumn "yes:1")

(vim.opt.fillchars {:eob " "
                      :horiz "━"
                      :horizup "┻"
                      :horizdown "┳"
                      :vert "┃"
                      :vertleft "┫"
                      :vertright "┣"
                      :verthoriz "╋"
                      :fold " "
                      :diff "─"
                      :msgsep "‾"
                      :foldsep "│"
                      :foldopen "▾"
                      :foldclose "▸"})

-- Folding
(set-opts! {:foldcolumn "1"
            :foldlevel 99
            :foldlevelstart 99
            :foldenable true})

-- Smart search
(vim.opt.smartcase true)

-- Case-insensitive search
(vim.opt.ignorecase true)

-- Indentation
(set-opts! {:copyindent true
            :smartindent true
            :preserveindent true
            :tabstop 2
            :shiftwidth 2
            :softtabstop 2
            ;
            :expandtab true})

-- Enable concealing
(vim.opt.conceallevel 2)

-- Default split directions
(set-opts! {:splitright false
            :splitbelow true})

-- Scroll off
(vim.opt.scrolloff 0)


-- Russian keymap
(vim.opt.keymap "russian-dvorak")
(vim.opt.iminsert 0)
--]]

