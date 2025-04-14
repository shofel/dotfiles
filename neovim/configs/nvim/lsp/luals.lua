---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				library = vim.tbl_extend(
					"keep",
					{ vim.env.VIMRUNTIME, "${3rd}/luv/library" },
					vim.api.nvim_get_runtime_file("", true)
				),
			},
			telemetry = {
				enable = false,
			},
		},
	},
	filetypes = { "lua" },
	root_markers = { ".luarc.json", "luarc.lua", ".git" },
}
