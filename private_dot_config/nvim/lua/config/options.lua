-- Basic Neovim options
local opt = vim.opt
local g = vim.g

-- Set leader key to space
g.mapleader = " "
g.maplocalleader = " "
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Basic settings
opt.clipboard = "unnamedplus"
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.mouse = "a" -- Enable mouse support
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Smart case search
opt.wrap = false -- Don't wrap lines
opt.expandtab = true -- Use spaces instead of tabs
opt.tabstop = 2 -- Tab width
opt.shiftwidth = 2 -- Shift width
opt.autoindent = true -- Auto indent
opt.cursorline = true -- Highlight current line
