return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"solargraph",
			"vue_ls",
			"ts_ls",
			"pyright",
			"zls",
			"html",
			"cssls",
			"tailwindcss",
			"yamlls",
			"lua_ls",
			"clangd",
			"ruff",
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
