local lspconfig = require('lspconfig')

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'ruby_ls',
    'solargraph',
    'pyright',
    'quick_lint_js'
  }
})

require('mason-lspconfig').setup_handlers({
  function(server)
    lspconfig[server].setup({})
  end,
})

local on_attach = function(client)
  if client.server_capabilities.colorProvider then
    -- Attach document colour support
    require("document-color").buf_attach(bufnr)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- You are now capable!
capabilities.textDocument.colorProvider = {
  dynamicRegistration = true
}

-- Lsp servers that support documentColor
require("lspconfig").tailwindcss.setup({
  on_attach = on_attach,
  capabilities = capabilities
})
