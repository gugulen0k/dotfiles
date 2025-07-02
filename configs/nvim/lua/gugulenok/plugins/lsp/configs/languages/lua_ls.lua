local M = {}

M.config = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", "stylua.toml", ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = {
					vim.fn.expand("$VIMRUNTIME/lua"),
					vim.fn.expand("$XDG_CONFIG_HOME") .. "/nvim/lua",
				},
				checkThirdParty = false,
			},
			telemetry = { enable = false },
			hint = { enable = true },
		},
	},
}

M.enable = true

return M
