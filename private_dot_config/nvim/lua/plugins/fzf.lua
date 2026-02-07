-- fzf-lua (fuzzy finder) plugin
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          default = "bat",
          border = "border",
          wrap = "nowrap",
          hidden = "nohidden",
          vertical = "down:45%",
          horizontal = "right:60%",
        },
      },
      files = {
        cwd_prompt = false,
        path_shorten = false,
      },
      keymap = {
        builtin = {
          ["<F1>"] = "toggle-help",
          ["<F2>"] = "toggle-fullscreen",
          ["<F3>"] = "toggle-preview-wrap",
          ["<F4>"] = "toggle-preview",
        },
        fzf = {
          ["ctrl-u"] = "unix-line-discard",
          ["ctrl-f"] = "half-page-down",
          ["ctrl-b"] = "half-page-up",
          ["ctrl-a"] = "beginning-of-line",
          ["ctrl-e"] = "end-of-line",
          ["alt-a"] = "toggle-all",
          ["f3"] = "toggle-preview-wrap",
          ["f4"] = "toggle-preview",
        },
      },
    })
  end,
  keys = {
    -- File operations
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>FzfLua grep_project<cr>", desc = "Live grep" },
    { "<leader>fG", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find buffers" },
    { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
    -- Help and commands
    { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help tags" },
    { "<leader>fc", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
    -- Diagnostics
    { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document diagnostics" },
    { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace diagnostics" },
    -- LSP
    { "<leader>fr", "<cmd>FzfLua lsp_references<cr>", desc = "LSP references" },
    { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document symbols" },
    { "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
    { "<leader>fa", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Code actions" },
    -- Lists
    { "<leader>fq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix list" },
    { "<leader>fl", "<cmd>FzfLua loclist<cr>", desc = "Location list" },
    -- Search variations
    { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Grep word under cursor" },
    { "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", desc = "Grep WORD under cursor" },
    { "<leader>fv", "<cmd>FzfLua grep_visual<cr>", desc = "Grep visual selection", mode = "v" },
    -- Tags
    { "<leader>ft", "<cmd>FzfLua tags<cr>", desc = "Tags" },
    { "<leader>fT", "<cmd>FzfLua btags<cr>", desc = "Buffer tags" },
    -- Marks and jumps
    { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "Marks" },
    { "<leader>fj", "<cmd>FzfLua jumps<cr>", desc = "Jumps" },
    -- History
    { "<leader>f/", "<cmd>FzfLua search_history<cr>", desc = "Search history" },
    { "<leader>f:", "<cmd>FzfLua command_history<cr>", desc = "Command history" },
    -- Registers
    { '<leader>f"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
    -- Git
    { "<leader>fgc", "<cmd>FzfLua git_commits<cr>", desc = "Git commits" },
    { "<leader>fgb", "<cmd>FzfLua git_branches<cr>", desc = "Git branches" },
    { "<leader>fgs", "<cmd>FzfLua git_status<cr>", desc = "Git status" },
  },
}
