local M = {}

function M.setup()
  -- Customizing floating window borders
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "single" }
  )

  -- Customizing floating window borders
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "single" }
  )

  require('lspconfig.ui.windows').default_options.border = 'single'
end

return M
