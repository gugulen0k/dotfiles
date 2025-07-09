-- return {}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local function show_macro_recording()
			local recording_register = vim.fn.reg_recording()
			if recording_register == "" then
				return ""
			else
				return "Recording @" .. recording_register
			end
		end

		require("lualine").setup({
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
				always_divide_middle = true,
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
						colored = true, -- Displays diagnostics status in color if set to true.
						update_in_insert = true, -- Update diagnostics in insert mode.
					},
				},
				lualine_c = {
					-- {
					--   'filename',
					--   file_status    = true,  -- Displays file status (readonly status, modified status)
					--   newfile_status = false, -- Display new file status (new file means no write after created)
					--   -- path           = 1,     -- Displays full file path
					--   symbols        = {
					--     modified = '', -- Text to show when the file is modified.
					--     readonly = '', -- Text to show when the file is non-modifiable or readonly.
					--     unnamed  = '[No Name]', -- Text to show for unnamed buffers.
					--     newfile  = '[New]', -- Text to show for newly created file before first write
					--   }
					-- },
					{
						"macro-recording",
						fmt = show_macro_recording,
					},
					function()
						return require("lsp-progress").progress()
					end,
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
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		})

		vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			group = "lualine_augroup",
			pattern = "LspProgressStatusUpdated",
			callback = require("lualine").refresh,
		})
	end,
}
