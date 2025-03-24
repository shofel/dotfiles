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
