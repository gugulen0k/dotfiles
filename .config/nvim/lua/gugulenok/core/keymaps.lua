local utils = require('gugulenok.utils')

vim.g.mapleader = ' '

utils.map('', '<leader><leader>', ':e #<CR>') -- Switching between last two files
utils.map('n', '<C-s>', ':w<CR>')
utils.map('n', 'Q', '<nop>')

-- Function to toggle :G in a vertical split
local function toggle_git_status()
  -- Check if any fugitive buffer is open
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:match('^fugitive://') then
      -- Close the buffer if found
      vim.api.nvim_buf_delete(buf, { force = true })
      return
    end
  end
  -- If no fugitive buffer is found, open it in a vertical split
  vim.cmd('vertical G')
end

-- Map <space>G to toggle_git_status
utils.map('n', '<space>G', toggle_git_status, { noremap = true, silent = true })
