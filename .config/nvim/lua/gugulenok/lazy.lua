local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
  { import = "gugulenok.plugins" },
  { import = "gugulenok.plugins.lsp" },
  { import = "gugulenok.plugins.nvim-cmp" },
}, {
  install = {
    colorscheme = { "gruvbox-material" },
  },
  ui = {
    border = 'single',
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  }
})
