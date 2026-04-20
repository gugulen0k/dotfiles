-- Extend vim.pack.add to accept "user/repo" shorthands (like lazy.nvim)
local _add = vim.pack.add
---@diagnostic disable-next-line: duplicate-set-field
vim.pack.add = function(specs, opts)
	specs = vim.iter(specs)
		:map(function(s)
			if type(s) == "string" and not s:find("://") then
				return "https://github.com/" .. s
			elseif type(s) == "table" and s.src and not s.src:find("://") then
				s.src = "https://github.com/" .. s.src
			end
			return s
		end)
		:totable()
	return _add(specs, opts)
end

-- Must be registered before any vim.pack.add()
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "blink.cmp" and (kind == "install" or kind == "update") then
			vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
		end
	end,
})

require("plugins.editor")
require("plugins.treesitter")
require("plugins.colorscheme")
require("plugins.notify")
require("plugins.lualine")
require("plugins.which-key")
require("plugins.indent-blankline")
require("plugins.nvim-highlight-colors")
require("plugins.oil")
require("plugins.fzf-lua")
require("plugins.gitsigns")
require("plugins.fugitive")
require("plugins.blink-cmp")
require("plugins.conform")
require("plugins.mason")
require("plugins.mason-lspconfig")
require("plugins.matchup")
require("plugins.treesj")
require("plugins.mini-align")
