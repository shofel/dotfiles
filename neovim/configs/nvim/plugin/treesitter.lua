-- @see https://github.com/nvim-treesitter/nvim-treesitter

-- TODO textobjects https://github.com/nvim-treesitter/nvim-treesitter-textobjects

require('treesitter-context').setup {
  max_lines = 2,
}

require('ts_context_commentstring').setup()
