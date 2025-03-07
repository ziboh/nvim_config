return {
  "sustech-data/wildfire.nvim",
  event = "User LazyFile",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("wildfire").setup({
      surrounds = {
        { "(", ")" },
        { "{", "}" },
        { "<", ">" },
        { "[", "]" },
      },
      filetype_exclude = { "qf", "outline" }, --keymaps will be unset in excluding filetypes
    })
  end,
}
