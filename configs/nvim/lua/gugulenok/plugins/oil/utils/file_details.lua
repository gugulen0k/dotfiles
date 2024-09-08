local M = {}

M.detail = false
local oil = require("oil")

function M.setup()
  M.detail = not M.detail

  if M.detail then
    oil.set_columns({ "icon", "permissions", "size", "mtime" })
  else
    oil.set_columns({ "icon" })
  end
end

return M
