return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    -- Install parsers
    local parsers = {
      "tsx",
      "typescript",
      "javascript",
      "jsx",
      "lua",
      "vim",
      "vimdoc",
      "json",
      "yaml",
      "markdown",
      "markdown_inline",
      "bash",
      "go",
      "python",
      "html",
      "css",
    }

    require("nvim-treesitter").install(parsers)

    -- Enable treesitter highlighting for specific filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "typescript",
        "typescriptreact",
        "javascript",
        "javascriptreact",
        "tsx",
        "jsx",
        "lua",
        "vim",
        "json",
        "yaml",
        "markdown",
        "bash",
        "go",
        "python",
        "html",
        "css",
      },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
