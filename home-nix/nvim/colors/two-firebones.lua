local colors_name = "two-firebones"
vim.g.colors_name = colors_name -- Required when defining a colorscheme

local lush = require "lush"
local hsl = lush.hsl
local util = require "zenbones.util"

---@diagnostic disable: undefined-field
local bg = vim.o.background:get()
---@diagnostic enable: undefined-field

-- Define a palette. Use `palette_extend` to fill unspecified colors
-- Based on https://github.com/gruvbox-community/gruvbox#palette
local palette

if bg == "light" then
  palette = util.palette_extend({
    bg      = hsl( 36, 33, 97),
    wood    = hsl( 40, 90, 40),
    fg      = hsl( 40, 90, 20),
    sky     = hsl( 40, 90, 40),
    water   = hsl(210, 90, 20),
    rose    = hsl(210, 60, 60),
    leaf    = hsl(210, 45, 70),
    blossom = hsl(  0, 60, 55),
  }, bg)
else
  palette = util.palette_extend({
    bg      = hsl(220, 15, 15),
    wood    = hsl(210, 45, 50),
    fg      = hsl(210, 25, 80),
    sky     = hsl(210, 45, 50),
    water   = hsl(  0, 25, 80),
    rose    = hsl(  0, 60, 60),
    leaf    = hsl(  0, 45, 70),
    blossom = hsl(  0, 60, 55),
  }, bg)
end

-- Generate the lush specs using the generator util
local generator = require "zenbones.specs"
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

-- Optionally extend specs using Lush
local specs = lush.extends({ base_specs }).with(function()
  return {
  ---@diagnostic disable: undefined-global
    Statement { base_specs.Statement, fg = palette.rose, gui = 'none'},
    Special { fg = palette.sky },
    Type { fg = palette.sky, gui = "italic" },
  ---@diagnostic enable: undefined-global
  }
end)

-- Pass the specs to lush to apply
lush(specs)

-- TODO generate lualine theme
require("lualine").setup {
  options = { theme = "one" .. bg },
}

-- Optionally set term colors
-- require("zenbones.term").apply_colors(palette)

-- Terminal colors {{{
vim.g.terminal_color_0  = ''
vim.g.terminal_color_8  = ''
vim.g.terminal_color_1  = '#e06c75'
vim.g.terminal_color_9  = '#e06c75'
vim.g.terminal_color_2  = '#98c379'
vim.g.terminal_color_10 = '#98c379'
vim.g.terminal_color_3  = '#e5c07b'
vim.g.terminal_color_11 = '#e5c07b'
vim.g.terminal_color_4  = '#61afef'
vim.g.terminal_color_12 = '#61afef'
vim.g.terminal_color_5  = '#c678dd'
vim.g.terminal_color_13 = '#c678dd'
vim.g.terminal_color_6  = '#56b6c2'
vim.g.terminal_color_14 = '#56b6c2'
vim.g.terminal_color_7  = ''
vim.g.terminal_color_15 = ''

if bg == 'light' then
  vim.g.terminal_color_0  = '#282c34'
  vim.g.terminal_color_8  = '#4d4d4d'
  vim.g.terminal_color_7  = '#737780'
  vim.g.terminal_color_15 = '#a1a7b3'
else -- Dark
  vim.g.terminal_color_0  = '#000000'
  vim.g.terminal_color_8  = '#4d4d4d'
  vim.g.terminal_color_7  = '#737780'
  vim.g.terminal_color_15 = '#a1a7b3'
end
-- }}}
