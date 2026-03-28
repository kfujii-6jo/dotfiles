return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>e", function() require("oil").open(vim.fn.getcwd()) end, desc = "Open oil at cwd" },
    { "<leader>E", function() require("oil").open_float(vim.fn.getcwd()) end, desc = "Open oil at cwd (float)" },
  },
  lazy = false,
  opts = {
    default_file_explorer = true,
    keymaps = {
      ["-"] = {
        callback = function()
          local oil = require("oil")
          local cwd = vim.fn.getcwd()
          local dir = oil.get_current_dir()
          if dir and vim.startswith(cwd, dir:sub(1, -2)) then
            return
          end
          oil.open()
        end,
        desc = "Open parent directory (restricted to cwd)",
      },
    },
  },
}
