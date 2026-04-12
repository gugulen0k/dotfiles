-- Shared dependencies and no-config editor plugins
vim.pack.add({
	-- Shared dependencies used by multiple plugins
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",
	"antoinemadec/FixCursorHold.nvim",

	-- No-config editor enhancements
	"tpope/vim-surround",
	"tpope/vim-endwise",
	"tpope/vim-repeat",
	"tpope/vim-sleuth",
	"christoomey/vim-tmux-navigator",

	-- Language syntax support
	"vim-ruby/vim-ruby",
	"gugulen0k/tree-sitter-sheft",
})
