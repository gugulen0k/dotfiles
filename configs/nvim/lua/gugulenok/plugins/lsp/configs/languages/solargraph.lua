local M = {}

function M.setup(config)
  local lspconfig = require("lspconfig")

  lspconfig.solargraph.setup({
    capabilities = config.capabilities,
    on_attach = config.on_attach,
    cmd = { "solargraph", "stdio" },
    filetypes = { "ruby" },
    root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
    settings = {
      solargraph = {
        diagnostics = true,
        completion = {
          enable = true,
          triggerCharacters = { ".", ":", "::" },
          debounce = 100,
          maxItems = 100
        },
        hover = {
          enable = true,
          delay = 100
        }
      }
    },
  })
end

return M
