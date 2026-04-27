-- vim.pack.add({ "savq/melange-nvim" })
-- vim.pack.add({ "rose-pine/neovim" })
vim.pack.add({ "dgox16/oldworld.nvim" })

-- require("rose-pine").setup({
-- 	variant = "main", -- auto, main, moon, or dawn
-- 	dark_variant = "main", -- main, moon, or dawn
-- 	dim_inactive_windows = false,
-- 	extend_background_behind_borders = true,
--
-- 	styles = {
-- 		bold = true,
-- 		italic = true,
-- 		transparency = true,
-- 	},
-- })

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
