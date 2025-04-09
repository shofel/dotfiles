---@mod plugin.keymaps

M = {}

local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local diagnostic = vim.diagnostic

-- Save file
keymap.set('n', '<C-s>', '<cmd>w<cr>', { silent = true, desc = 'Save buffer'})

-- Remove buffer
vim.keymap.set('n', '<space>bh', function() require('mini.bufremove').unshow() end)
vim.keymap.set('n', '<space>bd', function() require('mini.bufremove').delete() end)
vim.keymap.set('n', '<space>bw', function() require('mini.bufremove').wipeout() end)

-- Arrows
vim.keymap.set({'n','x','i', 'o'}, '<A-j>', '<Left>', {noremap = false})
vim.keymap.set({'n','x','i', 'o'}, '<A-k>', '<Enter>', {noremap = false})
vim.keymap.set({'n','x','i', 'o'}, '<A-l>', '<Right>', {noremap = false})
vim.keymap.set({'n','x','i', 'o'}, '<A-i>', '<Up>', {noremap = false})
vim.keymap.set({'n','x','i', 'o'}, '<A-,>', '<Down>', {noremap = false})

-- Copy with mouse
vim.keymap.set('x', '<LeftRelease>', '"*ygv')

-- Toggle the quickfix list (only opens if it is populated)
local function toggle_qf_list()
  local qf_exists = false
  for _, win in pairs(fn.getwininfo() or {}) do
    if win['quickfix'] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd.cclose()
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd.copen()
  end
end

keymap.set('n', '<C-c>', toggle_qf_list, { desc = 'toggle quickfix list' })

local function try_fallback_notify(opts)
  local success, _ = pcall(opts.try)
  if success then
    return
  end
  success, _ = pcall(opts.fallback)
  if success then
    return
  end
  vim.notify(opts.notify, vim.log.levels.INFO)
end

-- Cycle the quickfix and location lists
local function cleft()
  try_fallback_notify {
    try = vim.cmd.cprev,
    fallback = vim.cmd.clast,
    notify = 'Quickfix list is empty!',
  }
end

local function cright()
  try_fallback_notify {
    try = vim.cmd.cnext,
    fallback = vim.cmd.cfirst,
    notify = 'Quickfix list is empty!',
  }
end

keymap.set('n', '[c', cleft, { silent = true, desc = '[c]ycle quickfix left' })
keymap.set('n', ']c', cright, { silent = true, desc = '[c]ycle quickfix right' })

local function lleft()
  try_fallback_notify {
    try = vim.cmd.lprev,
    fallback = vim.cmd.llast,
    notify = 'Location list is empty!',
  }
end

local function lright()
  try_fallback_notify {
    try = vim.cmd.lnext,
    fallback = vim.cmd.lfirst,
    notify = 'Location list is empty!',
  }
end

keymap.set('n', '[l', lleft, { silent = true, desc = 'cycle [l]oclist left' })
keymap.set('n', ']l', lright, { silent = true, desc = 'cycle [l]oclist right' })
keymap.set('n', '[L', vim.cmd.lfirst, { silent = true, desc = 'first [L]oclist entry' })
keymap.set('n', ']L', vim.cmd.llast, { silent = true, desc = 'last [L]oclist entry' })

-- Resize vertical splits
local toIntegral = math.ceil
keymap.set('n', '<space>w+', function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
end, { silent = true, desc = 'inc window [w]idth' })
keymap.set('n', '<space>w-', function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
end, { silent = true, desc = 'dec window [w]idth' })
keymap.set('n', '<space>h+', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
end, { silent = true, desc = 'inc window [h]eight' })
keymap.set('n', '<space>h-', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
end, { silent = true, desc = 'dec window [h]eight' })

-- Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'switch to normal mode' })
keymap.set('t', '<C-Esc>', '<Esc>', { desc = 'send Esc to terminal' })

-- Shortcut for expanding to current buffer's directory in command mode
keymap.set('c', '%%', function()
  if fn.getcmdtype() == ':' then
    return fn.expand('%:h') .. '/'
  else
    return '%%'
  end
end, { expr = true, desc = "expand to current buffer's directory" })

keymap.set('n', '<space>tn', vim.cmd.tabnew, { desc = '[t]ab: [n]ew' })
keymap.set('n', '<space>tq', vim.cmd.tabclose, { desc = '[t]ab: [q]uit/close' })

local severity = diagnostic.severity

