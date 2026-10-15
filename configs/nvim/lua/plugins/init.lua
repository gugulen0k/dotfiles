-- Extend vim.pack.add to accept "user/repo" shorthands (like lazy.nvim)
--
-- Registry of hosts plugins can be downloaded from. The key is a short alias
-- usable in plugin specs, the value is the base URL of the git host.
local sources = {
	github = "https://github.com/",
	codeberg = "https://codeberg.org/",
	gitlab = "https://gitlab.com/",
}

-- Host used when a spec doesn't specify one
local default_source = "github"

-- Expand a shorthand into a full repo URL:
--   "user/repo.nvim"          -> default source
--   "codeberg:user/repo.nvim" -> per-plugin source override
-- Full URLs (https://, git://, file://, git@host:...) pass through untouched.
---@param src string
---@return string
local function expand(src)
	if src:find("://") or src:find("^git@") then
		return src
	end

	local alias, repo = src:match("^([%w_-]+):(.+)$")
	if alias then
		local base = sources[alias]
		if not base then
			error(
				"vim.pack: unknown source '"
					.. alias
					.. "' (known: "
					.. table.concat(vim.tbl_keys(sources), ", ")
					.. ")"
			)
		end
		return base .. repo
	end

	local base = sources[default_source]
	if not base then
		error("vim.pack: unknown default source '" .. default_source .. "'")
	end
	return base .. src
end

local _add = vim.pack.add

---@diagnostic disable-next-line: duplicate-set-field
vim.pack.add = function(specs, opts)
	specs = vim.iter(specs)
		:map(function(s)
			if type(s) == "string" then
				return expand(s)
			elseif type(s) == "table" and s.src then
				return vim.tbl_extend("force", s, { src = expand(s.src) })
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
