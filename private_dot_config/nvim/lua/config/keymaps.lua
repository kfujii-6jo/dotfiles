-- Keymaps configuration
-- General keymaps (plugin-specific keymaps are in their respective plugin files)

local map = vim.keymap.set

-- 連続でタブを挿入できるようにする
map("v", ">", ">gv")
map("v", "<", "<gv")

-- ビジュアルモードでペースト後もヤンク内容を保持
map("x", "p", '"_dP')

-- :q を無効化（:qa を使用させる）
-- 特定のバッファでは :q を許可
local allowed_quit_patterns = { "^Diffview", "^neo%-tree", "^fzf" }

vim.api.nvim_create_user_command("Q", function(opts)
  local ft = vim.bo.filetype
  for _, pattern in ipairs(allowed_quit_patterns) do
    if ft:match(pattern) then
      vim.cmd("q" .. (opts.bang and "!" or ""))
      return
    end
  end

  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #buffers > 1 then
    vim.notify("Use :qa to quit", vim.log.levels.WARN)
  else
    vim.cmd("q" .. (opts.bang and "!" or ""))
  end
end, { bang = true })

vim.cmd([[cabbrev <expr> q getcmdtype() == ':' && getcmdline() ==# 'q' ? 'Q' : 'q']])
vim.cmd([[cabbrev <expr> q! getcmdtype() == ':' && getcmdline() ==# 'q!' ? 'Q!' : 'q!']])
