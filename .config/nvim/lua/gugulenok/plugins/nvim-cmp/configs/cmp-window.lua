local cmp = require("cmp")

return {
  completion = cmp.config.window.bordered({
    border = "single",
    side_padding = 0,
  }),
  documentation = cmp.config.window.bordered({
    border = "single"
  }),
}
