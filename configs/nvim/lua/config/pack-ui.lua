-- :Pacman — floating plugin manager UI for vim.pack

local ns = vim.api.nvim_create_namespace("Pacman")
local _win = nil -- currently open window (nil when closed)
local _busy = false

vim.api.nvim_set_hl(0, "PacmanHeader", { link = "Title", default = true })
vim.api.nvim_set_hl(0, "PacmanHints", { link = "Comment", default = true })
vim.api.nvim_set_hl(0, "PacmanStatus", { link = "Comment", default = true })
vim.api.nvim_set_hl(0, "PacmanBusy", { link = "DiagnosticWarn", default = true })
vim.api.nvim_set_hl(0, "PacmanActive", { link = "DiagnosticOk", default = true })
vim.api.nvim_set_hl(0, "PacmanInactive", { link = "Comment", default = true })
vim.api.nvim_set_hl(0, "PacmanUpdating", { link = "DiagnosticWarn", default = true })
vim.api.nvim_set_hl(0, "PacmanDone", { link = "DiagnosticOk", default = true })
vim.api.nvim_set_hl(0, "PacmanHasUpdate", { link = "DiagnosticHint", default = true })
vim.api.nvim_set_hl(0, "PacmanDetail", { link = "NormalFloat", default = true })
vim.api.nvim_set_hl(0, "PacmanKey", { link = "Keyword", default = true })
vim.api.nvim_set_hl(0, "PacmanVal", { link = "String", default = true })

local function hl(buf, group, row, col_start, col_end)
	vim.hl.range(buf, ns, group, { row, col_start }, { row, col_end })
end

