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
utils.map('n', '<leader>q', 'q', { desc = 'Start recording a macro' })

------------------- [ Quickfix List ] -------------------
utils.map('n', ']q', '<cmd>cnext<CR>', { desc = 'Next quickfix list item' })
utils.map('n', '[q', '<cmd>cprevious<CR>', { desc = 'Previous quickfix list item' })
utils.map('n', 'qff', '<cmd>cfirst<CR>', { desc = 'First quickfix list item' })
utils.map('n', 'qfl', '<cmd>clast<CR>', { desc = 'Last quickfix list item' })
---------------------------------------------------------
