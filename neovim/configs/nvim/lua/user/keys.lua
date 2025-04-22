---@mod plugin.keymaps

M = {}

_G.keymap = vim.keymap
local diagnostic = vim.diagnostic

keymap.set('n', '<c-s>', '<cmd>w!<cr>', { silent = true, desc = 'Save buffer'})
keymap.set('n', '<space>;', ':')

-- Remove buffer
;(function ()
  local b = require('mini.bufremove')
  b.setup()
  vim.keymap.set('n', '<space>bh', function() require('mini.bufremove').unshow() end)
  vim.keymap.set('n', '<space>bd', function() require('mini.bufremove').delete() end)
  vim.keymap.set('n', '<space>bw', function() require('mini.bufremove').wipeout() end)
end)()

-- Copy
vim.keymap.set('x', '<LeftRelease>', '"*ygv')
vim.keymap.set('x', '<space>yp', '"+y', {desc = 'yank to plus'})
vim.keymap.set('x', '<space>ys', '"*y', {desc = 'yank to star'})

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

--- Keymap-agnostic mappings in insert mode
--- To make cyrillic a bit easier
keymap.set('i', '<C-backspace>', '<c-w>')

--- LSP keymaps

function M.set_lsp_keymaps (bufnr, client)
  local function opts(description)
    return { unique = true, silent = true, buffer = bufnr, desc = description }
  end
  keymap.set('n', 'gD', vim.lsp.buf.declaration, opts('go to declaration'))
  keymap.set('n', 'gd', vim.lsp.buf.definition, opts('go to definition'))
  keymap.set('n', '<space>gt', vim.lsp.buf.type_definition, opts('go to type definition'))
  keymap.set('n', '<space>gi', vim.lsp.buf.implementation, opts('go to implementation'))
  keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts('signature help'))

  keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts('lsp add [w]orksp[a]ce folder'))
  keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts('lsp [w]orkspace folder [r]emove'))
  keymap.set('n', '<space>wl', -- list workspace folders
    function() vim.print(vim.lsp.buf.list_workspace_folders()) end,
    opts('lsp [w]orkspace folders [l]ist'))
  keymap.set('n', '<space>ws', vim.lsp.buf.workspace_symbol, opts('lsp [w]orkspace symbol'))

  keymap.set('n', '<space>dd', vim.lsp.buf.document_symbol, opts('lsp [dd]ocument symbol'))
  keymap.set('n', '<space>lr', vim.lsp.codelens.run, opts('lsp run code lens'))
  keymap.set('n', '<space>ll', vim.lsp.codelens.refresh, opts('lsp [c]ode lenses [r]efresh'))

  keymap.set('n', 'grf', -- lsp buf format
    function() vim.lsp.buf.format { async = true } end,
    opts('lsp buf format'))

  keymap.set('n', '<space>th', -- toggle inlay hints
  function() if client and client.server_capabilities.inlayHintProvider then
    local current_setting = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
    vim.lsp.inlay_hint.enable(not current_setting, { bufnr = bufnr })
  end end, opts('toggle inlay hints'))
end

return M
