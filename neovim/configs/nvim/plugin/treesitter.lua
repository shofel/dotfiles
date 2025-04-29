local configs = require('nvim-treesitter.configs')

configs.setup {
  -- these options make no sense on nix. Keep them to seduce the linter.
  ensure_installed = {},
  ignore_install = {},
  modules = {},
  sync_install = false,
  auto_install = false, -- Do not automatically install missing parsers when entering buffer

  highlight = {
    enable = true,
    disable = function(_, buf)
      local max_filesize = 100 * 1024 -- 100 KiB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobject, similar to targets.vim
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['aC'] = '@class.outer',
        ['iC'] = '@class.inner',
        ['ac'] = '@call.outer',
        ['ic'] = '@call.inner',
        ['a#'] = '@comment.outer',
        ['i#'] = '@comment.inner',
        ['ai'] = '@conditional.outer',
        ['ii'] = '@conditional.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
      },
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']p'] = '@parameter.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']P'] = '@parameter.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[p'] = '@parameter.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[P'] = '@parameter.outer',
      },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ['<space>df'] = '@function.outer',
        ['<space>dc'] = '@class.outer',
      },
    },
  },
}

require('treesitter-context').setup {
  max_lines = 3,
}

require('ts_context_commentstring').setup()
