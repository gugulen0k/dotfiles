return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    "onsails/lspkind.nvim", -- vs-code like pictograms
    "L3MON4D3/LuaSnip", -- snippet engine
    "rafamadriz/friendly-snippets"
  },
  config = function()
    local cmp = require("cmp")

    local lspkind = require("lspkind")

    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip").filetype_extend("ruby", { "rails" })

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },

      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<Shift-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),

      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
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
          border = "single",
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
