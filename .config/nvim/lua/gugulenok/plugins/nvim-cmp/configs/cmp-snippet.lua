local utils = require("gugulenok.utils")
local luasnip = require("luasnip")

---------------------- [ Keymaps to navigate LuaSnip snippets ] ---------------------------
utils.map({ "i" }, "<C-K>", function() luasnip.expand() end, { silent = true })      -- Expand
utils.map({ "i", "s" }, "<C-L>", function() luasnip.jump(1) end, { silent = true })  -- Jump forward
utils.map({ "i", "s" }, "<C-J>", function() luasnip.jump(-1) end, { silent = true }) -- Jump backward

-- Change the active choice
utils.map({ "i", "s" }, "<C-E>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true })
-------------------------------------------------------------------------------------------

return {
  expand = function(args)
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.filetype_extend("ruby", { "rails" }) -- add Rails snippets to ruby.
    luasnip.filetype_extend("vue", { "vue" })    -- add Vue snippets to js.

    luasnip.lsp_expand(args.body)
  end
}
