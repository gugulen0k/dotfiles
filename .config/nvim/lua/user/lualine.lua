require('lualine').setup {
  options = {
    icons_enabled        = true,
    theme                = 'auto',
    component_separators = { left = '|', right = '|'},
    section_separators   = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar     = {},
    },
    ignore_focus         = {},
    always_divide_middle = true,
    globalstatus         = true,
    refresh = {
      statusline = 1000,
      tabline    = 1000,
      winbar     = 1000,
    }
  },
  sections = {
    lualine_a = {},
    lualine_b = {
        {'branch', icon = ''},
        {
          'diff',
          colored = true,
          symbols = {added = '+', modified = '~', removed = '-'}
        },
        {
          'diagnostics',
          sections         = {'error', 'warn'},
          symbols          = {error = ' ', warn = ' '},
          colored          = true,                       -- Displays diagnostics status in color if set to true.
          update_in_insert = false                       -- Update diagnostics in insert mode.
        }
    },
    lualine_c = {
      {
        'filename',
        file_status    = true,  -- Displays file status (readonly status, modified status)
        newfile_status = false, -- Display new file status (new file means no write after created)
        path           = 1,
        symbols = {
          modified = '',       -- Text to show when the file is modified.
          readonly = '',       -- Text to show when the file is non-modifiable or readonly.
          unnamed  = '[No Name]', -- Text to show for unnamed buffers.
          newfile  = '[New]',     -- Text to show for newly created file before first write
        }
      }
    },
    lualine_x = {'filetype'},
    lualine_y = {
      {'progress'},
      {'searchcount'}
    },
    lualine_z = {'mode'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline         = {},
  winbar          = {},
  inactive_winbar = {},
  extensions      = {}
}
