local M = {}

function M.setup()
	-- Enhanced diagnostic signs
	local signs = {
		Error = " ",
		Warn = " ",
		Hint = "󰠠 ",
		Info = " ",
	}

	-- Legacy sign definition (still works in 0.11+)
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	-- Modern diagnostic configuration for Neovim 0.11+
	vim.diagnostic.config({
		underline = true,
		-- IMPORTANT: Virtual text is now opt-in by default in 0.11+
		virtual_text = {
			enabled = true, -- Must explicitly enable since it's disabled by default
			spacing = 2,
			prefix = "",
			format = function(diagnostic)
				local message = diagnostic.message
				if diagnostic.source then
					message = string.format("%s [%s]", message, diagnostic.source)
				end
				return message
			end,
			-- NEW: Only show virtual text on current line (uncomment if desired)
			-- current_line = true,
		},
		-- NEW: Modern signs configuration format
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
		-- Enhanced floating window configuration
		float = {
			focusable = true,
			style = "minimal",
			border = "single",
			source = true,
			header = "",
			prefix = "",
		},
		severity_sort = true,
		update_in_insert = true, -- Better performance
	})

	-- Optional: Virtual lines support (new 0.11 feature)
	-- Uncomment to enable:
	-- vim.diagnostic.config({
	--   virtual_lines = { only_current_line = true }
	-- })
end

return M
