return {
  "nvim-neotest/neotest",
  lazy = true,
  config = function()
    require("neotest").setup({
      adapters = {
        require("rustaceanvim.neotest"),
      },
    })
  end,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
