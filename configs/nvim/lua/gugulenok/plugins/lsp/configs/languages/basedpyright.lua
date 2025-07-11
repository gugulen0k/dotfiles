local M = {}

M.config = {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			disableTaggedHints = false,
			analysis = {
				typeCheckingMode = "standard",
				useLibraryCodeForTypes = true,
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				diagnosticSeverityOverrides = {
					reportIgnoreCommentWithoutRule = true,
				},
			},
		},
	},
}

-- Disabled by default, enable when needed
M.enable = true

-- For servers not yet supported by vim.lsp.config, provide fallback
M.fallback = {
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	settings = M.config.settings,
	filetypes = M.config.filetypes,
	root_dir = function(fname)
		local util = require("lspconfig.util")
		return util.root_pattern(unpack(M.config.root_markers))(fname)
	end,
}

return M
