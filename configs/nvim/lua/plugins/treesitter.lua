vim.pack.add({
	"nvim-treesitter/nvim-treesitter",
	"nvim-treesitter/nvim-treesitter-textobjects",
})

-- nvim-treesitter in this version only manages parser installation.
-- Highlight, indent, and other integrations are configured via vim.treesitter
-- and filetype autocmds (Neovim 0.10+ built-in treesitter support).

require("nvim-treesitter.config").setup({
	-- install_dir = nil, -- defaults to stdpath("data")/nvim-treesitter
})

-- Install parsers
local parsers = {
	"bash",
	"css",
	"dockerfile",
	"gitignore",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"ruby",
	"typescript",
	"vim",
	"vimdoc",
	"vue",
	"yaml",
	"zig",
}

require("nvim-treesitter.install").install(parsers)

-- Enable built-in treesitter highlighting for all buffers
vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		local ok = pcall(vim.treesitter.start, ev.buf)
		if not ok then
			-- parser not available for this filetype, silently skip
		end
	end,
})
