local M = {}

function M.setup()
	local signs = {
		Error = " ",
		Warn = " ",
		Hint = "󰠠 ",
		Info = " ",
	}

	vim.diagnostic.config({
		underline = true,
		severity_sort = true,
		update_in_insert = false,
		virtual_text = {
			enabled = true,
			spacing = 2,
			prefix = "",
			format = function(diagnostic)
				return string.format("%s => [%s: %s]", diagnostic.message, diagnostic.source, diagnostic.code)
			end,
		},
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = signs.Error,
				[vim.diagnostic.severity.WARN] = signs.Warn,
				[vim.diagnostic.severity.HINT] = signs.Hint,
				[vim.diagnostic.severity.INFO] = signs.Info,
			},
			numhl = {
				[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
				[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
				[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			},
		},
		float = {
			focusable = true,
			style = "minimal",
			source = true,
			header = "",
			prefix = "",
		},
	})
end

return M
