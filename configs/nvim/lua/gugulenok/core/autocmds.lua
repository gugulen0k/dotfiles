local utils = require("gugulenok.utils")

-- Close help windows by just pressing 'q' button
vim.api.nvim_create_autocmd(
  "FileType", {
    pattern = { "help", "qf" },
    command = "noremap <buffer> q :bd<CR>",
  }
)
