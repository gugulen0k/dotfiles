-- Configuration lua files
require('user.plugins')
require('user.treesitter')
require('user.theme')
require('user.keymaps')
require('user.lualine')
require('user.nvimtree')
require('user.lspconfig')
require('user.cmp')
--------------------------

-- Changing default vim settings
local opt = vim.opt
local glb = vim.g

-- options settings
opt.background = 'dark'
opt.cursorline = true               -- highlight current line
opt.encoding = "utf-8"
opt.ignorecase = true               -- ignore case in search
opt.number = true                   -- show line numbers
opt.relativenumber = true           -- number relative to current line
opt.termguicolors = true            -- truecolor support
opt.wildmode = {'list', 'longest'}  -- command-line completion mode
opt.showmode = false
opt.tabstop=2
opt.shiftwidth=2
opt.expandtab = true                -- spaces instead of tabs
opt.cmdheight = 0
opt.swapfile = false
opt.wrap = false
opt.clipboard = "unnamedplus"

-- global settings
glb.loaded_netrw = 1 -- disable netrw
glb.loaded_netrwPlugin = 1

vim.cmd('filetype plugin on')
----------------------------------
