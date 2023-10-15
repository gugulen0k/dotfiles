local function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

local function nmap(shortcut, command)
  map('n', shortcut, command)
end

local function imap(shortcut, command)
  map('i', shortcut, command)
end

vim.g.mapleader = ' '

map('', '<leader>q', ':NvimTreeToggle<CR>') -- Toggle filesystem (nvim-tree plugin)

map('', '<leader><leader>', ':e #<CR>') -- Switching between last two files

-- Fuzzy finder commands ------------------
nmap('<C-p>', ':Files<CR>')
nmap('<leader>f', ':Rg<CR>')
nmap('<leader>d', ':BTags<CR>')
nmap('<leader>b', ':Buffers<CR>')
----------------------------------------

nmap('<C-s>', ':w<CR>')
nmap('Q', '<nop>')
