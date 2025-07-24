local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

autocmd("BufEnter", {
	callback = function()
		-- Add this keymap to all buffers except `oil` type.
		if vim.bo.filetype ~= "oil" then
			map("", "<leader><leader>", ":e #<CR>", { buffer = true })
		end
	end,
})

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Remap Ctrl+c to behave like Esc
map({ "i", "c" }, "<C-c>", "<Esc>")

-- Ctrl+s writes the buffer.
map("n", "<C-s>", ":w<CR>", { desc = "Write buffer changes" })

-- Center screen when jumping
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Disable default macro record on 'q' button and remap it to '<leader>q'.
map("n", "q", "<nop>", { noremap = true })
map("n", "Q", "q", { noremap = true, desc = "Record macro" })

-- Better paste behavior
-- map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Delete without yanking
-- map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Better indenting in visual mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Execute lua code under the cursor
map("n", "<leader>x", ":.lua<CR>", { desc = "Execute lua code under the cursor" })
map("v", "<leader>x", ":lua<CR>", { desc = "Execute lua code under the cursor" })

------------------- [ Quickfix List ] -------------------
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix list item" })
map("n", "[q", "<cmd>cprevious<CR>", { desc = "Previous quickfix list item" })
---------------------------------------------------------
