local M = {}

M.config = {
	cmd = { "solargraph", "stdio" },
	filetypes = { "ruby" },
	root_markers = { "Gemfile", ".git" },
	settings = {
		solargraph = {
			diagnostics = true,
			completion = {
				enable = true,
				triggerCharacters = { ".", ":", "::" },
				debounce = 100,
				maxItems = 100,
			},
			hover = { enable = true, delay = 100 },
		},
	},
}

M.enable = true

return M
