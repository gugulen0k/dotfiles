local M = {}

-- Function to dynamically require modules from a base path with added checks
function M.base_path(base_path)
  -- Check if base_path is provided and is a string
  if not base_path or type(base_path) ~= "string" then
    error("Invalid base path: must be a non-empty string")
  end

  local context = {}

  -- Custom require function using Lua's require, with added validation
  function context.require(module_path)
    -- Check if module_path is provided and is a string
    if not module_path or type(module_path) ~= "string" then
      error("Invalid module path: must be a non-empty string")
    end

    -- Convert module path to a full module name in Lua format
    local full_module_path = base_path .. "." .. module_path

    -- Check if the module can be required using `pcall` to handle errors gracefully
    local success, result = pcall(require, full_module_path)

    if not success then
      error("Error loading module: " .. full_module_path .. "\n" .. result)
    end

    return result
  end

  return context
end

function M.set_keymap(mode, shortcut, command, opts)
  vim.api.nvim_set_keymap(mode, shortcut, command, opts or {})
end

function M.map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or {})
end

function M.autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, opts or {})
end

-- Function to create global highlight group
function M.set_global_hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

-- Function to get the highlight color from the colorscheme
-- by highlight group name.
function M.get_hl_by_name(group)
  return vim.api.nvim_get_hl(0, { name = group })
end

return M
