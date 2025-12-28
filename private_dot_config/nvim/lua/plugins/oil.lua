-- Oil.nvim (file explorer) plugin
return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      view_options = { show_hidden = true },
      watch_for_changes = true,
      default_file_explorer = true,
    })
  end,
  keys = {
    { '<leader>e', '<cmd>Oil<cr>', desc = 'Open file explorer (Oil)' },
    { '<leader>E', '<cmd>Oil --float<cr>', desc = 'Open file explorer (Oil) in float' },
  },
}

