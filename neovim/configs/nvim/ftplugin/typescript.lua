vim.cmd('packadd typescript-tools.nvim')
require('typescript-tools').setup({})

vim.cmd('LspStart') -- a hack. It worked without this line
