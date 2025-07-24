return {
	"rcarriga/nvim-notify",
	---@type notify.Config
	opts = {
		render = "wrapped-compact",
		level = 0,
		stages = "static",
		fps = 1,
	},
	config = function(_, opts)
		require("notify").setup(opts)
		vim.notify = require("notify")
	end,
}
