-- proxy table to postpone access to fzf-lua
local fzf = {}
local mt = {
  __index = function (_,k)
    return function ()
      if next(fzf) == nil then
        vim.cmd.packadd('fzf-lua')
        fzf = require('fzf-lua')
        fzf.setup({'max-perf'})
      end
      require('fzf-lua')[k]()
    end
  end
}
setmetatable(fzf, mt)

vim.keymap.set('n', '<space>f',  '<nop>',              {desc = 'fzf'})
vim.keymap.set('n', '<space>fc', fzf.command_history,  {desc = 'command history'})
vim.keymap.set('n', '<space>fC', fzf.commands,         {desc = 'commands'})
vim.keymap.set('n', '<space>fg', fzf.live_grep_native, {desc = 'live grep native'})
vim.keymap.set('n', '<space>fh', fzf.helptags,         {desc = 'helptags'})
vim.keymap.set('n', '<space>fi', fzf.git_files,        {desc = 'git files'})
vim.keymap.set('n', '<space>fl', fzf.files,            {desc = 'files'})
vim.keymap.set('n', '<space>fk', fzf.keymaps,          {desc = 'keymaps'})
vim.keymap.set('n', '<space>fm', fzf.resume,           {desc = 'resume'})
vim.keymap.set('n', '<space>fn', fzf.builtin,          {desc = 'builtin'})
vim.keymap.set('n', '<space>fr', fzf.git_branches,     {desc = 'git branches'})
vim.keymap.set('n', '<space>fs', fzf.git_status,       {desc = 'git status'})
vim.keymap.set('n', '<space>ft', fzf.tabs,             {desc = 'tabs'})
vim.keymap.set('n', '<space>fu', fzf.buffers,          {desc = 'buffers'})
vim.keymap.set('n', '<space>fw', fzf.grep_cword,       {desc = 'cword'})
vim.keymap.set('n', '<space>fW', fzf.grep_cWORD,       {desc = 'cWORD'})

vim.keymap.set('n', '<space>/', fzf.blines,      {desc = 'blines'})
vim.keymap.set('v', '<space>f', fzf.grep_visual, {desc = 'grep visual'})

-- In case some other plugin requires fzf. Let's say `:NoiceFzf`
require('lze').load({
  'fzf-lua',
  on_require = 'fzf'
})
