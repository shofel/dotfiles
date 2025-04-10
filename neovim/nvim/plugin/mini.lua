require('mini.align').setup()
require('mini.comment').setup()

require('mini.surround').setup()
require('mini.sessions').setup()
require('mini.trailspace').setup()

vim.keymap.set('n', '<space>tw', MiniTrailspace.trim, {unique = true})
