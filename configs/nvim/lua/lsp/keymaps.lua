local M = {}

function M.on_attach(client, bufnr)
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	map("gd", "<cmd>FzfLua lsp_definitions<CR>", "Show LSP definitions")
	map("gi", "<cmd>FzfLua lsp_implementations<CR>", "Show LSP implementations")
	map("gt", "<cmd>FzfLua lsp_typedefs<CR>", "Show LSP type definitions")
	map("gr", "<cmd>FzfLua lsp_references<CR>", "Show LSP references")
	map("<leader>bd", "<cmd>FzfLua diagnostics_document<CR>", "Show buffer diagnostics")
	map("<leader>rs", ":LspRestart<CR>", "Restart LSP")
	map("K", vim.lsp.buf.hover, "Show documentation for what is under cursor")
	map("<leader>d", vim.diagnostic.open_float, "Show line diagnostics")

	-- Toggle inlay hints (0.11+ feature)
	map("<leader>ih", function()
		if client and client.supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
		end
	end, "Toggle inlay hints")
end

return M
