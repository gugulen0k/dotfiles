return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = { left = "|", right = "|" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
			ignore_focus = {},
			globalstatus = true,
			refresh = {
				statusline = 1000,
				tabline = 1000,
				winbar = 1000,
			},
		},
		sections = {
			lualine_a = {
				{
					"mode",
					fmt = function(str)
						return str:sub(1, 1)
					end,
				},
			},
			lualine_b = {
				{
					"diff",
					colored = true,
					symbols = { added = " ", modified = " ", removed = " " },
				},
				{
					"diagnostics",
					sections = { "error", "warn" },
					symbols = { error = " ", warn = " " },
					colored = true,
					update_in_insert = true,
				},
			},
			lualine_c = {
				"lsp_status",
				{
					"macro-recording",
					fmt = function()
						local recording_register = vim.fn.reg_recording()
						if recording_register == "" then
							return ""
						else
							return "Recording @" .. recording_register
						end
					end,
				},
			},
			lualine_x = { "filetype" },
			lualine_y = {
				{ "progress" },
				{ "searchcount" },
			},
			lualine_z = {
				{ "branch", icon = "" },
			},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {
			lualine_b = { "filename" },
		},
		inactive_winbar = {
			lualine_b = { "filename" },
		},
		extensions = {},
	},
}
