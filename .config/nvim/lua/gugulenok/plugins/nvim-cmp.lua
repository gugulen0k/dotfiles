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

    -- Completion for Vue files
    local function is_in_start_tag()
      local ts_utils = require('nvim-treesitter.ts_utils')
      local node = ts_utils.get_node_at_cursor()
      if not node then
        return false
      end
      local node_to_check = { 'start_tag', 'self_closing_tag', 'directive_attribute' }
      return vim.tbl_contains(node_to_check, node:type())
    end

    cmp.event:on('menu_closed', function()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.b[bufnr]._vue_ts_cached_is_in_start_tag = nil
    end)

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
        {
          name = "nvim_lsp",
          entry_filter = function(entry, ctx)
            -- Use a buffer-local variable to cache the result of the Treesitter check
            local bufnr = ctx.bufnr
            local cached_is_in_start_tag = vim.b[bufnr]._vue_ts_cached_is_in_start_tag
            if cached_is_in_start_tag == nil then
              vim.b[bufnr]._vue_ts_cached_is_in_start_tag = is_in_start_tag()
            end

            -- If not in start tag, return true
            if vim.b[bufnr]._vue_ts_cached_is_in_start_tag == false then
              return true
            end

            -- Check if the buffer type is 'vue'
            if ctx.filetype ~= 'vue' then
              return true
            end

            local cursor_before_line = ctx.cursor_before_line

            -- For events
            if cursor_before_line:sub(-1) == '@' then
              return entry.completion_item.label:match('^@')
            -- For props also exclude events with `:on-` prefix
            elseif cursor_before_line:sub(-1) == ':' then
              return entry.completion_item.label:match('^:') and not entry.completion_item.label:match('^:on%-')
            else
              return true
            end
          end
        },
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
