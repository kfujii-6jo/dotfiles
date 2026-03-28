return {
  "echasnovski/mini.files",
  version = false,
  lazy = false,
  keys = {
    { "<leader>e", function() require("mini.files").open(vim.fn.getcwd()) end, desc = "Open mini.files at cwd" },
    { "<leader>E", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, desc = "Open mini.files at current file" },
  },
  config = function()
    local mini_files = require("mini.files")
    local cwd = vim.fn.getcwd()

    mini_files.setup({
      mappings = {
        go_in_plus = "<CR>",
        go_out = "",
      },
      options = {
        permanent_delete = false,
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        vim.keymap.set("n", "h", function()
          local state = mini_files.get_explorer_state()
          if state then
            local current_dir = state.branch[#state.branch]
            if current_dir and vim.startswith(current_dir, cwd) and current_dir ~= cwd then
              mini_files.go_out()
            end
          end
        end, { buffer = args.data.buf_id, desc = "Go out (restricted to cwd)" })
      end,
    })
  end,
}
