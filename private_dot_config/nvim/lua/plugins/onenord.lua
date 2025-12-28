return {
  "rmehri01/onenord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("onenord").setup()
    vim.cmd.colorscheme("onenord")
  end,
}
