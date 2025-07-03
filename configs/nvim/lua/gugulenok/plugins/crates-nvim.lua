return {
	"saecki/crates.nvim",
	tag = "stable",
	event = { "BufRead Cargo.toml" },
	config = function()
		local crates = require("crates")

		crates.setup({
			popup = {
				border = "single",
			},
			completion = {
				cmp = {
					enabled = false, -- Disable nvim-cmp integration
				},
				crates = {
					enabled = true,
					max_results = 8,
					min_chars = 3,
				},
			},
			-- Enable blink.cmp integration via LSP
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		})

		-- Your existing keymaps remain the same
		local opts = { silent = true }
		local utils = require("gugulenok.utils")

		opts.desc = "Toggle crates plugin"
		utils.map("n", "<leader>ct", crates.toggle, opts)

		opts.desc = "Reload crates plugin"
		utils.map("n", "<leader>cr", crates.reload, opts)

		------------------------ [ Show ] ----------------------------
		opts.desc = "Show versions popup"
		utils.map("n", "<leader>cv", crates.show_versions_popup, opts)

		opts.desc = "Show features popup"
		utils.map("n", "<leader>cf", crates.show_features_popup, opts)

		opts.desc = "Show dependencies popup"
		utils.map("n", "<leader>cd", crates.show_dependencies_popup, opts)
		--------------------------------------------------------------

		------------------------ [ Update ] ----------------------------
		opts.desc = "Update crate under the cursor"
		utils.map("n", "<leader>cu", crates.update_crate, opts)

		opts.desc = "Update visually selected crates"
		utils.map("v", "<leader>cu", crates.update_crates, opts)

		opts.desc = "Update all crates in current buffer"
		utils.map("n", "<leader>ca", crates.update_all_crates, opts)
		----------------------------------------------------------------

		------------------------ [ Upgrade ] ----------------------------
		opts.desc = "Upgrade all crates in current buffer"
		utils.map("n", "<leader>cU", crates.upgrade_crate, opts)

		opts.desc = "Upgrade visually selected crates"
		utils.map("v", "<leader>cU", crates.upgrade_crates, opts)

		opts.desc = "Upgrade all crates in current buffer"
		utils.map("n", "<leader>cA", crates.upgrade_all_crates, opts)
		-----------------------------------------------------------------

		------------------------ [ TOML manipulations] ----------------------------
		opts.desc = "Expand plain crate to inline table"
		utils.map("n", "<leader>cx", crates.expand_plain_crate_to_inline_table, opts)

		opts.desc = "Extract crate into table"
		utils.map("n", "<leader>cX", crates.extract_crate_into_table, opts)
		---------------------------------------------------------------------------

		------------------------ [ Open URLs ] ----------------------------
		opts.desc = "Open crate homepage"
		utils.map("n", "<leader>cH", crates.open_homepage, opts)

		opts.desc = "Open crate repository"
		utils.map("n", "<leader>cR", crates.open_repository, opts)

		opts.desc = "Open crate documentation"
		utils.map("n", "<leader>cD", crates.open_documentation, opts)

		opts.desc = "Open crates io page"
		utils.map("n", "<leader>cC", crates.open_crates_io, opts)
		-------------------------------------------------------------------
	end,
}
