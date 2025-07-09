return {
	"mason-org/mason.nvim",
	lazy = "false",
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			PATH = "prepend",
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
				backdrop = 100,
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"html",
				"cssls",
				"tailwindcss",
				"pyright",
				"yamlls",
				"lua_ls",
				"rust_analyzer",
				"vue_ls",
				"ts_ls",
				"clangd",
				"solargraph",
				"ruff",
			},
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"eslint_d", -- JavaScript linter
				"prettierd", -- Formatter
				"stylua", -- Lua Formatter
			},
		})
	end,
}
