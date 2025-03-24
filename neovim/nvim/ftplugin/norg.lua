vim.wo.foldlevel = 99
vim.wo.conceallevel = 2

-- @see https://github.com/nvim-neorg/neorg/wiki/Default-Keybinds#normal-mode-1

vim.keymap.set('n', ',cm',
  '<Plug>(neorg.looking-glass.magnify-code-block)',
  {buffer = true; desc = 'code magnify'})
vim.keymap.set('n', ',id',
  '<Plug>(neorg.tempus.insert-date)',
  {buffer = true; desc = 'insert date'})

-- List
vim.keymap.set('n', ',li',
  '<Plug>(neorg.pivot.list.invert)',
  {buffer = true; desc = 'list invert'})
vim.keymap.set('n', ',lt',
  '<Plug>(neorg.pivot.list.toggle)',
  {buffer = true; desc = 'list toggle'})

-- Tasks
vim.keymap.set('n', ',ta',
  '<Plug>(neorg.qol.todo-items.todo.task-ambiguous)',
  {buffer = true; desc = 'mark task as ambiguous'})
vim.keymap.set('n', ',tc',
  '<Plug>(neorg.qol.todo-items.todo.task-cancelled)',
  {buffer = true; desc = 'mark task as cancelled'})
vim.keymap.set('n', ',td',
  '<Plug>(neorg.qol.todo-items.todo.task-done)',
  {buffer = true; desc = 'mark task as done'})
vim.keymap.set('n', ',th',
  '<Plug>(neorg.qol.todo-items.todo.task-on-hold)',
  {buffer = true; desc = 'mark task as on hold'})
vim.keymap.set('n', ',ti',
  '<Plug>(neorg.qol.todo-items.todo.task-important)',
  {buffer = true; desc = 'mark task as important'})
vim.keymap.set('n', ',tp',
  '<Plug>(neorg.qol.todo-items.todo.task-pending)',
  {buffer = true; desc = 'mark task as pending'})
vim.keymap.set('n', ',tr',
  '<Plug>(neorg.qol.todo-items.todo.task-recurring)',
  {buffer = true; desc = 'mark task as recurring'})
vim.keymap.set('n', ',tu',
  '<Plug>(neorg.qol.todo-items.todo.task-undone)',
  {buffer = true; desc = 'mark task as undone'})
