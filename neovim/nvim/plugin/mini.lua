if vim.g.did_load_mini_plugin then
  return
end
vim.g.did_load_mini_plugin = true

require('mini.align').setup()
require('mini.comment').setup()
require('mini.pairs').setup()

require('mini.surround').setup()
vim.keymap.set('n', 's', '<nop>') -- `s` is spoiled anyways

require('mini.completion').setup()
