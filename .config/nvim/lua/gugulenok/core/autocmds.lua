local utils = require('gugulenok.utils')

-- Enable specific options for Ruby files
utils.autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.opt_local.colorcolumn = "120"
  end,
})

utils.autocmd("FileType", {
  pattern = {
    "checkhealth",
    "fugitive",
    "git",
    "help",
    "lspinfo",
    "netrw",
    "notify",
    "qf",
    "query"
  },
  callback = function ()
    utils.map('q', vim.cmd.close, { desc = "Close the current buffer", buffer = true })
  end,
})
