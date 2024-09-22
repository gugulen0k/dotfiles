local M = {}

-- Function to set keybindings for LSP and buffer
function M.on_attach(_, bufnr)
  local utils = require("gugulenok.utils")
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Set keybinds for LSP functionality
  opts.desc = "Show buffer diagnostics"
  utils.map("n", "<leader>bd", "<cmd>FzfLua diagnostics_document bufnr=0<CR>", opts) -- Show diagnostics for the current buffer

  opts.desc = "Show line diagnostics"
  utils.map("n", "<leader>d", vim.diagnostic.open_float, opts) -- Show diagnostics for the current line

  opts.desc = "Restart LSP"
  utils.map("n", "<leader>rs", ":LspRestart<CR>", opts) -- Restart the LSP server

  -- Change floating window border for lsp
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, config, ...)
    config = config or {}
    config.border = "single" or opts.border
    config.bg = "NONE"

    return orig_util_open_floating_preview(contents, syntax, config, ...)
  end

  require('lspconfig.ui.windows').default_options.border = 'single'

  -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end

return M
