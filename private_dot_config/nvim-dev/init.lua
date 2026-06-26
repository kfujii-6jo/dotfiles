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
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({})
      vim.cmd.colorscheme("github_dark_dimmed")
    end,
  },
  {
    "romgrk/barbar.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = true,
      tabpages = true,
      clickable = true,
    },
    keys = {
      { "<S-h>", "<Cmd>BufferPrevious<CR>", desc = "BufferPrevious" },
      { "<S-l>", "<Cmd>BufferNext<CR>", desc = "BufferNext" },
      { "<leader>q", "<Cmd>BufferClose<CR>", desc = "BufferClose" },
      { "<leader>Q", "<Cmd>BufferClose!<CR>", desc = "BufferClose!" },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
    },
    keys = {
      { "<leader>e", function() require("snacks").explorer() end, desc = "File explorer" },
      { "<leader>ff", function() require("snacks").picker.files() end, desc = "Find files" },
      { "<leader>fg", function() require("snacks").picker.grep() end, desc = "Live grep" },
      { "<leader>/", function() require("snacks").picker.lines() end, desc = "Search buffer lines" },
      { "<leader>gg", function() require("snacks").lazygit() end, desc = "Lazygit" },
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

