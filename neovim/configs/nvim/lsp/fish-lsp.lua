return {
  name = 'fish-lsp',
  cmd = { 'fish-lsp', 'start' },
  cmd_env = { fish_lsp_show_client_popups = false },
  filetypes = { 'fish' },
}
