return {
  'nvim-tree/nvim-web-devicons',
  config = function()
    require'nvim-web-devicons'.setup {
      strict = true,

      override_by_extension = {
        ['rb'] = {
          icon = '',
          name = 'Ruby'
        },
        ['lua'] = {
          icon = '',
          name = 'Lua'
        },
        ['js'] = {
          icon = '',
          name = 'JavaScript'
        },
        ['rs'] = {
          icon = '󱘗',
          name = 'Rust'
        },
        ['py'] = {
          icon = '󰌠',
          name = 'Python'
        },
        ['jsx'] = {
          icon = '󰜈',
          name = 'React'
        },
        ['vue'] = {
          icon = '󰡄',
          name = 'Vue'
        },
        ['json'] = {
          icon = '',
          name = 'Json'
        },
        ['txt'] = {
          icon = '󰈔',
          name = 'Txt'
        },
        ['.gitignore'] = {
          icon = '󰊢',
          name = 'GitIgnore'
        },
        ['lock'] = {
          icon = '',
          name = 'Lock'
        },
        ['md'] = {
          icon = '',
          name = 'Markdown'
        },
        ['conf'] = {
          icon = '',
          name = 'Conf'
        },
        ['.zshrc'] = {
          icon = '',
          name = 'Zshrc'
        },
        ['yml'] = {
          icon = '',
          name = 'Yml'
        },
        ['yaml'] = {
          icon = '',
          name = 'Yaml'
        },
      }
    }
  end
}
