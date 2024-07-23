return {
  "ziboh/fittencode.nvim",
  config = function()
    require("fittencode").setup {
      completion_mode = "source",
    }
    if not vim.g.enabled_fittencode then require("fittencode").enable_completions { enable = false } end
  end,
  lazy = true,
}
