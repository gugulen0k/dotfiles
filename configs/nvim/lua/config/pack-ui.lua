-- :Pacman — floating plugin manager UI for vim.pack

local ns  = vim.api.nvim_create_namespace("Pacman")
local _win = nil  -- currently open Pacman window (nil when closed)

vim.api.nvim_set_hl(0, "PacmanHeader",   { link = "Title",          default = true })
vim.api.nvim_set_hl(0, "PacmanHints",    { link = "Comment",        default = true })
vim.api.nvim_set_hl(0, "PacmanStatus",   { link = "Comment",        default = true })
vim.api.nvim_set_hl(0, "PacmanBusy",     { link = "DiagnosticWarn", default = true })
vim.api.nvim_set_hl(0, "PacmanActive",   { link = "DiagnosticOk",   default = true })
vim.api.nvim_set_hl(0, "PacmanInactive", { link = "Comment",        default = true })
vim.api.nvim_set_hl(0, "PacmanUpdating", { link = "DiagnosticWarn", default = true })
vim.api.nvim_set_hl(0, "PacmanDone",     { link = "DiagnosticOk",   default = true })
vim.api.nvim_set_hl(0, "PacmanRev",      { link = "Number",         default = true })
vim.api.nvim_set_hl(0, "PacmanSource",   { link = "Comment",        default = true })

local function hl(buf, group, row, col_start, col_end)
	vim.hl.range(buf, ns, group, { row, col_start }, { row, col_end })
end

