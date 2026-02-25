-- Plugin definitions
return {
  -- UI
  require("plugins.onenord"),
  require("plugins.lualine"),
  require("plugins.barbar"),

  -- Editor
  require("plugins.neo-tree"),
  require("plugins.fzf"),
  require("plugins.comment"),
  require("plugins.auto-pairs"),

  -- LSP
  require("plugins.mason"),
  require("plugins.lspconfig"),
  require("plugins.cmp"),

  -- Utilities
  require("plugins.which-key"),
  require("plugins.better-escape"),
  require("plugins.sidekick"),
}
