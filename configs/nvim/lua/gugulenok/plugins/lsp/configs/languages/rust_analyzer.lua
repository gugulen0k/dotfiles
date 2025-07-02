local M = {}

M.config = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json", ".git" },
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = { group = "module" },
				prefix = "self",
			},
			cargo = {
				buildScripts = { enable = true },
				features = "all",
			},
			procMacro = { enable = true },
			inlayHints = {
				bindingModeHints = { enable = false },
				chainingHints = { enable = true },
				closingBraceHints = { enable = true, minLines = 25 },
				closureReturnTypeHints = { enable = "never" },
				lifetimeElisionHints = { enable = "never", useParameterNames = false },
				maxLength = 25,
				parameterHints = { enable = true },
				reborrowHints = { enable = "never" },
				renderColons = true,
				typeHints = {
					enable = true,
					hideClosureInitialization = false,
					hideNamedConstructor = false,
				},
			},
			check = { command = "clippy" },
			diagnostics = { enable = true, enableExperimental = true },
		},
	},
}

M.enable = true

return M
