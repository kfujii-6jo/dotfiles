vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy.nvim bootstrap
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

require("lazy").setup({
  {
    "rmehri01/onenord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onenord").setup()
      vim.cmd.colorscheme("onenord")
    end,
  },
  {
    "romgrk/barbar.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      { "<leader>e", function() require("oil").open(vim.fn.getcwd()) end, desc = "Open oil at cwd" },
      { "<leader>E", function() require("oil").open_float(vim.fn.getcwd()) end, desc = "Open oil at cwd (float)" },
    },
    opts = {
      default_file_explorer = true,
      keymaps = {
        ["-"] = {
          callback = function()
            local oil = require("oil")
            local cwd = vim.fn.getcwd()
            local dir = oil.get_current_dir()
            if dir and vim.startswith(cwd, dir:sub(1, -2)) then
              return
            end
            oil.open()
          end,
          desc = "Open parent directory (restricted to cwd)",
        },
      },
    },
  },
})

local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.number = true
opt.mouse = "a"
opt.ignorecase = true
opt.smartcase = true
opt.wrap = false
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
opt.cursorline = true
opt.updatetime = 300

