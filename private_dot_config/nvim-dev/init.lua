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
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
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

-- Native completion (0.12+)
opt.autocomplete = true
opt.completeopt = "menu,menuone,noselect,popup,fuzzy"
opt.pumheight = 12

-- Completion menu keymaps: confirm a selected item, otherwise normal key.
vim.keymap.set("i", "<CR>", function()
  return vim.fn.complete_info({ "selected" }).selected ~= -1 and "<C-y>" or "<CR>"
end, { expr = true })
vim.keymap.set("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })
vim.keymap.set("i", "<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true })

-- LSP: buffer keymaps + native completion on attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local o = { buffer = args.buf, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, o)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, o)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, o)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, o)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, o)
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, o)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

-- System LSP servers: enabled only when the binary is on PATH, so installing
-- more servers (brew/mise/go install) lights them up automatically.
local servers = {
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", ".git" },
  },
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
  },
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork" },
    root_markers = { "go.mod", ".git" },
  },
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", ".git" },
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", ".git" },
  },
}

for name, cfg in pairs(servers) do
  if vim.fn.executable(cfg.cmd[1]) == 1 then
    vim.lsp.config[name] = cfg
    vim.lsp.enable(name)
  end
end

