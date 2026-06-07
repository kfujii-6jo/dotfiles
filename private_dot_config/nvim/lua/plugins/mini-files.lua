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
        synchronize = "<C-s>",
      },
      options = {
        permanent_delete = false,
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf = args.data.buf_id
        vim.b[buf].is_mini_files = true
        vim.bo[buf].buftype = "acwrite"
        vim.keymap.set("n", "h", function()
          local state = mini_files.get_explorer_state()
          if state then
            local current_dir = state.branch[#state.branch]
            if current_dir and vim.startswith(current_dir, cwd) and current_dir ~= cwd then
              mini_files.go_out()
            end
          end
        end, { buffer = buf, desc = "Go out (restricted to cwd)" })
        local sync = function() mini_files.synchronize() end
        vim.keymap.set("n", "<C-s>", sync, { buffer = buf, desc = "Synchronize" })
        vim.keymap.set("i", "<C-s>", function()
          vim.cmd("stopinsert")
          mini_files.synchronize()
        end, { buffer = buf, desc = "Synchronize from insert" })
        vim.api.nvim_create_autocmd("BufWriteCmd", {
          buffer = buf,
          callback = function()
            mini_files.synchronize()
            vim.bo[buf].modified = false
          end,
        })
      end,
    })
  end,
}
