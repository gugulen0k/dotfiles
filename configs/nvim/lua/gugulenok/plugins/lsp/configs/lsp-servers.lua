-- configs/nvim/lua/gugulenok/plugins/lsp/configs/lsp-servers.lua
---------- [ Setup for relative imports ] ----------
local utils = require("gugulenok.utils")
local current_dir = utils.base_path("gugulenok.plugins.lsp.configs")
----------------------------------------------------

local M = {}

function M.setup()
	-- Load all language-specific configurations
	local languages = {
		lua_ls = current_dir.require("languages.lua_ls"),
		rust_analyzer = current_dir.require("languages.rust_analyzer"),
		ts_ls = current_dir.require("languages.ts_ls"),
		vue_ls = current_dir.require("languages.vue_ls"),
		clangd = current_dir.require("languages.clangd"),
		solargraph = current_dir.require("languages.solargraph"),
		basedpyright = current_dir.require("languages.basedpyright"),
	}

	-- Configure servers using native vim.lsp.config (0.11+)
	for server_name, server_config in pairs(languages) do
		if server_config.config then
			vim.lsp.config(server_name, server_config.config)
		end

		-- Run custom setup if provided
		if server_config.setup then
			server_config.setup()
		end
	end

	local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	if ok then
		mason_lspconfig.setup({
			-- Default handler for servers not in our languages table
			function(server_name)
				-- Check if we have a custom config for this server
				local server_config = languages[server_name]
				if server_config then
					-- If enabled, enable it (vim.lsp.config was already called above)
					if server_config.enable ~= false then
						vim.lsp.enable(server_name)
					end
				else
					-- For servers not in our config, use default setup
					local lspconfig = require("lspconfig")
					lspconfig[server_name].setup({
						capabilities = vim.lsp.protocol.make_client_capabilities(),
					})
				end
			end,
		})
	end

	-- Enable our configured servers
	for server_name, server_config in pairs(languages) do
		if server_config.enable ~= false then
			vim.lsp.enable(server_name)
		end
	end

	-- Fallback for servers not yet supported by vim.lsp.config
	local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
	if ok_lspconfig then
		for server_name, server_config in pairs(languages) do
			if server_config.fallback then
				lspconfig[server_name].setup(server_config.fallback)
			end
		end
	end
end

return M
