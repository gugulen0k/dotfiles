local M = {}

function M.setup(config)
  local lspconfig = require("lspconfig")

  lspconfig.clangd.setup({
    capabilities = config.capabilities,
    on_attach = config.on_attach,
    filetypes = { "h", "c", "cpp", "cc", "objc", "objcpp" },
    cmd = { "clangd", "--background-index" },
    single_file_support = true,
    root_dir = lspconfig.util.root_pattern(
      '.clangd',
      '.clang-tidy',
      '.clang-format',
      'compile_commands.json',
      'compile_flags.txt',
      'configure.ac',
      '.git'
    )
  })
end

return M
