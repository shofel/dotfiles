if vim.g.did_load_lualine_plugin then
  return
end
vim.g.did_load_lualine_plugin = true

---Indicators for special modes,
---@return string status
local function extra_mode_status()
  -- recording macros
  local reg_recording = vim.fn.reg_recording()
  if reg_recording ~= '' then
    return ' @' .. reg_recording
  end
  -- executing macros
  local reg_executing = vim.fn.reg_executing()
  if reg_executing ~= '' then
    return ' @' .. reg_executing
  end
  -- ix mode (<C-x> in insert mode to trigger different builtin completion sources)
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'ix' then
    return '^X: (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)'
  end
  return ''
end

require('lualine').setup {
  globalstatus = true,
  tabline = {
    lualine_a = { {"mode", fmt = function (str) return str:sub(1, 1) end}, },
    lualine_b = {"branch", "diff", "diagnostics"},
    lualine_c = {
      {},
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {'tabs', mode = 1, max_length = vim.o.columns / 2},
      { extra_mode_status },
    },
  },
  options = {
    theme = 'auto',
    component_separators = { left = ""; right = ""; };
    section_separators   = { left = ""; right = ""; };
    always_divide_middle = true;
    globalstatus = true;
  },
  sections = {},

  winbar = {},
  extensions = { 'fzf', 'toggleterm', 'quickfix' },
}

vim.opt.laststatus = 3
