-- LSP Configuration
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local lspconfig = require("lspconfig")

    -- Common on_attach function
    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    end

    -- Lua
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    })

    -- TypeScript/JavaScript
    lspconfig.ts_ls.setup({
      on_attach = on_attach,
    })

    -- Python
    lspconfig.pyright.setup({
      on_attach = on_attach,
    })

    -- HTML
    lspconfig.html.setup({
      on_attach = on_attach,
    })

    -- CSS
    lspconfig.cssls.setup({
      on_attach = on_attach,
    })

    -- PHP
    lspconfig.intelephense.setup({
      on_attach = on_attach,
    })
    
  end
}
