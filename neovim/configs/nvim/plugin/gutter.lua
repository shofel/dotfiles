-- gitsigns
-- TODO do better than schedule
vim.schedule(function()
  require('gitsigns').setup {
    current_line_blame = false,
    current_line_blame_opts = {
      ignore_whitespace = true,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']h', function() vim.schedule(gs.next_hunk) return '<Ignore>' end, { expr = true, desc = 'git next hunk' })
      map('n', '[h', function() vim.schedule(gs.prev_hunk) return '<Ignore>' end, { expr = true, desc = 'git previous hunk' })

      -- Actions
      local stage_hunk = '<cmd>lua require("gitsigns").stage_hunk()<cr>'
      local reset_hunk = '<cmd>lua require("gitsigns").reset_hunk()<cr>'
      local blame_line = function() gs.blame_line { full = true } end
      map({'n'     }, '<space>h' , '<nop>'                        , {desc = 'git'})
      map({'n', 'v'}, '<space>ha', stage_hunk                     , {desc = 'git hunk add'})
      map({'n', 'v'}, '<space>hr', reset_hunk                     , {desc = 'git hunk discard'})
      map({'n',    }, '<space>hA', gs.stage_buffer                , {desc = 'git stage buffer'})
      map({'n',    }, '<space>hu', gs.undo_stage_hunk             , {desc = 'git hunk undo stage'})
      map({'n',    }, '<space>hR', gs.reset_buffer                , {desc = 'git buffer Reset'})
      map({'n',    }, '<space>hp', gs.preview_hunk                , {desc = 'git hunk preview'})
      map({'n',    }, '<space>hb', blame_line                     , {desc = 'git blame line (full)'})
      map({'n',    }, '<space>hB', gs.toggle_current_line_blame   , {desc = 'git toggle current line blame'})
      map({'n',    }, '<space>hd', gs.diffthis                    , {desc = 'git diff this'})
      map({'n',    }, '<space>hD', function() gs.diffthis('~') end, {desc = 'git Diff ~'})
      map({'n',    }, '<space>td', gs.toggle_deleted              , {desc = 'git toggle deleted'})

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'git hunk' })
    end,
  }
end)


--
-- statuscol
--

local builtin = require("statuscol.builtin")
require("statuscol").setup({
  relculright = true,
  segments = {
    {text = {builtin.foldfunc}, click = "v:lua.ScFa"},
    {text = {"%s"}, click = "v:lua.ScSa"},
    {text = {builtin.lnumfunc, " "}, click = "v:lua.ScLa"}
  }
})

--
-- ufo folds
--

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.keymap.set('n', '<space>tf', -- toggle foldcolumn
  function()
    vim.opt.foldcolumn = tostring(1 - tonumber(vim.opt.foldcolumn:get()))
  end, {desc = 'toggle foldcolumn'})

require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})
