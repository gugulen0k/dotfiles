return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"olimorris/neotest-rspec",
	},
	config = function()
		local status_ok, neotest = pcall(require, "neotest")
		if not status_ok then
			return
		end

		local rspec = require("neotest-rspec")
		local utils = require("gugulenok.utils")

		neotest.setup({
			summary = {
				open = "botright vsplit | vertical resize 80",
			},
			adapters = {
				rspec,
			},
		})

		utils.map("n", "<leader>nr", "<cmd>lua require('neotest').run.run()<cr>", { desc = "Run nearest test" })
		utils.map("n", "<leader>ns", "<cmd>lua require('neotest').run.stop()<cr>", { desc = "Stop test" })
		utils.map("n", "<leader>no", "<cmd>lua require('neotest').output.open()<cr>", { desc = "Show test output" })
		utils.map("n", "<leader>nv", "<cmd>lua require('neotest').summary.toggle()<cr>", { desc = "Toggle summary" })
		utils.map(
			"n",
			"<leader>nf",
			"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
			{ desc = "Run current file" }
		)
		utils.map(
			"n",
			"<leader>na",
			"<cmd>lua require('neotest').run.run({ suite = true })<cr>",
			{ desc = "Run all tests" }
		)
		utils.map(
			"n",
			"<leader>nd",
			"<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
			{ desc = "Debug nearest test" }
		)
		utils.map(
			"n",
			"<leader>nn",
			"<cmd>lua require('neotest').run.attach()<cr>",
			{ desc = "Attach to nearest test" }
		)
		utils.map(
			"n",
			"<leader>np",
			"<cmd>lua require('neotest').output_panel.toggle()<cr>",
			{ desc = "Toggle output panel" }
		)
		utils.map(
			"n",
			"<leader>nc",
			"<cmd>lua require('neotest').run.run({ suite = true, env = { CI = true } })<cr>",
			{ desc = "Run all tests with CI" }
		)
	end,
}
