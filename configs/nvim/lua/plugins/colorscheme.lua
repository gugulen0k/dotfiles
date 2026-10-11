vim.pack.add({ "dgox16/oldworld.nvim" })

require("oldworld").setup({
	variant = "default", -- default, oled, cooler
	styles = {
		-- You can pass the style using the format: style = true
		comments = { italic = true, bold = true },
		keywords = { italic = true },
		identifiers = { italic = true },
		functions = { italic = true },
		variables = {},
		booleans = { italic = true },
	},
})

vim.o.background = "dark"
vim.cmd.colorscheme("oldworld")

vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FzfLuaBorder", { bg = "none" })
