return {
	"rcarriga/nvim-notify",
	opts = {
		render = "wrapped-compact",
		level = 0,
		stages = "static",
		fps = 1,
	},
	config = function(_, opts)
		local notify = require("notify")
		notify.setup(opts)
		vim.notify = notify
	end,
}
