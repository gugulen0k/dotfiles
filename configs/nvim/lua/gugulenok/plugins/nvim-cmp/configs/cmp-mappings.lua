local cmp = require("cmp")
local utils = require("gugulenok.utils")

-- Disable default autocompletion that uses buffer words.
local opts = {
  silent = true,
  noremap = true
}
utils.map("i", "<C-n>", "<NOP>", opts)
utils.map("i", "<C-p>", "<NOP>", opts)

return cmp.mapping.preset.insert({
  ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
  ["<C-y>"] = cmp.mapping(
    cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true
    },
    { "i", "c" }
  ),
  ["<C-e>"] = cmp.mapping.abort(),
})
