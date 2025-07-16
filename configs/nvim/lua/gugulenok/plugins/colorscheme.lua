return {
	"savq/melange-nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		vim.o.background = "light"

		vim.cmd.colorscheme("melange")

		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

		vim.api.nvim_set_hl(0, "NeotestFailed", { fg = "#C77B8B" })
		vim.api.nvim_set_hl(0, "NeotestPassed", { fg = "#6E9B72" })
		vim.api.nvim_set_hl(0, "NeotestRunning", { fg = "#BC5C00" })
	end,
}

-- return {
-- 	"rose-pine/neovim",
-- 	name = "rose-pine",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		require("rose-pine").setup({
-- 			variant = "main",
-- 			dark_variant = "main",
-- 			extend_background_behind_borders = false,
--
-- 			enable = {
-- 				terminal = true,
-- 				legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
-- 				migrations = true, -- Handle deprecated options automatically
-- 			},
--
-- 			styles = {
-- 				bold = true,
-- 				italic = true,
-- 				transparency = true,
-- 			},
--
-- 			highlight_groups = {
-- 				ColorColumn = { fg = "base", bg = "muted" },
-- 				NormalFloat = { bg = "NONE" },
-- 				FloatBorder = { bg = "NONE" },
-- 			},
-- 		})
--
-- 		vim.opt.background = "dark"
--
-- 		vim.cmd.colorscheme("rose-pine")
-- 	end,
-- }

-- return {
--   'tinted-theming/base16-vim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.g.base16_colorspace = 256
--
--     vim.cmd.colorscheme('base16-default-dark')
--
--     vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
--     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--   end
-- }

-- return {
--   'sainnhe/gruvbox-material',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     local glb = vim.g
--
--     vim.opt.background = 'light'
--     glb.gruvbox_material_enable_italic = true
--     glb.gruvbox_material_enable_bold = true
--     glb.gruvbox_material_ui_contrast = 'high'
--     glb.gruvbox_material_better_performance = true
--     glb.gruvbox_material_float_style = 'bright'
--
--     vim.api.nvim_create_autocmd('ColorScheme', {
--       group = vim.api.nvim_create_augroup('custom_highlights_gruvboxmaterial', {}),
--       pattern = 'gruvbox-material',
--       callback = function()
--         local config = vim.fn['gruvbox_material#get_configuration']()
--         local palette = vim.fn['gruvbox_material#get_palette'](config.background, config.foreground,
--           config.colors_override)
--         local set_hl = vim.fn['gruvbox_material#highlight']
--
--         set_hl('FloatBorder', palette.none, palette.none)
--         set_hl('NormalFloat', palette.none, palette.none)
--       end
--     })
--
--     vim.cmd.colorscheme('gruvbox-material')
--   end
-- }

-- return {
--   "catppuccin/nvim",
--   name = "catppuccin",
--   lazy = false,
--   priority = 1000, -- make sure this loads before any other plugin
--   config = function()
--     require("catppuccin").setup({
--       flavour = "mocha", -- latte, frappe, macchiato, mocha
--       background = {     -- :h background
--         light = "latte",
--         dark = "mocha",
--       },
--       transparent_background = false, -- disables setting the background color.
--       show_end_of_buffer = true,      -- shows the '~' characters after the end of buffers
--       term_colors = true,             -- sets terminal colors (e.g. `g:terminal_color_0`)
--       no_italic = false,              -- Force no italic
--       no_bold = false,                -- Force no bold
--       no_underline = false,           -- Force no underline
--       styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
--         comments = { "italic" },      -- Change the style of comments
--         conditionals = { "bold" },
--         loops = { "bold" },
--         functions = { "bold" },
--         keywords = {},
--         strings = {},
--         variables = {},
--         numbers = {},
--         booleans = { "bold" },
--         properties = { "italic" },
--         types = { "bold" },
--         operators = {},
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
--       },
--       color_overrides = {
--         all = {
--           text = "#ffffff",
--         },
--         mocha = {
--           base = "#303446",
--           crust = "#242634",
--           mantle = "#242634",
--         }
--       }
--     })
--
--     vim.cmd.colorscheme "catppuccin"
--   end,
-- }
