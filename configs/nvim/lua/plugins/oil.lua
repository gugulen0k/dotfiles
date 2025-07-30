return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require("oil")
		local detail = false

		oil.setup({
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			watch_for_changes = true,
			constraint_cursor = "name",
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, _)
					return name == ".." or name == ".git"
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
						detail = not detail
						if detail then
							require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
						else
							require("oil").set_columns({ "icon" })
						end
					end,
				},
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["yp"] = {
					desc = "Copy relative path",
					callback = function()
						local entry = oil.get_cursor_entry()
						local dir = oil.get_current_dir()

						if not entry or not dir then
							return
						end

						local relpath = vim.fn.fnamemodify(dir, ":.")

						vim.fn.setreg("+", relpath .. entry.name)
					end,
				},
			},
			-- Configuration for the floating window in oil.open_float
			float = {
				padding = 2,
				max_width = 0.7,
				max_height = 0.7,
			},
		})

		vim.keymap.set("n", "-", function()
			oil.open_float()
		end, { desc = "Open parent directory" })
	end,
}
