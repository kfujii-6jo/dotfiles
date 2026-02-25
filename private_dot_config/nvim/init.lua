vim.g.mapleader = " "

-- lazy.nvimのブートストラップ（自動インストール）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load basic options first
require("config.options")

-- プラグイン設定を読み込み
require("lazy").setup("plugins")

-- Load keymaps
require("config.keymaps")

-- Load autocmds
require("config.autocmds")
