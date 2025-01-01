return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  event = "VeryLazy",
  config = function()
    require("window-picker").setup({
      show_prompt = false,
      picker_config = { statusline_winbar_picker = { use_winbar = "smart" } },
      filter_rules = {
        autoselect_one = false,
        bo = {
          buftype = {},
        },
      },
    })
  end,
}
