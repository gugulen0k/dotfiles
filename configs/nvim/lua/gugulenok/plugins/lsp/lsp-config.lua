---------- [ Setup for relative imports ] ----------
local utils = require("gugulenok.utils")
local current_dir = utils.base_path("gugulenok.plugins.lsp")
----------------------------------------------------

return {
	"neovim/nvim-lspconfig",
	lazy = false,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		-- Load LSP configurations
		local diagnostics = current_dir.require("configs.lsp-diagnostics")
		local on_attach = current_dir.require("configs.lsp-utils").on_attach
		local servers = current_dir.require("configs.lsp-servers")

		-- Configure diagnostics first
		diagnostics.setup()

		-- Setup LspAttach autocommand for keybindings
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client then
					on_attach(client, event.buf)
				end
			end,
		})

		-- Setup all LSP servers
		servers.setup()
	end,
}
