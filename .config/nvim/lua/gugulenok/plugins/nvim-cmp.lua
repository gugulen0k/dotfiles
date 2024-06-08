return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",   -- source for text in buffer
    "hrsh7th/cmp-path",     -- source for file system paths
    "onsails/lspkind.nvim", -- vs-code like pictograms
  },
  config = function()
    local cmp     = require("cmp")
    local lspkind = require("lspkind")

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },

      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-k>"]     = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"]     = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
        ["<C-f>"]     = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),         -- show completion suggestions
        ["<C-e>"]     = cmp.mapping.abort(),            -- close completion window
        ["<CR>"]      = cmp.mapping.confirm({ select = false }),
      }),

      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
        { name = "crates" } -- for Rust package manager
      }),

      window = {
        completion = cmp.config.window.bordered({
          border = "single",
          side_padding = 0,
        }),
        documentation = cmp.config.window.bordered({
          border = "single"
        }),
      },

      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",

          before = function (_, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind] or "?"
            vim_item.menu = ''

            return vim_item
          end
        }),
      },
    })
  end,
}
