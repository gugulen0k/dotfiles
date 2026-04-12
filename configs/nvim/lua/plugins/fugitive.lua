vim.pack.add({ "tpope/vim-fugitive" })

local function toggle_git_status()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local bufname = vim.api.nvim_buf_get_name(buf)
		if bufname:match("^fugitive://") then
			vim.api.nvim_buf_delete(buf, { force = true })
			return
		end
	end
	vim.cmd("vertical G")
end

vim.keymap.set("n", "<space>G", toggle_git_status, { desc = "Toggle Fugitive panel" })
