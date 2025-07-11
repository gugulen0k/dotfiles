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

-- Remap Ctrl+c to behave like Esc
vim.keymap.set({ "n", "i" }, "<C-c>", "<Esc>")

-- Ctrl+s writes the buffer.
utils.map("n", "<C-s>", ":w<CR>")

-- Ctrl+d or Ctrl+u will do what it suppose to do and also align the view.
utils.map("n", "<C-d>", "<C-d>zz")
utils.map("n", "<C-u>", "<C-u>zz")

-- Previous or Next search item will be centered.
utils.map("n", "n", "nzz")
utils.map("n", "N", "Nzz")

-- Disable default macro record on 'q' button and remap it to '<leader>q'.
vim.keymap.set("n", "q", "<nop>", { noremap = true })
vim.keymap.set("n", "Q", "q", { noremap = true, desc = "Record macro" })

------------------- [ Quickfix List ] -------------------
utils.map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix list item" })
utils.map("n", "[q", "<cmd>cprevious<CR>", { desc = "Previous quickfix list item" })
-- utils.map("n", "qff", "<cmd>cfirst<CR>", { desc = "First quickfix list item" })
-- utils.map("n", "qfl", "<cmd>clast<CR>", { desc = "Last quickfix list item" })
---------------------------------------------------------
