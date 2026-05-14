require('flash').setup()

vim.keymap.set({ 'n', 'x', 'o' }, 'h', function() require('flash').jump() end,             { desc = 'flash jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'H', function() require('flash').treesitter() end,        { desc = 'flash treesitter' })
vim.keymap.set({ 'o', 'x' },      'l', function() require('flash').treesitter_search() end, { desc = 'flash treesitter search' })
vim.keymap.set('o',               'L', function() require('flash').remote() end,            { desc = 'flash remote' })

vim.keymap.set('n', '<space>tF', function() require('flash').toggle() end, { desc = 'toggle flash' })
