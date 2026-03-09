local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.chalk = {
	install_info = {
		url = "https://github.com/gugulen0k/tree-sitter-chalk",
		files = { "src/parser.c" },
		branch = "main",
	},
	filetype = "ch",
}

return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"gugulen0k/tree-sitter-chalk",
	},
	lazy = false,
	config = function()
		require("nvim-treesitter.configs").setup({
			-- A list of parser names, or "all" (the listed parsers MUST always be installed)
			ensure_installed = {
				"chalk",
				"json",
				"javascript",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"vue",
				"ruby",
				"bash",
				"lua",
				"vim",
				"vimdoc",
				"dockerfile",
				"gitignore",
				"python",
				"zig",
			},

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			indent = { enable = true },
			highlight = { enable = true },
			matchup = { enable = true }, -- enable vim-matchup plugin
		})
	end,
}
