return {
	"romus204/tree-sitter-manager.nvim",
	opts = {
		ensure_installed = {
			"bash",
			"css",
			"dockerfile",
			"gitignore",
			"html",
			"javascript",
			"json",
			"python",
			"ruby",
			"typescript",
			"vue",
			"yaml",
			"zig",
		},
		highlight = true,
		languages = {
			sheft = {
				install_info = {
					url = "https://github.com/gugulen0k/tree-sitter-sheft",
					use_repo_queries = true,
				},
			},
		},
	},
}
