require('lze').load({
  "guess-indent.nvim",
  event = 'DeferredUIEnter',
  after = function() require('guess-indent').setup({}) end
})
