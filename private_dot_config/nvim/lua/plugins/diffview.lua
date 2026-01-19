-- Diffview plugin for git diff and history
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
    { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
    { "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
    { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    { "<leader>dr", "<cmd>DiffviewClose<cr><cmd>DiffviewOpen<cr>", desc = "Diffview Reload" },
  },
  config = function()
    require("diffview").setup({
      view = {
        default = {
          layout = "diff2_vertical"
        }
      },
    })
  end,
}