vim.api.nvim_create_user_command("Pacman", function()
	if _win and vim.api.nvim_win_is_valid(_win) then
		vim.api.nvim_set_current_win(_win)
		return
	end

	local plugins = vim.pack.get(nil, { info = false })

	local max_name = 0
	for _, p in ipairs(plugins) do
		max_name = math.max(max_name, #p.spec.name)
	end

	-- Line layout (1-indexed):
	--   1  header (plugin count)
	--   2  keybinding hints
	--   3  status
	--   4  blank
	--   5+ plugin rows
	local HEADER_ROW    = 1
	local HINTS_ROW     = 2
	local STATUS_ROW    = 3
	local PLUGIN_OFFSET = 4

	-- Byte offsets within a plugin line (0-indexed for the nvim API):
	-- " X  <name padded>  <rev>  <src>"
	-- All icons (● ○ ⟳ ✓ ×) are 3 UTF-8 bytes → icon at bytes [1, 4)
	local ICON_B0 = 1
	local ICON_B1 = 4
	local REV_B0  = 1 + 3 + 2 + max_name + 2   -- = max_name + 8
	local REV_B1  = REV_B0 + 7
	local SRC_B0  = REV_B1 + 2

	local function make_plugin_line(p, icon)
		local rev  = p.rev and p.rev:sub(1, 7) or "-------"
		local name = p.spec.name .. string.rep(" ", max_name - #p.spec.name)
		local src  = p.spec.src:gsub("https://github.com/", "")
		return string.format(" %s  %s  %s  %s", icon, name, rev, src)
	end

	local lines = {
		string.format("  %d plugins installed", #plugins),
		"  [q/Esc] close   [u] update all   [U] update here   [x] remove all inactive",
		"  Status: idle",
		"",
	}

	local plugin_row = {}   -- name → 1-based buffer row
	local icon_state = {}   -- name → current icon character

	for i, p in ipairs(plugins) do
		local icon = p.active and "●" or "○"
		lines[#lines + 1] = make_plugin_line(p, icon)
		plugin_row[p.spec.name] = PLUGIN_OFFSET + i
		icon_state[p.spec.name] = icon
	end

	local function win_dims()
		local w = math.max(55, math.min(vim.o.columns - 14, 84))
		local h = math.max(8,  math.min(#lines,      vim.o.lines  - 8))
		local r = math.floor((vim.o.lines   - h) / 2)
		local c = math.floor((vim.o.columns - w) / 2)
		return w, h, r, c
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false

	local w, h, r, c = win_dims()
	local win = vim.api.nvim_open_win(buf, true, {
		relative  = "editor",
		width     = w,
		height    = h,
		row       = r,
		col       = c,
		style     = "minimal",
		border    = "rounded",
		title     = "  Pacman ",
		title_pos = "center",
	})
	vim.wo[win].cursorline = true
	_win = win

	-- ── Helpers ───────────────────────────────────────────────────

	local function icon_hl(icon)
		return icon == "●" and "PacmanActive"
		    or icon == "○" and "PacmanInactive"
		    or icon == "⟳" and "PacmanUpdating"
		    or icon == "✓" and "PacmanDone"
		    or "PacmanInactive"
	end

	local function hl_plugin_row(row, icon)
		vim.api.nvim_buf_clear_namespace(buf, ns, row - 1, row)
		hl(buf, icon_hl(icon),    row - 1, ICON_B0, ICON_B1)
		hl(buf, "PacmanRev",      row - 1, REV_B0,  REV_B1)
		hl(buf, "PacmanSource",   row - 1, SRC_B0,  -1)
	end

	local function apply_all_hl()
		vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
		hl(buf, "PacmanHeader", HEADER_ROW - 1, 0, -1)
		hl(buf, "PacmanHints",  HINTS_ROW  - 1, 0, -1)
		hl(buf, "PacmanStatus", STATUS_ROW - 1, 0, -1)
		for name, row in pairs(plugin_row) do
			hl_plugin_row(row, icon_state[name])
		end
	end
	apply_all_hl()

	local function set_line(row, text)
		vim.bo[buf].modifiable = true
		vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { text })
		vim.bo[buf].modifiable = false
	end

	local function set_status(text, busy)
		set_line(STATUS_ROW, "  Status: " .. text)
		vim.api.nvim_buf_clear_namespace(buf, ns, STATUS_ROW - 1, STATUS_ROW)
		hl(buf, busy and "PacmanBusy" or "PacmanStatus", STATUS_ROW - 1, 0, -1)
	end

	local function set_icon(name, icon)
		icon_state[name] = icon
		local row = plugin_row[name]
		if not row then return end
		-- " X  rest…"  →  " " + new_icon + original[5..]  (icon = 3 bytes)
		lines[row] = " " .. icon .. lines[row]:sub(5)
		set_line(row, lines[row])
		hl_plugin_row(row, icon)
	end

	-- ── Events ────────────────────────────────────────────────────

	local aug = vim.api.nvim_create_augroup("PacmanUI", { clear = true })

	vim.api.nvim_create_autocmd("PackChangedPre", {
		group = aug,
		callback = function(ev)
			set_status("Updating " .. ev.data.spec.name .. "...", true)
			set_icon(ev.data.spec.name, "⟳")
		end,
	})

	vim.api.nvim_create_autocmd("PackChanged", {
		group = aug,
		callback = function(ev)
			set_icon(ev.data.spec.name, "✓")
			set_status("idle", false)
		end,
	})

	vim.api.nvim_create_autocmd("VimResized", {
		group = aug,
		callback = function()
			if not vim.api.nvim_win_is_valid(win) then return end
			local nw, nh, nr, nc = win_dims()
			vim.api.nvim_win_set_config(win, {
				relative = "editor",
				width = nw, height = nh, row = nr, col = nc,
			})
		end,
	})

	vim.api.nvim_create_autocmd("WinClosed", {
		group = aug,
		pattern = tostring(win),
		once = true,
		callback = function()
			vim.api.nvim_del_augroup_by_id(aug)
			_win = nil
		end,
	})

	-- ── Keymaps ───────────────────────────────────────────────────

	local function close()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	vim.keymap.set("n", "q",     close, { buffer = buf, nowait = true })
	vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })

	vim.keymap.set("n", "u", function()
		set_status("Fetching updates...", true)
		vim.pack.update(nil, { force = true })
		set_status("idle", false)
	end, { buffer = buf, nowait = true, desc = "Update all plugins" })

	vim.keymap.set("n", "U", function()
		local idx = vim.api.nvim_win_get_cursor(win)[1] - PLUGIN_OFFSET
		if idx < 1 or idx > #plugins then return end
		local name = plugins[idx].spec.name
		set_status("Fetching updates for " .. name .. "...", true)
		vim.pack.update({ name }, { force = true })
		set_status("idle", false)
	end, { buffer = buf, nowait = true, desc = "Update plugin under cursor" })

	vim.keymap.set("n", "x", function()
		local inactive = vim.iter(plugins)
			:filter(function(p) return not p.active end)
			:totable()

		if #inactive == 0 then
			set_status("No inactive plugins to remove", false)
			return
		end

		local names = vim.iter(inactive):map(function(p) return p.spec.name end):totable()
		vim.pack.del(names)

		-- Remove rows in reverse order to keep indices valid during deletion
		local rows = vim.iter(inactive)
			:map(function(p) return plugin_row[p.spec.name] end)
			:totable()
		table.sort(rows, function(a, b) return a > b end)

		vim.bo[buf].modifiable = true
		for _, row in ipairs(rows) do
			vim.api.nvim_buf_set_lines(buf, row - 1, row, false, {})
		end
		vim.bo[buf].modifiable = false

		-- Evict deleted entries from the snapshot so pressing x again is safe
		local deleted = {}
		for _, p in ipairs(inactive) do deleted[p.spec.name] = true end
		for i = #plugins, 1, -1 do
			if deleted[plugins[i].spec.name] then table.remove(plugins, i) end
		end

		set_status("Removed " .. #inactive .. " inactive plugin(s)", false)
	end, { buffer = buf, nowait = true, desc = "Delete all inactive plugins from disk" })
end, { desc = "Open Pacman plugin manager" })
