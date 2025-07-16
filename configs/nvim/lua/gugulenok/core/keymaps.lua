local utils = require("gugulenok.utils")

vim.g.mapleader = " "

utils.autocmd("BufEnter", {
	callback = function()
		-- Add this keymap to all buffers except `oil` type.
		if vim.bo.filetype ~= "oil" then
			utils.map("", "<leader><leader>", ":e #<CR>", { buffer = true })
		end
	end,
})

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Remap Ctrl+c to behave like Esc
utils.map({ "i", "c" }, "<C-c>", "<Esc>")

-- Ctrl+s writes the buffer.
utils.map("n", "<C-s>", ":w<CR>", { desc = "Write buffer changes" })

-- Center screen when jumping
utils.map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
utils.map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
utils.map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
utils.map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Disable default macro record on 'q' button and remap it to '<leader>q'.
utils.map("n", "q", "<nop>", { noremap = true })
utils.map("n", "Q", "q", { noremap = true, desc = "Record macro" })

-- Better paste behavior
utils.map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Delete without yanking
utils.map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Better indenting in visual mode
utils.map("v", "<", "<gv", { desc = "Indent left and reselect" })
utils.map("n", ">", ">gv", { desc = "Indent right and reselect" })

------------------- [ Quickfix List ] -------------------
utils.map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix list item" })
utils.map("n", "[q", "<cmd>cprevious<CR>", { desc = "Previous quickfix list item" })
---------------------------------------------------------
