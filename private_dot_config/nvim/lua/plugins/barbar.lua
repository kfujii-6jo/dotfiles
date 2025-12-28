return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',     -- git統合（オプション）
    'nvim-tree/nvim-web-devicons', -- アイコン（オプション）
  },
  event = "VeryLazy",  -- 起動時にロード
  init = function() vim.g.barbar_auto_setup = false end,
  opts = {
    animation = true,
    tabpages = true,
    clickable = true,
  },
  keys = {
    { '<leader>h', '<Cmd>BufferPrevious<CR>', desc = 'BufferPrevious' },
    { '<leader>l', '<Cmd>BufferNext<CR>', desc = 'BufferNext' },
    { '<leader>q', '<Cmd>BufferClose<CR>', desc = 'BufferClose' },
    { '<leader>Q', '<Cmd>BufferClose!<CR>', desc = 'BufferClose' },
  },
}
