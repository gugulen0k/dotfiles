local M = {}

M.handlers = {
  -- Customizing floating window borders for on hover floating windows.
  ["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "single" }
  ),

  -- Customizing floating window borders.
  ["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "single" }
  )
}

return M
