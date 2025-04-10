local z = require('lze')

z.load({
  'guess-indent.nvim',
  event = 'DeferredUIEnter',
  after = function() require('guess-indent').setup({}) end,
})

z.load({
  'nvim-autopairs',
  event = 'InsertEnter',
  after = function() require('nvim-autopairs').setup({}) end,
})
