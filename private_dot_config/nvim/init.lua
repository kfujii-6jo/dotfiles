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
        { "<leader>c", group = "code/format" },
        { "<leader>z", group = "fold" },
        { "<leader>a", group = "ai" },
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
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
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
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
        go = { "gofmt" },
        python = { "ruff_format" },
        javascript = { "biome", "prettier", stop_after_first = true },
        typescript = { "biome", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettier", stop_after_first = true },
        typescriptreact = { "biome", "prettier", stop_after_first = true },
        json = { "biome", "prettier", stop_after_first = true },
      },
      formatters = {
        biome = { require_cwd = true },
        prettier = { require_cwd = true },
        ruff_format = { require_cwd = true },
      },
      format_on_save = false,
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
      { "<leader>fd", function() require("snacks").picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>fr", function() require("snacks").picker.lsp_references() end, desc = "LSP references" },
    },
  },
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          default = "claude",
          backend = "tmux",
          enabled = true,
        },
      },
    },
    keys = {
      { "<tab>", function()
        if not require("sidekick").nes_jump_or_apply() then return "<Tab>" end
      end, expr = true, desc = "Goto/Apply Next Edit Suggestion" },
      { "<c-.>", function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle", mode = { "n", "t", "i", "x" } },
      { "<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Toggle Claude" },
      { "<leader>aa", function() require("sidekick.cli").toggle() end, desc = "Toggle CLI" },
      { "<leader>as", function() require("sidekick.cli").select() end, desc = "Select CLI" },
      { "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, mode = { "x", "n" }, desc = "Send This" },
      { "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, mode = { "x" }, desc = "Send Selection" },
      { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, desc = "Send File" },
      { "<leader>ap", function() require("sidekick.cli").prompt() end, mode = { "n", "x" }, desc = "Prompt" },
      { "<leader>ad", function() require("sidekick.cli").close() end, desc = "Detach CLI" },
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

-- System LSP servers: enabled only when the binary is on PATH
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