vim.api.nvim_create_user_command("Pacman", function()
	if _win and vim.api.nvim_win_is_valid(_win) then
		vim.api.nvim_set_current_win(_win)
		return
	end

	-- ── State ───────────────────────────────────────────────────────────────
	local plugins = vim.pack.get(nil, { info = false })
	local expanded = {} -- name → bool
	local has_update = {} -- name → bool
	local detail_data = {} -- name → { rev, src, path, active, version, tags, branches }

	-- Line layout (1-indexed):
	--   1  header
	--   2  hints line 1
	--   3  hints line 2
	--   4  status
	--   5  blank
	--   6+ plugin rows + their optional expand rows
	local HEADER_ROW = 1
	local HINTS_ROW = 2
	local STATUS_ROW = 4
	local PLUGIN_OFFSET = 5 -- first plugin is at row PLUGIN_OFFSET + 1

	-- Each plugin occupies 1 collapsed row.
	-- When expanded, N detail rows are inserted directly below it.
	-- We track the live row of each plugin (shifts as others expand/collapse).
	local plugin_row = {} -- name → current 1-based buf row

	-- ── Icons ────────────────────────────────────────────────────────────────
	local ICON_B0, ICON_B1 = 1, 4 -- 3-byte UTF-8 icon at bytes [1,4)

	local function icon_for(name, base_icon)
		if has_update[name] and (base_icon == "●" or base_icon == "○") then
			return "↑"
		end
		return base_icon
	end

	local function icon_hl(_, icon)
		if icon == "●" then
			return "PacmanActive"
		elseif icon == "↑" then
			return "PacmanHasUpdate"
		elseif icon == "○" then
			return "PacmanInactive"
		elseif icon == "⟳" then
			return "PacmanUpdating"
		elseif icon == "✓" then
			return "PacmanDone"
		end
		return "PacmanInactive"
	end

	local icon_state = {} -- name → current icon char

	-- ── Buffer / window ──────────────────────────────────────────────────────
	local function win_dims()
		local w = math.max(40, math.min(vim.o.columns - 14, 70))
		local h = math.max(8, math.min(vim.o.lines - 8, vim.o.lines - 4))
		local r = math.floor((vim.o.lines - h) / 2)
		local c = math.floor((vim.o.columns - w) / 2)
		return w, h, r, c
	end

	-- plugin name line (collapsed): " ▶ name"  or  " ▼ name" when expanded
	local function make_name_line(p)
		local arrow = expanded[p.spec.name] and "▼" or "▶"
		local upd = has_update[p.spec.name] and " *" or ""
		return string.format(
			" %s  %s%s",
			icon_for(p.spec.name, icon_state[p.spec.name] or (p.active and "●" or "○")),
			p.spec.name,
			upd
		)
	end

	-- detail lines inserted below a plugin row when expanded
	local function make_detail_lines(name)
		local d = detail_data[name]
		if not d then
			return { "    (loading...)" }
		end
		local lines = {}
		local function row(key, val)
			lines[#lines + 1] = string.format("    %-10s %s", key, tostring(val or "—"))
		end
		row("source:", d.src and d.src:gsub("https://github.com/", "gh:") or "—")
		row("rev:", d.rev and d.rev:sub(1, 7) or "—")
		row("path:", d.path or "—")
		row("active:", d.active and "yes" or "no")
		if d.version then
			row("version:", tostring(d.version))
		end
		if d.tags and #d.tags > 0 then
			local t = table.concat(vim.list_slice(d.tags, 1, math.min(5, #d.tags)), " ")
			if #d.tags > 5 then
				t = t .. " (+" .. (#d.tags - 5) .. ")"
			end
			row("tags:", t)
		end
		if d.branches and #d.branches > 0 then
			row("branch:", d.branches[1])
		end
		if has_update[name] then
			lines[#lines + 1] = "    ↑ update available"
		end
		return lines
	end

	-- Build full initial lines list
	local lines = {
		string.format("  %d plugins", #plugins),
		"  [q] close  [u] update all  [U] update here",
		"  [x] rm inactive  [Enter/=] expand",
		"  Status: idle",
		"",
	}

	for i, p in ipairs(plugins) do
		icon_state[p.spec.name] = p.active and "●" or "○"
		lines[#lines + 1] = make_name_line(p)
		plugin_row[p.spec.name] = PLUGIN_OFFSET + i
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false

	local w, h, r, c = win_dims()
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = w,
		height = h,
		row = r,
		col = c,
		style = "minimal",
		border = "rounded",
		title = " Pacman ",
		title_pos = "center",
	})
	vim.wo[win].cursorline = true
	_win = win

	-- ── Buffer helpers ───────────────────────────────────────────────────────

	local function set_modifiable(v)
		vim.bo[buf].modifiable = v
	end

	local function set_line(row, text)
		set_modifiable(true)
		vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { text })
		set_modifiable(false)
	end

	local function set_status(text, busy)
		set_line(STATUS_ROW, "  Status: " .. text)
		vim.api.nvim_buf_clear_namespace(buf, ns, STATUS_ROW - 1, STATUS_ROW)
		hl(buf, busy and "PacmanBusy" or "PacmanStatus", STATUS_ROW - 1, 0, -1)
	end

	-- ── Highlight ─────────────────────────────────────────────────────────────

	local function hl_plugin_row(row, name, icon)
		vim.api.nvim_buf_clear_namespace(buf, ns, row - 1, row)
		hl(buf, icon_hl(name, icon), row - 1, ICON_B0, ICON_B1)
	end

	local function hl_detail_rows(first_row, n_rows)
		for i = 0, n_rows - 1 do
			local r0 = first_row + i - 1
			vim.api.nvim_buf_clear_namespace(buf, ns, r0, r0 + 1)
			hl(buf, "PacmanDetail", r0, 0, -1)
			-- highlight key (first word up to colon)
			local line = vim.api.nvim_buf_get_lines(buf, r0, r0 + 1, false)[1] or ""
			local ks, ke = line:find("%S+%s")
			if ks then
				hl(buf, "PacmanKey", r0, ks - 1, ke - 1)
			end
		end
	end

	local function apply_all_hl()
		vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
		hl(buf, "PacmanHeader", HEADER_ROW - 1, 0, -1)
		hl(buf, "PacmanHints", HINTS_ROW - 1, 0, -1)
		hl(buf, "PacmanHints", HINTS_ROW, 0, -1)
		hl(buf, "PacmanStatus", STATUS_ROW - 1, 0, -1)
		for _, p in ipairs(plugins) do
			local row = plugin_row[p.spec.name]
			if row then
				hl_plugin_row(row, p.spec.name, icon_state[p.spec.name])
				if expanded[p.spec.name] then
					local d = make_detail_lines(p.spec.name)
					hl_detail_rows(row + 1, #d)
				end
			end
		end
	end
	apply_all_hl()

	local function set_icon(name, icon)
		icon_state[name] = icon
		local row = plugin_row[name]
		if not row then
			return
		end
		-- Rebuild the entire name line to keep arrow prefix correct
		local p_idx
		for i, p in ipairs(plugins) do
			if p.spec.name == name then
				p_idx = i
				break
			end
		end
		if not p_idx then
			return
		end
		local new_line = make_name_line(plugins[p_idx])
		set_line(row, new_line)
		hl_plugin_row(row, name, icon)
	end

	-- ── Expand / collapse ─────────────────────────────────────────────────────

	local function plugin_at_cursor()
		local cursor_row = vim.api.nvim_win_get_cursor(win)[1]
		-- Walk plugin_row to find which plugin row the cursor is on or inside
		for _, p in ipairs(plugins) do
			local pr = plugin_row[p.spec.name]
			if pr then
				local detail_count = (expanded[p.spec.name] and #make_detail_lines(p.spec.name)) or 0
				if cursor_row >= pr and cursor_row <= pr + detail_count then
					return p
				end
			end
		end
		return nil
	end

	local function collapse(name)
		if not expanded[name] then
			return
		end
		local row = plugin_row[name]
		local d = make_detail_lines(name)
		expanded[name] = false

		set_modifiable(true)
		vim.api.nvim_buf_set_lines(buf, row, row + #d, false, {})
		set_modifiable(false)

		-- Shift all plugins below this one up
		for _, p in ipairs(plugins) do
			local pr = plugin_row[p.spec.name]
			if pr and pr > row then
				plugin_row[p.spec.name] = pr - #d
			end
		end
		-- Redraw the toggle arrow
		local p_idx
		for i, p in ipairs(plugins) do
			if p.spec.name == name then
				p_idx = i
				break
			end
		end
		if p_idx then
			set_line(plugin_row[name], make_name_line(plugins[p_idx]))
			hl_plugin_row(plugin_row[name], name, icon_state[name])
		end
	end

	local function expand(name)
		if expanded[name] then
			return
		end
		local row = plugin_row[name]
		expanded[name] = true

		-- If no detail data yet, fetch async then re-expand
		if not detail_data[name] then
			set_status("Loading " .. name .. "...", true)
			-- Insert placeholder immediately so user sees feedback
			set_modifiable(true)
			vim.api.nvim_buf_set_lines(buf, row, row, false, { "    (loading...)" })
			set_modifiable(false)
			for _, p in ipairs(plugins) do
				local pr = plugin_row[p.spec.name]
				if pr and pr > row then
					plugin_row[p.spec.name] = pr + 1
				end
			end
			hl_detail_rows(row + 1, 1)
			-- Redraw arrow
			local p_idx
			for i, p in ipairs(plugins) do
				if p.spec.name == name then
					p_idx = i
					break
				end
			end
			if p_idx then
				set_line(row, make_name_line(plugins[p_idx]))
				hl_plugin_row(row, name, icon_state[name])
			end

			-- Fetch info in background
			vim.system({
				"nvim",
				"--headless",
				"--noplugin",
				"-u",
				vim.fn.stdpath("config") .. "/init.lua",
				"-c",
				string.format(
					[[lua local p=vim.pack.get({%q},{info=true}); if p and p[1] then io.write(vim.json.encode({rev=p[1].rev,src=p[1].spec.src,path=p[1].path,active=p[1].active,version=p[1].spec.version and tostring(p[1].spec.version) or nil,tags=vim.list_slice(p[1].tags or {},1,8),branches=vim.list_slice(p[1].branches or {},1,3)})) end]],
					name
				),
				"-c",
				"q",
			}, { text = true, timeout = 30000 }, function(result)
				vim.schedule(function()
					-- Remove placeholder row
					local cur_row = plugin_row[name]
					if not cur_row or not expanded[name] then
						return
					end

					-- Parse result
					if result.code == 0 and result.stdout and result.stdout ~= "" then
						local ok, data = pcall(vim.json.decode, result.stdout)
						if ok and data then
							detail_data[name] = data
						end
					end
					if not detail_data[name] then
						detail_data[name] = { rev = "?", src = "?", path = "?", active = false }
					end

					-- Replace placeholder with real detail lines
					local new_detail = make_detail_lines(name)
					set_modifiable(true)
					-- Remove 1 placeholder line
					vim.api.nvim_buf_set_lines(buf, cur_row, cur_row + 1, false, new_detail)
					set_modifiable(false)

					-- Fix row offsets: net change = #new_detail - 1
					local delta = #new_detail - 1
					if delta ~= 0 then
						for _, p in ipairs(plugins) do
							local pr = plugin_row[p.spec.name]
							if pr and pr > cur_row then
								plugin_row[p.spec.name] = pr + delta
							end
						end
					end

					hl_detail_rows(cur_row + 1, #new_detail)
					set_status("idle", false)
				end)
			end)
			return
		end

		-- Detail data already present — insert synchronously
		local d = make_detail_lines(name)
		set_modifiable(true)
		vim.api.nvim_buf_set_lines(buf, row, row, false, d)
		set_modifiable(false)

		for _, p in ipairs(plugins) do
			local pr = plugin_row[p.spec.name]
			if pr and pr > row then
				plugin_row[p.spec.name] = pr + #d
			end
		end
		hl_detail_rows(row + 1, #d)

		-- Redraw arrow
		local p_idx
		for i, p in ipairs(plugins) do
			if p.spec.name == name then
				p_idx = i
				break
			end
		end
		if p_idx then
			set_line(row, make_name_line(plugins[p_idx]))
			hl_plugin_row(row, name, icon_state[name])
		end
	end

	local function toggle_expand()
		local p = plugin_at_cursor()
		if not p then
			return
		end
		if expanded[p.spec.name] then
			collapse(p.spec.name)
		else
			expand(p.spec.name)
		end
	end

	-- ── Events ────────────────────────────────────────────────────────────────

	local aug = vim.api.nvim_create_augroup("PacmanUI", { clear = true })

	vim.api.nvim_create_autocmd("PackChangedPre", {
		group = aug,
		callback = function(ev)
			vim.schedule(function()
				set_status("Updating " .. ev.data.spec.name .. "...", true)
				set_icon(ev.data.spec.name, "⟳")
			end)
		end,
	})

	vim.api.nvim_create_autocmd("PackChanged", {
		group = aug,
		callback = function(ev)
			vim.schedule(function()
				has_update[ev.data.spec.name] = nil
				detail_data[ev.data.spec.name] = nil -- invalidate cached details
				local base = ev.data.active and "●" or "○"
				set_icon(ev.data.spec.name, base)
				-- Refresh expanded detail if open
				if expanded[ev.data.spec.name] then
					collapse(ev.data.spec.name)
				end
			end)
		end,
	})

	vim.api.nvim_create_autocmd("VimResized", {
		group = aug,
		callback = function()
			if not vim.api.nvim_win_is_valid(win) then
				return
			end
			local nw, nh, nr, nc = win_dims()
			vim.api.nvim_win_set_config(win, {
				relative = "editor",
				width = nw,
				height = nh,
				row = nr,
				col = nc,
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
			_busy = false
		end,
	})

	-- ── Keymaps ───────────────────────────────────────────────────────────────

	local function close()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
	vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })
	vim.keymap.set("n", "<CR>", toggle_expand, { buffer = buf, nowait = true, desc = "Toggle expand" })
	vim.keymap.set("n", "=", toggle_expand, { buffer = buf, nowait = true, desc = "Toggle expand" })

	local cfg_init = vim.fn.stdpath("config") .. "/init.lua"

	local function run_update(names, on_done)
		local lua_cmd = names
				and string.format(
					"vim.pack.update({%s},{force=true})",
					table.concat(
						vim.tbl_map(function(n)
							return string.format("%q", n)
						end, names),
						","
					)
				)
			or "vim.pack.update(nil,{force=true})"
		vim.system(
			{ "nvim", "--headless", "-u", cfg_init, "-c", "lua " .. lua_cmd, "-c", "qa!" },
			{ text = true, timeout = 120000 },
			function(result)
				vim.schedule(function()
					on_done(result.code == 0, (result.stdout or "") .. (result.stderr or ""))
				end)
			end
		)
	end

	-- [u] update all — headless, non-blocking
	vim.keymap.set("n", "u", function()
		if _busy then
			set_status("busy — please wait", true)
			return
		end
		_busy = true
		set_status("Updating all… (background, cursor is free)", true)

		run_update(nil, function(ok, out)
			_busy = false
			for _, p in ipairs(plugins) do
				detail_data[p.spec.name] = nil
				has_update[p.spec.name] = nil
				if expanded[p.spec.name] then
					collapse(p.spec.name)
				end
				local base_icon = p.active and "●" or "○"
				icon_state[p.spec.name] = base_icon
			end
			apply_all_hl()
			if not ok then
				set_status("Update error — check :messages", false)
				vim.notify("Pacman update error:\n" .. out, vim.log.levels.WARN)
			else
				set_status("Updated — restart nvim to apply", false)
			end
		end)
	end, { buffer = buf, nowait = true, desc = "Update all plugins" })

	-- [U] update plugin under cursor — headless, non-blocking
	vim.keymap.set("n", "U", function()
		if _busy then
			set_status("busy — please wait", true)
			return
		end
		local p = plugin_at_cursor()
		if not p then
			return
		end
		local name = p.spec.name
		_busy = true
		set_status("Updating " .. name .. "… (background, cursor is free)", true)
		set_icon(name, "⟳")

		run_update({ name }, function(ok, out)
			_busy = false
			detail_data[name] = nil
			has_update[name] = nil
			if expanded[name] then
				collapse(name)
			end
			icon_state[name] = p.active and "●" or "○"
			set_icon(name, icon_state[name])
			if not ok then
				set_status("Update error — check :messages", false)
				vim.notify("Pacman update error:\n" .. out, vim.log.levels.WARN)
			else
				set_status("Updated " .. name .. " — restart nvim to apply", false)
			end
			apply_all_hl()
		end)
	end, { buffer = buf, nowait = true, desc = "Update plugin under cursor" })

	-- [x] remove inactive plugins
	vim.keymap.set("n", "x", function()
		if _busy then
			set_status("busy — please wait", true)
			return
		end
		local inactive = vim.iter(plugins)
			:filter(function(p)
				return not p.active
			end)
			:totable()
		if #inactive == 0 then
			set_status("No inactive plugins", false)
			return
		end

		local names = vim.iter(inactive)
			:map(function(p)
				return p.spec.name
			end)
			:totable()
		vim.pack.del(names)

		-- Collapse any expanded, remove rows in reverse order
		for _, p in ipairs(inactive) do
			if expanded[p.spec.name] then
				collapse(p.spec.name)
			end
		end
		local rows = vim.iter(inactive)
			:map(function(p)
				return plugin_row[p.spec.name]
			end)
			:totable()
		table.sort(rows, function(a, b)
			return a > b
		end)

		set_modifiable(true)
		for _, row in ipairs(rows) do
			vim.api.nvim_buf_set_lines(buf, row - 1, row, false, {})
		end
		set_modifiable(false)

		local deleted = {}
		for _, p in ipairs(inactive) do
			deleted[p.spec.name] = true
		end
		for i = #plugins, 1, -1 do
			if deleted[plugins[i].spec.name] then
				table.remove(plugins, i)
			end
		end
		set_status("Removed " .. #inactive .. " inactive plugin(s)", false)
	end, { buffer = buf, nowait = true, desc = "Delete inactive plugins" })

	-- ── Background update check on open ──────────────────────────────────────
	-- Use git fetch + lock comparison via headless nvim to detect available updates.
	-- Intercept the confirm buffer nvim creates, parse it, then discard it.

	local function check_for_updates()
		set_status("Checking for updates… (background)", true)
		_busy = true

		-- Intercept the confirm buffer vim.pack.update will open
		local intercept_id
		intercept_id = vim.api.nvim_create_autocmd("BufAdd", {
			group = aug,
			callback = function(ev)
				local bname = vim.api.nvim_buf_get_name(ev.buf)
				if not bname:match("nvim%-pack://confirm") then
					return
				end
				pcall(vim.api.nvim_del_autocmd, intercept_id)
				vim.schedule(function()
					-- Parse confirm buffer
					local blines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
					local in_upd = false
					for _, l in ipairs(blines) do
						local grp = l:match("^# (%S+)")
						if grp then
							in_upd = (grp == "Update")
						end
						if in_upd then
							local pname = l:match("^## (.+)$")
							if pname then
								has_update[pname:gsub(" %(not active%)$", "")] = true
							end
						end
					end
					-- Close the window/tab nvim opened for the confirm buffer
					for _, cw in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_get_buf(cw) == ev.buf then
							pcall(vim.api.nvim_win_close, cw, true)
						end
					end
					pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
				end)
			end,
		})

		-- Run update check in a background thread via vim.system → nvim headless
		-- This uses the config's init.lua so vim.pack is fully loaded
		vim.system(
			{ "nvim", "--headless", "-c", "lua vim.pack.update(nil,{offline=false,force=false})", "-c", "qa!" },
			{ text = true, timeout = 60000 },
			function(result)
				vim.schedule(function()
					pcall(vim.api.nvim_del_autocmd, intercept_id)
					_busy = false

					-- The headless process wrote to the lockfile if updates were found.
					-- We already intercepted the confirm buf above (if nvim opened one).
					-- If headless ran without UI, it may have just printed to stdout.
					-- Parse stdout for update lines as fallback.
					if result.stdout then
						local in_upd = false
						for _, l in ipairs(vim.split(result.stdout, "\n")) do
							local grp = l:match("^# (%S+)")
							if grp then
								in_upd = (grp == "Update")
							end
							if in_upd then
								local pname = l:match("^## (.+)$")
								if pname then
									has_update[pname:gsub(" %(not active%)$", "")] = true
								end
							end
						end
					end

					-- Re-render icons with update indicators
					for _, p in ipairs(plugins) do
						local row = plugin_row[p.spec.name]
						if row then
							local new_line = make_name_line(p)
							set_line(row, new_line)
							hl_plugin_row(row, p.spec.name, icon_state[p.spec.name])
						end
					end

					local n = 0
					for _ in pairs(has_update) do
						n = n + 1
					end
					if n > 0 then
						set_status(n .. " update(s) available — [u] to update all", false)
					else
						set_status("idle", false)
					end
				end)
			end
		)
	end

	check_for_updates()
end, { desc = "Open Pacman plugin manager" })
