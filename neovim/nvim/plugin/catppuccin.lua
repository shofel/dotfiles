if vim.g.did_load_catppuccin_plugin then
  return
end
vim.g.did_load_catppuccin_plugin = true

vim.cmd.colorscheme 'catppuccin-frappe'

vim.schedule(
  function ()
    require('catppuccin').setup({
      flavour = "frappe",
      custom_highlights = function(colors)
        return {
          Comment = { fg = colors.subtext0 },
        }
      end
    })
    vim.cmd.colorscheme 'catppuccin-frappe'
  end
)
