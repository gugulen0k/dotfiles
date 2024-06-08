local M = {}

function M.set_keymap(mode, shortcut, command, opts)
  vim.api.nvim_set_keymap(mode, shortcut, command, opts or {})
end

function M.map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or {})
end

function M.autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, opts or {})
end

return M
