vim.pack.add({ "dgox16/oldworld.nvim" })

require("oldworld").setup({
	variant = "default",
	styles = {
		comments = { bold = true },
		keywords = { italic = true },
	},
})

vim.o.background = "dark"
vim.cmd.colorscheme("oldworld")

vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
