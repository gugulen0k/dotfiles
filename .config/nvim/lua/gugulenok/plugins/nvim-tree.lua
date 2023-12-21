return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    local nvimtree = require("nvim-tree")

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup {
      renderer = {
        icons = {
          glyphs = {
            git = {
              unstaged = "󰰨",
              staged = "󰰢",
              unmerged = "",
              renamed = "󰰟",
              untracked = "󰎔",
              deleted = "󰚃",
              ignored = "◌",
            },
          },
        }
      }
    }

    -- set keymaps
    local function map(mode, shortcut, command)
      vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
    end

    map("", "<leader>q", "<cmd>NvimTreeToggle<CR>") -- Toggle filesystem (nvim-tree plugin)
  end
}
