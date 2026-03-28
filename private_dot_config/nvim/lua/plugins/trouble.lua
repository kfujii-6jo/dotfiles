return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
  },
  opts = {},
}
