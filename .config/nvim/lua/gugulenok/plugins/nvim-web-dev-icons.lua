return {
  'nvim-tree/nvim-web-devicons',
  config = function()
    require'nvim-web-devicons'.setup {
      default = true,
      strict  = true,

      override_by_extension = {
        ['rb'] = {
          icon  = '',
          color = '#C70D3A',
          name  = 'Ruby'
        },
        ['txt'] = {
          icon  = '󰈔',
          color = '#232D3F',
          name  = 'Txt'
        },
        ['.gitignore'] = {
          icon  = '󰊢',
          color = '#232D3F',
          name  = 'GitIgnore'
        },
        ['lock'] = {
          icon  = '',
          color = '#232D3F',
          name  = 'Lock'
        },
        ['md'] = {
          icon  = '',
          color = '#232D3F',
          name  = 'Markdown'
        },
        ['conf'] = {
          icon  = '',
          color = '#232D3F',
          name  = 'Conf'
        },
        ['.zshrc'] = {
          icon = '',
          color = '#232D3F',
          name  = 'Zshrc'
        },
        ['yml'] = {
          icon  = '',
          color = '#232D3F',
          name  = 'Yml'
        },
        ['yaml'] = {
          icon  = '',
          color = '#232D3F',
          name  = 'Yaml'
        },
      }
    }
  end
}
