---@mod plugin.keymaps

M = {}

_G.keymap = vim.keymap
local diagnostic = vim.diagnostic

keymap.set('n', '<c-s>', '<cmd>w<cr>', { silent = true, desc = 'Save buffer'})
keymap.set('n', '<space>;', ':')

-- Remove buffer
;(function ()
  local b = require('mini.bufremove')
  b.setup()
  vim.keymap.set('n', '<space>bh', function() require('mini.bufremove').unshow() end)
  vim.keymap.set('n', '<space>bd', function() require('mini.bufremove').delete() end)
  vim.keymap.set('n', '<space>bw', function() require('mini.bufremove').wipeout() end)
end)()

-- Arrows
;(function ()
  vim.keymap.set({'n','x','i', 'o'}, '<A-j>', '<Left>', {noremap = false})
  vim.keymap.set({'n','x','i', 'o'}, '<A-k>', '<Enter>', {noremap = false})
  vim.keymap.set({'n','x','i', 'o'}, '<A-l>', '<Right>', {noremap = false})
  vim.keymap.set({'n','x','i', 'o'}, '<A-i>', '<Up>', {noremap = false})
  vim.keymap.set({'n','x','i', 'o'}, '<A-,>', '<Down>', {noremap = false})
end)()

-- Copy with mouse
vim.keymap.set('x', '<LeftRelease>', '"*ygv')

-- Toggle the quickfix list (only opens if it is populated)
local function toggle_qf_list()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo() or {}) do
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

-- Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'switch to normal mode' })
keymap.set('t', '<C-Esc>', '<Esc>', { desc = 'send Esc to terminal' })

keymap.set('n', '<space>cd', ':cd %', {desc = 'cd %'})
keymap.set('n', '<space>tn', vim.cmd.tabnew, { desc = '[t]ab: [n]ew' })
keymap.set('n', '<space>tq', vim.cmd.tabclose, { desc = '[t]ab: [q]uit/close' })

local severity = vim.diagnostic.severity

keymap.set('n', '<space>e', function()
  local _, winid = vim.diagnostic.open_float(nil, { scope = 'line' })
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
  local filter = { bufnr = vim.api.nvim_get_current_buf() }
  diagnostic.enable(not diagnostic.is_enabled(filter), filter)
end

keymap.set('n', '<space>tl', buf_toggle_diagnostics, {unique = true, desc = 'toggle diagnostics'})

--- Keymap-agnostic mappings in insert mode
--- To make cyrillic a bit easier
keymap.set('i', '<C-backspace>', '<c-w>')

--- LSP keymaps

function M.set_lsp_keymaps (bufnr, client)
  local function desc(description)
    return { unique = true, silent = true, buffer = bufnr, desc = description }
  end
  keymap.set('n', 'gD', vim.lsp.buf.declaration, desc('go to declaration'))
  keymap.set('n', 'gd', vim.lsp.buf.definition, desc('go to definition'))
  keymap.set('n', '<space>gt', vim.lsp.buf.type_definition, desc('go to type definition'))
  keymap.set('n', '<space>gi', vim.lsp.buf.implementation, desc('go to implementation'))
  keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, desc('signature help'))

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
