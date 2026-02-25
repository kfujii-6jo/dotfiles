return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = {
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
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    auto_install = true,
  },
}
