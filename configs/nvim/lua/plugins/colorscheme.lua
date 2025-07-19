return {
	"savq/melange-nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		vim.o.background = "light"

		vim.cmd.colorscheme("melange")

		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

		vim.api.nvim_set_hl(0, "NeotestFailed", { fg = "#C77B8B" })
		vim.api.nvim_set_hl(0, "NeotestPassed", { fg = "#6E9B72" })
		vim.api.nvim_set_hl(0, "NeotestRunning", { fg = "#BC5C00" })
	end,
}
