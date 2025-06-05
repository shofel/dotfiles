vim.lsp.enable({
  'clangd',
  'luals',
  'nil_ls',
  'fish-lsp',
  'bash-lsp',
})

vim.cmd('packadd typescript-tools.nvim')
require('typescript-tools').setup({})
