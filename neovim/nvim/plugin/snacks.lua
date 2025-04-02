local snacks = require('snacks')

snacks.setup({
  animate = {},
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  explorer = { enabled = true },
  indent = { enabled = false },
  input = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  picker = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  terminal = {},
  words = { enabled = true },
  styles = {
    notification = {
      -- wo = { wrap = true } -- Wrap notifications
    }
  }
})

vim.keymap.set('n', '<space>ht', snacks.lazygit.open, {desc = 'lazygit'})

vim.keymap.set('n', '<Plug>(snacks-terminal-toggle)', function () snacks.terminal.toggle('fish') end)
vim.keymap.set('n', '<space>ta', '1<Plug>(snacks-terminal-toggle)', {desc = 'toggle terminal 1'})
vim.keymap.set('n', '<space>to', '2<Plug>(snacks-terminal-toggle)', {desc = 'toggle terminal 2'})
vim.keymap.set('n', '<space>tv', '<cmd>vsp +term | startinsert<cr>', {desc = 'terminal in a vertial split'})
