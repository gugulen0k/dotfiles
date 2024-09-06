local vue_filter = require("gugulenok.plugins.nvim-cmp.configs.languages.vue-filter")

return {
  {
    name = "nvim_lsp",
    entry_filter = function(entry, ctx)
      local bufnr = ctx.bufnr
      if vim.b[bufnr]._vue_ts_cached_is_in_start_tag == nil then
        vim.b[bufnr]._vue_ts_cached_is_in_start_tag = vue_filter.is_in_start_tag()
      end

      if vim.b[bufnr]._vue_ts_cached_is_in_start_tag == false then
        return true
      end

      if ctx.filetype ~= 'vue' then return true end

      local cursor_before_line = ctx.cursor_before_line
      if cursor_before_line:sub(-1) == '@' then
        return entry.completion_item.label:match('^@')
      elseif cursor_before_line:sub(-1) == ':' then
        return entry.completion_item.label:match('^:') and not entry.completion_item.label:match('^:on%-')
      else
        return true
      end
    end
  },
  { name = "nvim_lua" },
  { name = "buffer" },
  { name = "path" },
  { name = "crates" }
}
