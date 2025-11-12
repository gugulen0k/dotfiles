return {
	"mason-org/mason-lspconfig.nvim",
	opts = function()
		local vue_language_server_path = vim.fn.expand("$MASON/packages")
			.. "/vue-language-server"
			.. "/node_modules/@vue/language-server"

		local tsserver_filetypes = {
			"typescript",
			"javascript",
			"javascriptreact",
			"typescriptreact",
			"vue",
		}

		local vue_plugin = {
			name = "@vue/typescript-plugin",
			location = vue_language_server_path,
			languages = { "vue" },
			configNamespace = "typescript",
		}

		local ts_ls_config = {
			init_options = {
				plugins = {
					vue_plugin,
				},
			},
			filetypes = tsserver_filetypes,
		}

		vim.lsp.config("vue_ls", {})
		vim.lsp.config("ts_ls", ts_ls_config)
		vim.lsp.enable({ "ts_ls", "vue_ls" })

		return {
			ensure_installed = {
				"solargraph",
				"rubocop",
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
		}
	end,
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
