local debounce = Snacks.util.debounce

local lint = debounce(function()
  require("lint").try_lint('eslint_d')
end, {ms = 500})

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
  buffer = 0,
  callback = lint,
})
