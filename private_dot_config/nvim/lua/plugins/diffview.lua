-- Diffview plugin for git diff and history
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
    { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
    { "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
    { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
  },
  config = function()
    require("diffview").setup({
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_horizontal",
        },
        file_history = {
          layout = "diff2_horizontal",
        },
      },
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
      },
    })
  end,
}
