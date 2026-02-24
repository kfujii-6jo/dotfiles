-- Mason (LSP server manager)
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "pyright",
        "html",
        "cssls",
        "intelephense", -- PHP
      },
      automatic_installation = true,
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        -- Formatters
        "stylua", -- Lua
        "prettierd", -- JS/TS/HTML/CSS/JSON/Markdown/YAML
        "biome", -- JS/TS/HTML/CSS/JSON/Markdown/YAML
        "black", -- Python
        "php-cs-fixer", -- PHP
        "goimports", -- Go
      },
      auto_update = false,
      run_on_start = true,
    })
  end,
}
