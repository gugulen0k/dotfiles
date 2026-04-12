vim.pack.add({ "savq/melange-nvim" })

vim.o.background = "dark"
vim.cmd.colorscheme("melange")

vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
