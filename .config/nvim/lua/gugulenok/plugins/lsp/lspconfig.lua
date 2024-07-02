return {
  "neovim/nvim-lspconfig",
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    "williamboman/mason.nvim", -- add Mason plugin
    "williamboman/mason-lspconfig.nvim", -- bridge between Mason and lspconfig
  },
  config = function()
    local utils        = require("gugulenok.utils")
    local lspconfig    = require("lspconfig")    -- import lspconfig plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp") -- import cmp-nvim-lsp plugin

    local opts = { noremap = true, silent = true }
    local on_attach = function(_, bufnr)
      opts.buffer = bufnr

      -- set keybinds
      opts.desc = "Show buffer diagnostics"
      utils.map("n", "<leader>bd", "<cmd>FzfLua diagnostics_document bufnr=0<CR>", opts) -- show diagnostics for file

      opts.desc = "Show line diagnostics"
      utils.map("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

      opts.desc = "Restart LSP"
      utils.map("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
    end

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Change floating window border for lsp
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, config, ...)
      config = config or {}
      config.border = "single" or opts.border
      config.bg = "NONE"

      return orig_util_open_floating_preview(contents, syntax, config, ...)
    end

    -- configure servers using Mason
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end,
      ["solargraph"] = function()
        lspconfig.solargraph.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          cmd = { "solargraph", "stdio" },
          filetypes = { "ruby" },
          root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
          settings = {
            solargraph = {
              diagnostics = true,
              completion = {
                enable = true,
                triggerCharacters = { ".", ":", "::" },
                debounce = 100,
                maxItems = 100
              },
              hover = {
                enable = true,
                delay = 100
              }
            }
          },
        })
      end,
      ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = { -- custom settings for lua
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                -- make language server aware of runtime files
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
              },
            },
          },
        })
      end,
    })
  end,
}
