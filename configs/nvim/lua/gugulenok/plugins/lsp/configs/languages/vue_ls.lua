local M = {}

M.config = {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json", "vue.config.js", "nuxt.config.js", ".git" },
	init_options = {
		vue = { hybridMode = false },
	},
}

M.enable = true

return M
