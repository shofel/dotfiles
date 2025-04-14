    vim.cmd.packadd 'catppuccin-nvim'
    require('catppuccin').setup({
      custom_highlights = function(colors)
        return {
          Comment = { fg = colors.subtext0 },
        }
      end
    })
    vim.cmd.colorscheme 'catppuccin'
