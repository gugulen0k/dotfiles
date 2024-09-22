local utils = require('gugulenok.utils')

vim.g.mapleader = ' '

utils.autocmd('BufEnter', {
  callback = function()
    -- Add this keymap to all buffers except `oil` type.
    if vim.bo.filetype ~= 'oil' then
      utils.map('', '<leader><leader>', ':e #<CR>', { buffer = true })
    end
  end,
})

utils.map('n', '<C-s>', ':w<CR>')
utils.map('n', 'Q', '<nop>')
utils.map('n', '<C-d>', '<C-d>zz')
utils.map('n', '<C-u>', '<C-u>zz')
utils.map('n', 'n', 'nzz')
utils.map('n', 'N', 'Nzz')

utils.map('n', '<leader>i',
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
  end,
  { desc = "Toggle inlay hints" }
)

-- Disable default macro record on 'q' button and remap it to '<leader>q'.
utils.map('n', 'q', '<nop>')
utils.map('n', '<leader>q', 'q')

------------------- [ Diagnostics ] -------------------
-- Show buffer diagnostics in quickfix list
-- utils.map('', 'dq', function()
--     vim.diagnostic.setloclist({
--       title = 'Buffer Diagnostics',
--       severity = {
--         vim.diagnostic.severity.WARN,
--         vim.diagnostic.severity.INFO,
--       }
--     })
--
--     vim.defer_fn(function()
--       vim.cmd('wincmd p')
--     end, 0)
--   end,
--   { desc = 'Open quickfix list with current buffer diagnostics' }
-- )
-------------------------------------------------------
