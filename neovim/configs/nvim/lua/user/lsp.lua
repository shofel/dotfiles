---@mod user.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

local M = {}

---Gets a 'ClientCapabilities' object, describing the LSP client capabilities
---Extends the object with capabilities provided by plugins.
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
  -- https://cmp.saghen.dev/installation.html#merging-lsp-capabilities
  local capabilities = {}
  capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
end

return M
