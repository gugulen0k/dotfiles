local utils = require('gugulenok.utils')

-- Enable specific options for Ruby files
utils.autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.opt.colorcolumn = "120"
    print("working")
  end,
})
