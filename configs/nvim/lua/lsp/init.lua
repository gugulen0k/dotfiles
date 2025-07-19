local diagnostics = require("lsp.diagnostics")
local on_attach = require("lsp.keymaps").on_attach

diagnostics.setup()

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client then
			on_attach(client, event.buf)
		end
	end,
})
