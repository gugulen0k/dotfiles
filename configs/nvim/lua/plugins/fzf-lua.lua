return {
	"ibhagwan/fzf-lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{ "junegunn/fzf", build = "./install --bin" },
	},
	opts = {
		"default",
		winopts = {
			backdrop = 100,
			border = "single",
			preview = {
				border = "single",
				title = true,
				layout = "vertical",
			},
		},
	},
	config = function(_, opts)
		require("fzf-lua").setup(opts)

		local map_opts = { noremap = true, silent = true }

		map_opts.desc = "Project file search"
		vim.keymap.set("n", "<C-p>", "<cmd>FzfLua files<CR>", map_opts)

		map_opts.desc = "Search inside opened buffers"
		vim.keymap.set("n", "<leader>l", "<cmd>FzfLua buffers<CR>", map_opts)

		map_opts.desc = "Search across files by text"
		vim.keymap.set("n", "<leader>f", "<cmd>FzfLua live_grep_native<CR>", map_opts)

		map_opts.desc = "Show methods in current buffer"
		vim.keymap.set("n", "<leader>t", "<cmd>FzfLua btags<CR>", map_opts)
	end,
}
