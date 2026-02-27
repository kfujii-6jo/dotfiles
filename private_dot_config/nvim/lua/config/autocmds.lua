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
    local opts = { focus = false, scope = "cursor" }

    -- Check if there are diagnostics at cursor position
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })

    if #diagnostics > 0 then
      -- Show diagnostics if present
      vim.diagnostic.open_float(nil, opts)
    else
      -- Show LSP hover info if no diagnostics
      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result, ctx, config)
        if result and result.contents then
          vim.lsp.util.open_floating_preview(result.contents, "markdown", { focus = false })
        end
      end)
    end
  end,
})
