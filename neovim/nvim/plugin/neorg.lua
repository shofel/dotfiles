if vim.g.did_load_shovel_neorg then return end
vim.g.did_load_shovel_neorg = true

vim.cmd 'packadd neorg'

require("neorg").setup {
  load = {
    ["core.defaults"] = {},
    ["core.concealer"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = {
          notes = "~/workspaces-one/01-notes/",
        },
        default_workspace = "notes",
      },
    },
  },
}
