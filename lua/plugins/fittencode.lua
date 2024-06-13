return {
  "luozhiya/fittencode.nvim",
  config = function()
    require("fittencode").setup {
      completion_mode = "source",
    }
  end,
}
