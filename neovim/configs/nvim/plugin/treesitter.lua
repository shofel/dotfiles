-- @see https://github.com/nvim-treesitter/nvim-treesitter

-- TODO textobjects https://github.com/nvim-treesitter/nvim-treesitter-textobjects

require('treesitter-context').setup {
  max_lines = 2,
}

require('ts_context_commentstring').setup()


-- Use treesitter for syntax highlighting and indentation
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'lua', 'vim', 'vimdoc', 'javascript',
             'typescript', 'html', 'python', 'nix'},
  callback = function()
    vim.treesitter.start() -- start syntax highlighting
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
