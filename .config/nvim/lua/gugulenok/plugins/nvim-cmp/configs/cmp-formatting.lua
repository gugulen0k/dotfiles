local lspkind = require("lspkind")

return {
  fields = { "kind", "abbr", "menu" },
  format = lspkind.cmp_format({
    mode = 'symbol_text',
    maxwidth = function()
      return math.floor(0.5 * vim.o.columns)
    end,
    ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
    show_labelDetails = true, -- show labelDetails in menu. Disabled by default
    menu = {
      buffer = "[buf]",
      nvim_lsp = "[LSP]",
      nvim_lua = "[api]",
      path = "[path]",
      luasnip = "[snip]"
    },

    -- The function below will be called before any actual modifications from lspkind
    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
    before = function(_, vim_item)
      vim_item.kind = (lspkind.presets.default[vim_item.kind] or '') .. ' '

      return vim_item
    end
  })
}
