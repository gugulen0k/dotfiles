local utils = require('gugulenok.utils')

vim.g.mapleader = ' '

utils.map('', '<leader><leader>', ':e #<CR>') -- Switching between last two files
utils.map('n', '<C-s>', ':w<CR>')
utils.map('n', 'Q', '<nop>')
