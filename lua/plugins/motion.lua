-- Lua
return {
  {
    "abecodes/tabout.nvim",
    lazy = true,
    event = { "InsertEnter" },
    config = function(opts)
      require("tabout").setup(opts)
    end,
  },
}
