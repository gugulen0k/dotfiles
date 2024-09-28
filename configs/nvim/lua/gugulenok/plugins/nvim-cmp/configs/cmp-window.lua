local cmp = require("cmp")

-- Get the current colors of the NonText highlight group
local nontext_hl = vim.api.nvim_get_hl(0, { name = 'NonText' })

-- Apply the same foreground color to another group, e.g., 'CustomGroup'
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = nontext_hl.fg })

return {
  completion = cmp.config.window.bordered({
    border = "single",
    side_padding = 0,
  }),
  documentation = cmp.config.window.bordered({
    border = "single"
  }),
}
