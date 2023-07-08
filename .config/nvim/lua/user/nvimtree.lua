require('nvim-tree').setup {
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
