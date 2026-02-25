-- Neo-tree.nvim (file explorer) plugin
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        indent = {
          padding = 0,
          with_expanders = true,
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["<space>"] = "none",
          ["<cr>"] = "open",
          ["l"] = "open",
          ["h"] = "close_node",
          ["v"] = "open_vsplit",
          ["s"] = "open_split",
          ["t"] = "open_tabnew",
          ["C"] = "close_all_nodes",
          ["R"] = "refresh",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["q"] = "close_window",
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
            ".wt",
          },
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
    })
  end,
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer (Neo-tree)" },
    { "<leader>E", "<cmd>Neotree float<cr>", desc = "Open file explorer (Neo-tree) in float" },
  },
}
