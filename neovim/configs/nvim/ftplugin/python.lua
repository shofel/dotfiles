-- from nvim-lspconfig

local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json',
  '.git',
}

vim.lsp.start {
  name = 'basedpyright',
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, {upward = true})[1]),
  single_file_support = true,
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  }
}
