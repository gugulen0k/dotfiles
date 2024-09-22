---------- [ Setup for relative imports ] ----------
local utils = require("gugulenok.utils")
local current_dir = utils.base_path("gugulenok.plugins.lsp.configs")
----------------------------------------------------

---------------- [ Require languages ] -------------------
local languages = {
  volar = current_dir.require("languages.volar"),
  lua_ls = current_dir.require("languages.lua_ls"),
  solargraph = current_dir.require("languages.solargraph"),
  ts_ls = current_dir.require("languages.ts_ls"),
  rust_analyzer = current_dir.require("languages.rust_analyzer")
}
----------------------------------------------------------

local M = {}

function M.setup(options)
  local lspconfig = require("lspconfig")
  local mason_lspconfig = require("mason-lspconfig")
  local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
  )

  mason_lspconfig.setup_handlers({
    function(server_name)
      local default_server_config = {
        capabilities = capabilities,
        on_attach = options.on_attach,
        handlers = options.handlers
      }

      -- Check if a specific setup function is available for this server
      local specific_setup = languages[server_name]
      if specific_setup then
        specific_setup.setup(default_server_config)
      else
        -- Apply default setup if no specific setup function is available
        lspconfig[server_name].setup(default_server_config)
      end
    end,
  })
end

return M
