-- Comment plugin
return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup()
  end,
}
