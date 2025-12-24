-- Keymaps configuration
-- General keymaps (plugin-specific keymaps are in their respective plugin files)

local map = vim.keymap.set

-- 連続でタブを挿入できるようにする
map('v', '>', '>gv')
map('v', '<', '<gv')

-- ビジュアルモードでペースト後もヤンク内容を保持
map('x', 'p', '"_dP')

-- 画面間の移動（ターミナルモードからでも直接ウィンドウを移動）
-- map("t", "<C-h>", "<C-\\><C-n><C-w>h")
-- map("t", "<C-l>", "<C-\\><C-n><C-w>l")
-- map("t", "<C-k>", "<C-\\><C-n><C-w>l")
-- map("t", "<C-j>", "<C-\\><C-n><C-w>j")
