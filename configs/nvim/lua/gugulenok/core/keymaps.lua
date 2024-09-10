local utils = require('gugulenok.utils')

vim.g.mapleader = ' '

utils.autocmd('BufEnter', {
  callback = function()
    -- Add this keymap to all buffers except `oil`
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
