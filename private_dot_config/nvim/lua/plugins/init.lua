-- Plugin definitions
return {
  -- UI
  require("plugins.cursor-dark"),
  require("plugins.lualine"),
  require("plugins.barbar"),

  -- Editor
  require("plugins.oil"),
  require("plugins.fzf"),
  require("plugins.comment"),
  require("plugins.auto-pairs"),
  require("plugins.autotag"),
  require("plugins.treesitter"),

  -- LSP
  require("plugins.mason"),
  require("plugins.lspconfig"),
  require("plugins.cmp"),

  -- Utilities
  require("plugins.which-key"),
  require("plugins.better-escape"),
  require("plugins.sidekick"),
  require("plugins.trouble"),
}
