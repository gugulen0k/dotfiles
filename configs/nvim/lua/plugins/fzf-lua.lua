require("fzf-lua").setup({
	"default",
	winopts = {
		backdrop = 100,
		preview = {
			title = true,
			layout = "vertical",
		},
	},
})

local opts = { noremap = true, silent = true }

opts.desc = "Project file search"
vim.keymap.set("n", "<C-p>", "<cmd>FzfLua files<CR>", opts)

opts.desc = "Search inside opened buffers"
vim.keymap.set("n", "<leader>l", "<cmd>FzfLua buffers<CR>", opts)

opts.desc = "Search across files by text"
vim.keymap.set("n", "<leader>f", "<cmd>FzfLua live_grep_native<CR>", opts)

opts.desc = "Show methods in current buffer"
vim.keymap.set("n", "<leader>t", "<cmd>FzfLua btags<CR>", opts)
