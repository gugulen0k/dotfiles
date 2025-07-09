---------- [ Setup for relative imports ] ----------
local utils = require("gugulenok.utils")
local current_dir = utils.base_path("gugulenok.plugins.oil")
----------------------------------------------------

return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require("oil")
		local git_files = current_dir.require("utils.git_files")
		local file_details = current_dir.require("utils.file_details")

		function _G.get_oil_winbar()
			local dir = oil.get_current_dir()
			if dir then
				return vim.fn.fnamemodify(dir, ":~")
			else
				-- If there is no current directory (e.g. over ssh), just show the buffer name
				return vim.api.nvim_buf_get_name(0)
			end
		end

		oil.setup({
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			watch_for_changes = true,
			constraint_cursor = "name",
			win_options = {
				-- winbar = "%!v:lua.get_oil_winbar()"
			},
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, _)
					return name == ".." or name == ".git"
				end,
				is_hidden_file = function(name, bufnr)
					git_files.setup({ name = name, bufnr = bufnr })
				end,
			},
			use_default_keymaps = false,
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-p>"] = "actions.preview",
				["<C-c>"] = false,
				["q"] = "actions.close",
				["<C-u>"] = "actions.refresh",
				["g."] = "actions.toggle_hidden",
				["gd"] = {
					desc = "Toggle file detail view",
					callback = function()
						file_details.setup()
					end,
				},
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
			},
			-- Configuration for the floating window in oil.open_float
			float = {
				padding = 2,
				max_width = 0.7,
				max_height = 0.7,
			},
		})

		utils.map("n", "-", function()
			oil.open_float()
		end, { desc = "Open parent directory" })
	end,
}
