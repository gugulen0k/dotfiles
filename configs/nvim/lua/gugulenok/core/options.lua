local opt = vim.opt -- for conciseness
local glb = vim.g

vim.o.winborder = "rounded"

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- disable default status line
opt.cmdheight = 0

glb.ruby_host_prog = "~/.rbenv/versions/3.3.0/bin/ruby"
glb.python3_host_prog = "/usr/bin/python3"
glb.node_host_prog = vim.fn.expand("~/.nvm/versions/node/v22.5.1/bin/neovim-node-host")

-- local devicons = require('nvim-web-devicons')
--
-- -- Function to get the current buffer's filename, icon, modified status, and readonly status
-- local function get_winbar()
--   local filename = vim.fn.expand('%:t') -- Get the current file name
--   local file_ext = vim.fn.expand('%:e') -- Get file extension
--   local icon, icon_color = devicons.get_icon_color(filename, file_ext, { default = true })
--
--   if filename == "" then
--     filename = "[No Name]"
--   end
--
--   -- File type
--   local filetype = vim.bo.filetype
--   if filetype == "" then
--     filetype = "none"
--   end
--
--   -- Readonly status
--   local readonly = vim.bo.readonly and "  " or ""
--
--   -- Modified status
--   local modified = vim.bo.modified and "  " or ""
--
--   -- Apply icon color to icon using highlight groups
--   local icon_hl = "%#DevIconWinbar#" .. icon .. "%*"
--
--   -- Winbar formatting
--   return table.concat({
--     readonly,
--     icon_hl, -- Icon with color
--     " ",
--     filename,
--     " [", filetype, "]",
--     modified
--   })
-- end
--
-- -- Set up winbar and highlight groups for custom colors
-- vim.o.winbar = "%{%v:lua.get_winbar()%}"
--
-- -- Custom highlight group for the file icon
-- vim.api.nvim_set_hl(0, 'DevIconWinbar', { fg = icon_color, bg = "NONE" })