keymap.set('n', '<space>e', function()
  local _, winid = diagnostic.open_float(nil, { scope = 'line' })
  if not winid then
    vim.notify('no diagnostics found', vim.log.levels.INFO)
    return
  end
  vim.api.nvim_win_set_config(winid or 0, { focusable = true })
end, { noremap = true, silent = true, desc = 'diagnostics floating window' })
keymap.set('n', '[dd', diagnostic.goto_prev, { noremap = true, silent = true, desc = 'previous [d]iagnostic' })
keymap.set('n', ']dd', diagnostic.goto_next, { noremap = true, silent = true, desc = 'next [d]iagnostic' })
keymap.set('n', '[de', function()
  diagnostic.goto_prev { severity = severity.ERROR, }
end, { noremap = true, silent = true, desc = 'previous [e]rror diagnostic' })
keymap.set('n', ']de', function()
  diagnostic.goto_next { severity = severity.ERROR, }
end, { noremap = true, silent = true, desc = 'next [e]rror diagnostic' })
keymap.set('n', '[dw', function()
  diagnostic.goto_prev { severity = severity.WARN, }
end, { noremap = true, silent = true, desc = 'previous [w]arning diagnostic' })
keymap.set('n', ']dw', function()
  diagnostic.goto_next { severity = severity.WARN, }
end, { noremap = true, silent = true, desc = 'next [w]arning diagnostic' })
keymap.set('n', '[dh', function()
  diagnostic.goto_prev { severity = severity.HINT, }
end, { noremap = true, silent = true, desc = 'previous [h]int diagnostic' })
keymap.set('n', ']dh', function()
  diagnostic.goto_next { severity = severity.HINT, }
end, { noremap = true, silent = true, desc = 'next [h]int diagnostic' })

local function buf_toggle_diagnostics()
  local filter = { bufnr = api.nvim_get_current_buf() }
  diagnostic.enable(not diagnostic.is_enabled(filter), filter)
end

keymap.set('n', '<space>dt', buf_toggle_diagnostics)

local function toggle_spell_check()
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.opt.spell = not (vim.opt.spell:get())
end

keymap.set('n', '<space>S', toggle_spell_check, { noremap = true, silent = true, desc = 'toggle [S]pell' })

--- Keymap-agnostic mappings in insert mode
--- To make cyrillic a bit easier
keymap.set('i', '<C-backspace>', '<c-w>')

--- LSP keymaps

function M.set_lsp_keymaps (bufnr, client)
  local function desc(description)
    return { unique = true, silent = true, buffer = bufnr, desc = description }
  end
  keymap.set('n', 'gD', vim.lsp.buf.declaration, desc('lsp [g]o to [D]eclaration'))
  keymap.set('n', 'gd', vim.lsp.buf.definition, desc('lsp [g]o to [d]efinition'))
  keymap.set('n', 'K', vim.lsp.buf.hover, desc('[lsp] hover'))
  keymap.set('n', '<space>gt', vim.lsp.buf.type_definition, desc('lsp [g]o to [t]ype definition'))
  keymap.set('n', '<space>gi', vim.lsp.buf.implementation, desc('lsp [g]o to [i]mplementation'))
  keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, desc('[lsp] signature help'))

  keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, desc('lsp add [w]orksp[a]ce folder'))
  keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, desc('lsp [w]orkspace folder [r]emove'))
  keymap.set('n', '<space>wl', -- list workspace folders
    function() vim.print(vim.lsp.buf.list_workspace_folders()) end,
    desc('[lsp] [w]orkspace folders [l]ist'))
  keymap.set('n', '<space>ws', vim.lsp.buf.workspace_symbol, desc('lsp [w]orkspace symbol'))

  keymap.set('n', '<space>dd', vim.lsp.buf.document_symbol, desc('lsp [dd]ocument symbol'))
  keymap.set('n', '<space>ca', vim.lsp.buf.code_action, desc('[lsp] code action'))
  keymap.set('n', '<space>lr', vim.lsp.codelens.run, desc('[lsp] run code lens'))
  keymap.set('n', '<space>ll', vim.lsp.codelens.refresh, desc('lsp [c]ode lenses [r]efresh'))

  keymap.set('n', 'grf', -- lsp buf format
    function() vim.lsp.buf.format { async = true } end,
    desc('lsp buf format'))

  keymap.set('n', '<space>th', -- toggle inlay hints
  function() if client and client.server_capabilities.inlayHintProvider then
    local current_setting = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
    vim.lsp.inlay_hint.enable(not current_setting, { bufnr = bufnr })
  end end, desc('toggle inlay hints'))
end

return M
