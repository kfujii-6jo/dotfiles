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

-- Show diagnostics or LSP hover automatically on cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    -- Check if there are diagnostics at cursor position
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })

    if #diagnostics > 0 then
      -- Show diagnostics if present
      vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
    else
      -- Show LSP hover info if no diagnostics
      -- Use vim.lsp.buf.hover() in a protected call to avoid errors
      pcall(function()
        vim.lsp.buf.hover()
      end)
    end
  end,
})
