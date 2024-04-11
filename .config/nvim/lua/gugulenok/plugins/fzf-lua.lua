return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({
      "default",
      winopts = {
        border = 'single',
        preview = {
          layout = 'vertical'
        },
      }
    })

    local keymap = vim.keymap -- for conciseness
    local opts   = { noremap = true, silent = true }

    opts.desc = "Project file search"
    keymap.set("n", "<C-p>", "<cmd>FzfLua files<CR>", opts)

    opts.desc = "Search inside opened buffers"
    keymap.set("n", "<leader>l", "<cmd>FzfLua buffers<CR>", opts)

    opts.desc = "Search across files by text"
    keymap.set("n", "<leader>f", "<cmd>FzfLua live_grep_native<CR>", opts)

    opts.desc = "Show methods in current buffer"
    keymap.set("n", "<leader>t", "<cmd>FzfLua btags<CR>", opts)
  end
}
