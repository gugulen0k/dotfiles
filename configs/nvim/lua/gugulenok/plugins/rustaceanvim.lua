return {
  'mrcjkb/rustaceanvim',
  version = '^4', -- Recommended
  ft = { 'rust' },
  config = function ()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(_, bufnr)
          local opts = { noremap = true, silent = true }

          opts.buffer = bufnr

          opts.desc = "Show line diagnostics"
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {
            on_attach = on_attach,
          },
        }
      }
    }
  end
}
