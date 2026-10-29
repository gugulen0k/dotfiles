return {
	"Wansmer/treesj",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
	keys = {
		{ "<space>m", "<cmd>TSJToggle<CR>", desc = "Toggle split/join" },
		{ "<space>j", "<cmd>TSJJoin<CR>", desc = "Join lines" },
		{ "<space>s", "<cmd>TSJSplit<CR>", desc = "Split lines" },
	},
}
