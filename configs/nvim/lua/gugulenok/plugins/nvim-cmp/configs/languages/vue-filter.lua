local M = {}

-- Checks if the cursor is inside a start tag in Vue files
function M.is_in_start_tag()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = ts_utils.get_node_at_cursor()
  if not node then return false end
  local node_to_check = { 'start_tag', 'self_closing_tag', 'directive_attribute' }
  return vim.tbl_contains(node_to_check, node:type())
end

-- Clear cached data for Vue start tags
function M.clear_vue_cache()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.b[bufnr]._vue_ts_cached_is_in_start_tag = nil
end

return M
