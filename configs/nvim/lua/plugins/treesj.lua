vim.pack.add({ "Wansmer/treesj" })

require("treesj").setup({})

vim.keymap.set("n", "<space>m", "<cmd>TSJToggle<CR>", { desc = "Toggle split/join" })
vim.keymap.set("n", "<space>j", "<cmd>TSJJoin<CR>", { desc = "Join lines" })
vim.keymap.set("n", "<space>s", "<cmd>TSJSplit<CR>", { desc = "Split lines" })
