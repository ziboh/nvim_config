return {
  "sustech-data/wildfire.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("wildfire").setup({
      surrounds = {
        { "(", ")" },
        { "{", "}" },
        { "<", ">" },
        { "[", "]" },
      },
      filetype_exclude = { "qf" }, --keymaps will be unset in excluding filetypes
    })
  end,
}
