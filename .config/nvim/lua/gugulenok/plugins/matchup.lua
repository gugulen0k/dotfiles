return {
  "andymass/vim-matchup",
  event = { "BufEnter", "BufNew", "BufRead" },
  config = function()
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end
}
