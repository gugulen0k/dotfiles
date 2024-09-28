local M = {}

function M.setup(config)
  local lspconfig = require("lspconfig")

  lspconfig.volar.setup({
    capabilities = config.capabilities,
    on_attach = config.on_attach,
    filetypes = { "vue" },
    init_options = {
      vue = {
        hybridMode = false
      }
    }
  })
end

return M
