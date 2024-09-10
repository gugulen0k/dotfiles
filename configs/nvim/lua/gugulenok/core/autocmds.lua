local utils = require('gugulenok.utils')

-- Automatically open help buffers in a new tab
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*", -- Help files are usually .txt
  callback = function()
    if vim.bo.filetype == "help" then
      vim.cmd("tabnew")                        -- Open a new tab
      vim.cmd("help " .. vim.fn.expand("%:t")) -- Open the current help file in the new tab
    end
  end
})
