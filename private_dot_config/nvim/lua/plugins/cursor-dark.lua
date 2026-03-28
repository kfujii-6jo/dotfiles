return {
  "ydkulks/cursor-dark.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("cursor-dark").setup({
      transparent = false,
    })
    vim.cmd.colorscheme("cursor-dark")
  end,
}
