return {
  "nvim-tree/nvim-web-devicons",
  dependencies = { "stevearc/oil.nvim" },
  config = function()
    local nvim_web_devicons = require("nvim-web-devicons")
    local utils = require("gugulenok.utils")

    local statusline_hl_group = utils.get_hl_by_name("StatusLine")
    utils.set_global_hl("WinBar", {
      -- fg = statusline_hl_group.fg,
      bg = statusline_hl_group.bg,
      bold = true
    })
    local winbar_hl_group = utils.get_hl_by_name("WinBar")

    -- Check if current buffer should have a winbar
    local function is_simple_buffer()
      local filetype = vim.bo.filetype
      local buftype = vim.bo.buftype

      -- Hide winbar for plugins like mason, lazy, and floating windows
      if filetype == "mason" or
          filetype == "lazy" or
          buftype == "nofile" or
          buftype == "prompt" or
          vim.fn.win_gettype() == "popup" then
        return false
      end

      return true
    end

    local function is_oil_buffer()
      if vim.bo.filetype == "oil" then
        return true
      end

      return false
    end

    -- Function to get the file icon based on filetype
    local function get_file_icon()
      local filename = vim.fn.expand("%:t")  -- Get filename with extension
      local extension = vim.fn.expand("%:e") -- Get file extension
      local icon, icon_highlight = nvim_web_devicons.get_icon(filename, extension)

      if icon == nil then
        icon = "" -- Default icon if none is found
        icon_highlight = "WinBar" -- Default highlight group
      end

      -- Use a buffer-local highlight group for the icon
      local buf_icon_hl_group = "WinBarIcon" .. vim.fn.bufnr("%") -- Unique group per buffer
      local icon_hl_group = utils.get_hl_by_name(icon_highlight)

      utils.set_global_hl(buf_icon_hl_group, {
        fg = icon_hl_group.fg or winbar_hl_group.fg, -- Use icon's foreground
        bg = winbar_hl_group.bg                      -- Set background to match WinBar
      })

      -- Use the buffer-local highlight group for the icon
      return "%#" .. buf_icon_hl_group .. "#" .. icon .. "%#WinBar#"
    end

    -- Function to generate the buffer-specific winbar
    local function buffer_winbar()
      if not is_simple_buffer() then
        return ""
      end

      local warning_msg_hl_group = utils.get_hl_by_name("WarningMsg")
      utils.set_global_hl("WinBarModified", {
        fg = warning_msg_hl_group.fg,
        bg = winbar_hl_group.bg
      })
      local modified = vim.bo.modified and "%#WinBarModified#[+]%#WinBar#" or ""

      local icon = get_file_icon()
      local readonly = vim.bo.readonly and " " or ""

      return table.concat({
        "%#WinBar#", -- Set background for whole winbar
        "%=",        -- Align to center
        icon,        -- File icon
        " %t ",      -- Filename with filetype
        readonly,    -- Readonly status
        modified,    -- Modified file status
        "%=",        -- Align to center
      })
    end

    local function oil_dir()
      local oil = require("oil")
      local dir = oil.get_current_dir()

      if dir then
        return vim.fn.fnamemodify(dir, ":~")
      else
        -- If there is no current directory (e.g. over ssh), just show the buffer name
        return vim.api.nvim_buf_get_name(0)
      end
    end

    local function oil_buffer()
      local modified = vim.bo.modified and "%#WinBarModified#[+]%#WinBar#" or ""

      return table.concat({ "%#WinBar#", oil_dir(), modified })
    end

    local function set_winbar()
      if is_oil_buffer() then
        return oil_buffer()
      elseif is_simple_buffer() then
        return buffer_winbar()
      end
    end

    -- Set the winbar dynamically on buffer enter
    local winbar_update_events = {
      "BufEnter",
      "BufNewFile",
      "BufModifiedSet",
      "CursorMoved",
    }
    vim.api.nvim_create_autocmd(winbar_update_events, {
      callback = function()
        vim.opt_local.winbar = set_winbar()
      end,
    })
  end
}
