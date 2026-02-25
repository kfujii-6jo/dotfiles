-- Autocmds for filetype detection and other automation

-- Ensure TSX and TypeScript files are properly recognized
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.tsx", "*.jsx" },
  callback = function()
    vim.opt_local.filetype = "typescriptreact"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.ts" },
  callback = function()
    vim.opt_local.filetype = "typescript"
  end,
})
