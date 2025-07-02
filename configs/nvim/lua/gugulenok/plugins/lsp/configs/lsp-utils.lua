local M = {}

function M.on_attach(client, bufnr)
	local utils = require("gugulenok.utils")
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- LSP Navigation Keybindings
	opts.desc = "Go to declaration"
	utils.map("n", "gD", vim.lsp.buf.declaration, opts)

	opts.desc = "Show LSP definitions"
	utils.map("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", opts)

	opts.desc = "Show LSP implementations"
	utils.map("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts)

	opts.desc = "Show LSP type definitions"
	utils.map("n", "gt", "<cmd>FzfLua lsp_typedefs<CR>", opts)

	opts.desc = "Show LSP references"
	utils.map("n", "gr", "<cmd>FzfLua lsp_references<CR>", opts)

	-- LSP Actions
	opts.desc = "See available code actions"
	utils.map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

	opts.desc = "Smart rename"
	utils.map("n", "<leader>rn", vim.lsp.buf.rename, opts)

	opts.desc = "Show documentation for what is under cursor"
	utils.map("n", "K", vim.lsp.buf.hover, opts)

	-- Diagnostic Keybindings
	opts.desc = "Show buffer diagnostics"
	utils.map("n", "<leader>bd", "<cmd>FzfLua diagnostics_document<CR>", opts)

	opts.desc = "Show line diagnostics"
	utils.map("n", "<leader>d", vim.diagnostic.open_float, opts)

	-- LSP Management
	opts.desc = "Restart LSP"
	utils.map("n", "<leader>rs", ":LspRestart<CR>", opts)

	-- Toggle inlay hints (0.11+ feature)
	opts.desc = "Toggle inlay hints"
	utils.map("n", "<leader>ih", function()
		if client and client.supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
		end
	end, opts)
end

return M
