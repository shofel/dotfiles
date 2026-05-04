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
  terminal = {enabled = false},
  words = { enabled = true },
  lazygit = { enabled = true },
  styles = {
    lazygit = { width = 0, height = 0, border = "none" },
    notification = {
      -- wo = { wrap = true } -- Wrap notifications
    }
  }
})

vim.keymap.set('n', '<space>ht', Snacks.lazygit.open, {desc = 'lazygit'})

_G.pp = function(...)
  Snacks.debug.inspect(...)
end
_G.trace = function()
  Snacks.debug.backtrace()
end
vim.print = Snacks.debug.inspect
