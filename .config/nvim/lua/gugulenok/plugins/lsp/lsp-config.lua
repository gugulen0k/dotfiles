---------- [ Setup for relative imports ] ----------
local utils = require("gugulenok.utils")
local current_dir = utils.base_path("gugulenok.plugins.lsp")
----------------------------------------------------

return {
  "neovim/nvim-lspconfig",
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",           -- add Mason plugin
    "williamboman/mason-lspconfig.nvim", -- bridge between Mason and lspconfig
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    -- Load LSP configurations dynamically
    local diagnostics = current_dir.require("configs.lsp-diagnostics")     -- Load diagnostics configuration
    local handlers    = current_dir.require("configs.lsp-handlers")        -- Load handlers (e.g., floating window)
    local servers     = current_dir.require("configs.lsp-servers")         -- Load server configurations
    local on_attach   = current_dir.require("configs.lsp-utils").on_attach -- Keybindings and on_attach function

    -- Configure diagnostics, handlers, and LSP servers
    diagnostics.setup()
    handlers.setup()
    servers.setup(on_attach)
  end,
}
