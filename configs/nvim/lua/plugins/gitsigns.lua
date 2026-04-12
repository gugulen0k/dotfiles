vim.pack.add({ "lewis6991/gitsigns.nvim" })

require("gitsigns").setup({
	signs = {
		untracked = { text = "┇" },
	},
	signs_staged = {
		untracked = { text = "┇" },
	},
	current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> - <summary>",
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
		map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Stage hunk" })

		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Reset hunk" })

		map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
		map("n", "<leader>hb", gitsigns.blame, { desc = "Show blame in sidepanel" })
	end,
})
