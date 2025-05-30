local M = {}

function M.setup(config)
  local lspconfig = require("lspconfig")

  lspconfig.clangd.setup({
    capabilities = config.capabilities,
    on_attach = config.on_attach,
    settings = {
      basedpyright = {
        disableOrganizeImports = true,
        disableTaggedHints = false,
        analysis = {
          typeCheckingMode = "standard",
          useLibraryCodeForTypes = true, -- Analyze library code for type information
          autoImportCompletions = true,
          autoSearchPaths = true,
          diagnosticSeverityOverrides = {
            reportIgnoreCommentWithoutRule = true,
          },
        },
      },
    }
  })
end

return M
