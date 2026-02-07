-- LSP Configuration (Neovim 0.11+ vim.lsp.config API)
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Common keymaps via LspAttach autocmd
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local opts = { noremap = true, silent = true, buffer = args.buf }

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      end,
    })

    -- Lua
    vim.lsp.config.lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    }

    -- TypeScript/JavaScript
    vim.lsp.config.ts_ls = {}

    -- Python
    vim.lsp.config.pyright = {}

    -- HTML
    vim.lsp.config.html = {}

    -- CSS
    vim.lsp.config.cssls = {}

    -- PHP
    vim.lsp.config.intelephense = {}

    -- Enable all configured LSP servers
    vim.lsp.enable({ 'lua_ls', 'ts_ls', 'pyright', 'html', 'cssls', 'intelephense' })
  end
}
