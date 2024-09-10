return {
  'mrcjkb/rustaceanvim',
  version = '^5', -- Recommended
  lazy = false,
  ft = { 'rust' },
  config = function()
    local utils = require("gugulenok.utils")

    vim.g.rustaceanvim = {
      server = {
        -- tools = {
        --   float_win_config = {
        --     border = "single",
        --   },
        -- },
        on_attach = function(_, bufnr)
          local opts = { noremap = true, silent = true }

          opts.buffer = bufnr

          opts.desc = "Show line diagnostics"
          utils.map("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

          opts.desc = "Show buffer diagnostics"
          utils.map("n", "<leader>bd", "<cmd>FzfLua diagnostics_document bufnr=0<CR>", opts) -- Show diagnostics for the current buffer
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {},
        }
      }
    }
  end
}
