-- Lua
return {
  {
    "abecodes/tabout.nvim",
    lazy = true,
    event = "VeryLazy",
    config = function(opts) require("tabout").setup(opts) end,
    dependencies = { -- These are optional
      "nvim-treesitter/nvim-treesitter",
      "L3MON4D3/LuaSnip",
      "hrsh7th/nvim-cmp",
      "ziboh/fittencode.nvim",
    },
  },
}
