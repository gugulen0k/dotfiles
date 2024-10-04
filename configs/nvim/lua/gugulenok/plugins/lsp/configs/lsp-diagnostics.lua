local M = {}

function M.setup()
  -- Change diagnostics symbols
  local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  -- Set diagnostic configuration
  vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = true,
    virtual_text = {
      prefix = " "
    },
    float = {
      border = "single",
      format = function(diagnostic)
        return string.format('%s => [%s: %s]', diagnostic.message, diagnostic.source, diagnostic.code)
      end,
    },
  })
end

return M
