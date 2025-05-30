---------- [ Setup for relative imports ] ----------
local utils = require("gugulenok.utils")
local current_dir = utils.base_path("gugulenok.plugins.nvim-cmp")
----------------------------------------------------

return {
  "hrsh7th/nvim-cmp",
  branch = "main",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",   -- source for text in buffer
    "hrsh7th/cmp-path",     -- source for file system paths
    "hrsh7th/cmp-nvim-lua", -- source for nvim lua
    "onsails/lspkind.nvim", -- vs-code like pictograms
    {
      -- Snippet engine
      "L3MON4D3/LuaSnip",
      lazy = false,
      tag = "v2.3.0",
      run = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" } -- snippets collection

    }
  },
  config = function()
    local cmp = require("cmp")

    -- Require the extracted parts from the cmp_config folder.
    -- Load the Vue filtering logic.
    local vue_filter = current_dir.require("configs.languages.vue-filter")

    -- Cleanup cached tags when completion menu closes
    cmp.event:on('menu_closed', vue_filter.clear_vue_cache)

    -- Set up completion and mappings
    cmp.setup({
      completion = current_dir.require("configs.cmp-completion"), -- Load completion from a separate file
      snippet = current_dir.require("configs.cmp-snippet"),       -- Load snippet configuration from a separate file
      mapping = current_dir.require("configs.cmp-mappings"),      -- Load mappings from separate file
      sources = current_dir.require("configs.cmp-sources"),       -- Load sources from separate file
      window = current_dir.require("configs.cmp-window"),         -- Load window configuration
      formatting = current_dir.require("configs.cmp-formatting"), -- Load formatting configuration
    })
  end,
}
