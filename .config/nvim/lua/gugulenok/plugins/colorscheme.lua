return {
  'rose-pine/neovim',
  name = 'rose-pine',
  lazy = false,
  priority = 1000,
  config = function()
    require("rose-pine").setup({
      variant                          = 'dawn',
      dark_variant                     = 'main',
      extend_background_behind_borders = false,

      enable = {
        terminal          = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations        = true, -- Handle deprecated options automatically
      },

      styles = {
        bold         = true,
        italic       = true,
        transparency = false,
      },

      highlight_groups = {
        ColorColumn = { fg = 'base', bg = 'muted' },
        FloatBorder = { bg = 'NONE' }
      },
    })

    vim.opt.background = 'light'

    vim.cmd.colorscheme 'rose-pine'
  end
}

-- return {
--   "catppuccin/nvim",
--   name = "catppuccin",
--   lazy = false,
--   priority = 1000, -- make sure this loads before any other plugin
--   config = function()
--     require("catppuccin").setup({
--       flavour = "latte", -- latte, frappe, macchiato, mocha
--       background = { -- :h background
--         light = "latte",
--         dark = "mocha",
--       },
--       transparent_background = false, -- disables setting the background color.
--       show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
--       term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
--       no_italic = false, -- Force no italic
--       no_bold = false, -- Force no bold
--       no_underline = false, -- Force no underline
--       styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
--           comments = { "italic" }, -- Change the style of comments
--           conditionals = {},
--           loops = {},
--           functions = {},
--           keywords = {},
--           strings = {},
--           variables = {},
--           numbers = {},
--           booleans = {},
--           properties = {},
--           types = {},
--           operators = {},
--       },
--       integrations = {
--         cmp = true,
--         gitsigns = true,
--         nvimtree = true,
--         treesitter = true,
--         mason = true,
--         mini = {
--           enabled = true,
--         },
--     }
--     })

--     vim.cmd.colorscheme "catppuccin"
--   end,
-- }

-- return {
--   'savq/melange-nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.opt.background = 'light'
--     vim.cmd.colorscheme 'melange'
--   end
-- }

