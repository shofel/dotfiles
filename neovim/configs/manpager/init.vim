colorscheme catppuccin
set laststatus=0
set cmdheight=0

noremap <space>/ <cmd>FzfLua blines<cr>

" +Man!
lua vim.schedule(function() vim.cmd[[Man!]] end)
