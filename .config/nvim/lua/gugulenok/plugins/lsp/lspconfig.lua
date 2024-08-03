return {
  "neovim/nvim-lspconfig",
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim", -- add Mason plugin
    "williamboman/mason-lspconfig.nvim", -- bridge between Mason and lspconfig
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
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
    local capabilities = vim.tbl_deep_extend("force",
      vim.lsp.protocol.make_client_capabilities(),
      cmp_nvim_lsp.default_capabilities()
    )

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Diagnostics config
    vim.diagnostic.config({
      virtual_text = {
        prefix = " "
      },
      float = {
        show_header = false,
        format = function(diagnostic)
          return string.format('%s\n%s: %s', diagnostic.message, diagnostic.source, diagnostic.code)
        end,
      },
    })

    -- Change floating window border for lsp
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, config, ...)
      config = config or {}
      config.border = "single" or opts.border
      config.bg = "NONE"

      return orig_util_open_floating_preview(contents, syntax, config, ...)
    end

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover,
      { border = "single" }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      { border = "single" }
    )

    require('lspconfig.ui.windows').default_options.border = 'single'

    local function get_vue_ts_plugin_path_from_mason()
      local mason_registry = require("mason-registry")
      local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
        .. "/node_modules/@vue/language-server"

      return vue_language_server_path
    end

    -- configure servers using Mason
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        local server_config = {
          capabilities = capabilities,
          on_attach = on_attach,
        }

        lspconfig[server_name].setup(server_config)
      end,
      ["tsserver"] = function ()
        lspconfig.tsserver.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "typescript" },
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = get_vue_ts_plugin_path_from_mason(),
                languages = { "vue" }
              }
            }
          }
        })
      end,
      ["volar"] = function ()
        lspconfig.volar.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          init_options = {
            vue = {
              hybridMode = false
            }
          }
        })
      end,
      ["eslint"] = function ()
        lspconfig.eslint.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          filetypes = { "javascript", "vue" }
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
