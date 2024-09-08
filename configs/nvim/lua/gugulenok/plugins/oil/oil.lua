---------- [ Setup for relative imports ] ----------
local utils = require("gugulenok.utils")
local current_dir = utils.base_path("gugulenok.plugins.oil")
----------------------------------------------------

return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require("oil")
    local git_files = current_dir.require("utils.git_files")
    local file_details = current_dir.require("utils.file_details")

    oil.setup({
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,
      constraint_cursor = "name",
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == ".." or name == ".git"
        end,
        -- is_hidden_file = function(name, bufnr)
        --   git_files.setup({ name = name, bufnr = bufnr })
        -- end,
      },
      use_default_keymaps = false,
      keymaps_help = {
        border = "single"
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        -- ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["g."] = "actions.toggle_hidden",
        ["gd"] = { desc = "Toggle file detail view", callback = function() file_details.setup() end },
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
      },
      -- Configuration for the actions floating preview window
      preview = {
        border = "single"
      },
      -- Configuration for the floating window in oil.open_float
      float = {
        border = "single",
        padding = 0
      },
    })

    utils.map("n", "-", function() oil.open_float() end, { desc = "Open parent directory" })
  end
}
