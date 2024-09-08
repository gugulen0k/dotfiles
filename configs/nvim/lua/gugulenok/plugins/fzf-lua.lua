return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({
      "default",
      winopts = {
        border = "single",
        preview = {
          title = true,
          layout = 'vertical'
        },
      },
      grep = {
        rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git'",
      },
    })

    local utils = require("gugulenok.utils")
    local opts  = { noremap = true, silent = true }

    opts.desc = "Project file search"
    utils.map("n", "<C-p>", "<cmd>FzfLua files<CR>", opts)

    opts.desc = "Search inside opened buffers"
    utils.map("n", "<leader>l", "<cmd>FzfLua buffers<CR>", opts)

    opts.desc = "Search across files by text"
    utils.map("n", "<leader>f", "<cmd>FzfLua live_grep_native<CR>", opts)

    opts.desc = "Show methods in current buffer"
    utils.map("n", "<leader>t", "<cmd>FzfLua btags<CR>", opts)
  end
}
