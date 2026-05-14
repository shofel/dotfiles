require('flash').setup({
  modes = {
    char = {
      keys = { 'l', 'h', ';', ',' },
      char_actions = function(_motion)
        return {
          [';'] = 'next',
          [','] = 'prev',
          ['l'] = 'right',
          ['h'] = 'left',
        }
      end,
    },
  },
})

vim.keymap.set({ 'n', 'x', 'o' }, 'f',
  function() require('flash').jump() end,
  { desc = 'flash jump' })

vim.keymap.set({ 'n', 'x', 'o' }, 't',
  function() require('flash').treesitter() end,
  { desc = 'flash treesitter' })

vim.keymap.set({ 'o', 'x' }, 'T',
  function() require('flash').treesitter_search() end,
  { desc = 'flash treesitter search' })

vim.keymap.set('o', 'F',
  function() require('flash').remote() end,
  { desc = 'flash remote' })

vim.keymap.set('n', '<space>tF',
  function() require('flash').toggle() end,
  { desc = 'toggle flash' })
