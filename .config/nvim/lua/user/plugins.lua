local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print("Installing packer close and reopen Neovim...")
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
)

-- Install your plugins here
return packer.startup(function(use)
  -- Different plugins
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins
  use "christoomey/vim-tmux-navigator"

  -- Cosmetical plugins (with themes)
  use({ 'rose-pine/neovim', as = 'rose-pine' })
  use "folke/tokyonight.nvim"
  use { 'mrshmllow/document-color.nvim', config = function()
      require("document-color").setup {
        -- Default options
        mode = "background", -- "background" | "foreground" | "single"
      }
    end
  }

  -- IDE plugins
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true }
  }
  use {
    "nvim-treesitter/nvim-treesitter",
    run = function()
        local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
        ts_update()
    end,
  }
  use {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }
  use {
    "andymass/vim-matchup",
    setup = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end
  }
  use {
    "folke/trouble.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true }
  }
  use "tpope/vim-surround"
  use "tpope/vim-fugitive"
  use "tpope/vim-commentary"
  use "tpope/vim-endwise"
  use "tpope/vim-repeat"
  use "echasnovski/mini.splitjoin"
  use "onsails/lspkind.nvim"
  use "nvim-tree/nvim-tree.lua"
  use "nvim-tree/nvim-web-devicons"
  use "lukas-reineke/indent-blankline.nvim"     -- Indentation guides to all lines
  use "stevearc/dressing.nvim"
  use "junegunn/fzf"
  use "junegunn/fzf.vim"
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lsp-signature-help"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-calc"
  use "f3fora/cmp-spell"
  use "L3MON4D3/LuaSnip"
  use "saadparwaiz1/cmp_luasnip"
  use "lewis6991/gitsigns.nvim"
  use 'Vonr/align.nvim'

  -- Language support plugins
  use "vim-ruby/vim-ruby"
  use "kchmck/vim-coffee-script"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
