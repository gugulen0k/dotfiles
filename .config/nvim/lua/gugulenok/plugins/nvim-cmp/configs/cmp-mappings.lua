local cmp = require("cmp")
local utils = require("gugulenok.utils")

-- Disable default autocompletion using buffer words.
local opts = {
  silent = true,
  noremap = true
}
utils.map("i", "<C-n>", "<NOP>", opts)
utils.map("i", "<C-p>", "<NOP>", opts)

return cmp.mapping.preset.insert({
  ["<C-p>"] = cmp.mapping.select_prev_item(),
  ["<C-n>"] = cmp.mapping.select_next_item(),
  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  ["<C-f>"] = cmp.mapping.scroll_docs(4),
  ["<C-y>"] = cmp.mapping.confirm({ select = true }),
  ["<C-e>"] = cmp.mapping.abort(),
})
