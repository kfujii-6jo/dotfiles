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
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>r", group = "lsp" },
        { "<leader>c", group = "code" },
        { "<leader>z", group = "fold" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local parsers = {
        "lua", "vim", "vimdoc", "rust", "go", "python",
        "typescript", "tsx", "javascript", "json", "yaml",
        "markdown", "markdown_inline", "bash", "html", "css",
      }
      require("nvim-treesitter").install(parsers)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua", "rust", "go", "python", "typescript", "typescriptreact",
          "javascript", "javascriptreact", "json", "yaml", "markdown",
          "bash", "html", "css",
        },
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "VeryLazy",
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
    keys = {
      { "<leader>zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "<leader>zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "<leader>za", "za", desc = "Toggle fold" },
    },
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
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
      completion = {
        documentation = { auto_show = true },
        list = { selection = { preselect = true } },
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

-- LSP: buffer keymaps on attach (completion handled by blink.cmp)
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
    init_options = {
      preferences = {},
      tsserver = {
        logVerbosity = "off",
      },
    },
    settings = {
      typescript = {
        tsdk = "",
      },
      javascript = {},
    },
    on_new_config = function(config, root_dir)
      -- tsconfig.app.json があればそれを優先する（Vite プロジェクト対応）
      local app_tsconfig = root_dir .. "/tsconfig.app.json"
      if vim.fn.filereadable(app_tsconfig) == 1 then
        config.init_options = config.init_options or {}
        config.init_options.tsserver = config.init_options.tsserver or {}
        config.init_options.tsserver.configFile = app_tsconfig
      end
    end,
  },
}

for name, cfg in pairs(servers) do
  if vim.fn.executable(cfg.cmd[1]) == 1 then
    vim.lsp.config[name] = cfg
    vim.lsp.enable(name)
  end
end

