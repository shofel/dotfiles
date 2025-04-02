require('mini.align').setup()
require('mini.comment').setup()
require('mini.pairs').setup()

require('mini.surround').setup()
vim.keymap.set('n', 's', '<nop>') -- `s` is spoiled anyways

require('mini.sessions').setup()
