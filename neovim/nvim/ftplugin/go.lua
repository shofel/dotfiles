
-- workaround for gopls not supporting semanticTokensProvider
-- https://github.com/golang/go/issues/54531#issuecomment-1464982242
vim.api.nvim_create_autocmd("LspAttach", {
  buffer = 0,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == 'gopls' then
      if not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        if semantic then
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = {
              tokenTypes = semantic.tokenTypes,
              tokenModifiers = semantic.tokenModifiers,
            },
            range = true,
          }
        end
      end
    end
  end
})
vim.g.did_set_gopls_onattach_hack = true


local gopls_cmd = 'gopls'

local root_files = {
  'go.mod',
  '.git',
}

vim.lsp.start {
  name = 'gopls',
  cmd = { gopls_cmd },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, {upward = true})[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
  -- @see https://www.lazyvim.org/extras/lang/go
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        fieldalignment = true,
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  },
}
