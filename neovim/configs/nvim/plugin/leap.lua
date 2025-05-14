local leap = require('leap')
leap.opts.case_sensitive = true
leap.opts.labels = 'oesrtnaicu,fdlw.xhmkz/-vgzqbp'
leap.opts.safe_labels = leap.opts.labels

-- Keys:
--   - use `l` to leap forward, and `h` to leap backward
--   - for a single-letter jump, press a letter, then <cr>
--   - press <cr> to repeat jump, or <backspace> to repeat in the opposite direction
--   - use `j` for a [j]ump to another window
--   - from now on, f F t T , ; and k are free !
-- All the movements are possible with leap.
-- Especially when one has arrows and pgup,pgdn,home,end on a separate layer :)

vim.keymap.set({'n', 'x', 'o'}, 'l',  '<Plug>(leap-forward)')
vim.keymap.set({'n', 'x', 'o'}, 'h',  '<Plug>(leap-backward)')
vim.keymap.set({'n', 'x', 'o'}, 'S', '<Plug>(leap-from-window)')

vim.keymap.set({'n', 'x', 'o'}, 'f', '<Nop>')
vim.keymap.set({'n', 'x', 'o'}, 'F', '<Nop>')
vim.keymap.set({'n', 'x', 'o'}, 't', '<Nop>')
vim.keymap.set({'n', 'x', 'o'}, 'T', '<Nop>')
vim.keymap.set({'n', 'x', 'o'}, ',', '<Nop>')
vim.keymap.set({'n', 'x', 'o'}, ';', '<Nop>')

_G.Slava.leap_active = false
_G.Slava.leap_augroup = vim.api.nvim_create_augroup('leap', {clear = true})

-- Indicate in statusline when leap is active
vim.api.nvim_create_autocmd('User', {
  pattern = 'LeapEnter',
  group = _G.Slava.leap_augroup,
  callback = function()
    _G.Slava.leap_active = true
  end
})
vim.api.nvim_create_autocmd('User', {
  pattern = 'LeapLeave',
  group = _G.Slava.leap_augroup,
  callback = function()
    _G.Slava.leap_active = false
  end
})
