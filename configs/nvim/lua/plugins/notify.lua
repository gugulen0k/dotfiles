vim.pack.add({ "rcarriga/nvim-notify" })

require("notify").setup({
	render = "wrapped-compact",
	level = 0,
	stages = "static",
	fps = 1,
})

vim.notify = require("notify")
