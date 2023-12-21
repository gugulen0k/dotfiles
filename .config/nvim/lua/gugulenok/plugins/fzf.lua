return {
  "junegunn/fzf",
  dependencies = {
    "junegunn/fzf.vim",
  },
  config = function ()
    local function map(mode, shortcut, command)
      vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
    end

    local function nmap(shortcut, command)
      map('n', shortcut, command)
    end

    nmap('<C-p>', ':Files<CR>')       -- Search files
    nmap('<leader>f', ':Rg<CR>')      -- Search across files by text
    nmap('<leader>d', ':BTags<CR>')   -- Shows methods in current buffer
    nmap('<leader>b', ':Buffers<CR>') -- Search inside opened buffers
  end
}
