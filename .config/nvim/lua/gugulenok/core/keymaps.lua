local utils = require('gugulenok.utils')

vim.g.mapleader = ' '

utils.map('', '<leader><leader>', ':e #<CR>') -- Switching between last two files
utils.map('n', '<C-s>', ':w<CR>')
utils.map('n', 'Q', '<nop>')
utils.map('n', '<C-d>', '<C-d>zz')
utils.map('n', '<C-u>', '<C-u>zz')
utils.map('n', 'n', 'nzz')
utils.map('n', 'N', 'Nzz')
