vim.bo.comments = ':---,:--'

vim.cmd.packadd 'nvim-luadev'

-- nvim repl keys
local opts = {buffer = true}
vim.keymap.set('n', '<space>R',  '<cmd>Luadev<cr>',         opts)
vim.keymap.set('n', '<space>rr', '<Plug>(Luadev-RunLine)',  opts)
vim.keymap.set('n', '<space>r',  '<Plug>(Luadev-Run)',      opts)
vim.keymap.set('x', '<space>r',  '<Plug>(Luadev-Run)',      opts)
vim.keymap.set('n', '<space>rw', '<Plug>(Luadev-RunWord)',  opts)
vim.keymap.set('i', '<c-space>', '<Plug>(Luadev-Complete)', opts)
