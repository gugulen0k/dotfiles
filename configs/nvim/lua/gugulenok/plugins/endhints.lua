return {
  "chrisgrieser/nvim-lsp-endhints",
  event = "LspAttach",
  opts = {},
  config = function()
    require("lsp-endhints").enable()
  end
}
