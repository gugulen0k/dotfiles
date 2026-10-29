return {
	{
		url = "https://codeberg.org/evergarden/nvim.git",
		name = "evergarden",
		lazy = false,
		priority = 1000,
		opts = {
			theme = {
				variant = "winter",
				accent = "green",
			},
			editor = {
				-- same background as the main window instead of the default "mantle"
				completion = { color = "base" },
				cursor = { color = "green" },
			},
			overrides = function(colors)
				return {
					-- default border colour (surface0) is almost invisible on the menu background
					PmenuBorder = { fg = colors.overlay1, bg = colors.base },
				}
			end,
		},
		config = function(_, opts)
			require("evergarden").setup(opts)

			-- Highlight groups that should have a transparent background, whatever the colorscheme
			local transparent_groups = { "FloatBorder", "NormalFloat", "FzfLuaBorder" }

			-- Re-applied on every colorscheme load. Existing attributes (fg, style) are kept,
			-- only the background is cleared, so it works with any colorscheme.
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("TransparentFloats", { clear = true }),
				callback = function()
					for _, name in ipairs(transparent_groups) do
						vim.api.nvim_set_hl(0, name, { bg = "none", update = true })
					end
				end,
			})

			-- Must come after the autocmd above, otherwise it won't fire for this colorscheme
			vim.o.background = "light"
			vim.cmd.colorscheme("evergarden")
		end,
	},
}
