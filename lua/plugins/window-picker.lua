return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  event = "VeryLazy",
  version = "2.*",
  config = function()
    require("window-picker").setup {
      show_prompt = false,
      filter_rules = {
        autoselect_one = false,
        bo = {
          buftype = {},
        },
      },
    }
  end,
}
