require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'ruby_ls',
    'solargraph',
    'pyright',
    'quick_lint_js',
    'yamlls',
    'tsserver',
    'tailwindcss'
  },
  automatic_installation = true,
})

--================== { LSP Diagnostics Setup } =====================--
-------------------------- Global settings ---------------------------
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
end

vim.diagnostic.config({
    underline = true,
    signs = true,
    virtual_text = true,
    float = {
        show_header = true,
        source = 'always',
        focusable = false,
        border = 'rounded'
    }
})

-- Settings for vim.lsp.buf.hover function
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = 'rounded',
    source = 'always',
    prefix = ' ',
    scope = 'cursor',
  }
)
----------------------------------------------------------------------

------------------ Language specific LSP settings --------------------
require('mason-lspconfig').setup_handlers({
  function(server)
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    local on_attach = function(_, bufnr)
      opts.buffer = bufnr

      opts.desc = 'Smart rename'
      keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)

      opts.desc = 'Show documentation for what is under the cursor'
      keymap.set('n', 'K', vim.lsp.buf.hover, opts)

      opts.desc = 'Show current buffer diagnostics'
      keymap.set('n', '<C-l>', vim.diagnostic.open_float, opts)
    end

    if server == 'lua_ls' then
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
      })
    else
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end
  end,
})
----------------------------------------------------------------------
--==================================================================--
