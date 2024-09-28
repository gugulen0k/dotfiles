local M = {}

function M.setup(config)
  local lspconfig = require("lspconfig")

  lspconfig.ts_ls.setup({
    capabilities = config.capabilities,
    on_attach = config.on_attach,
    filetypes = { "javascript", "typescript" },
  })
end

return M
