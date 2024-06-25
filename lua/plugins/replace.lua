return {
  {
    "MagicDuck/grug-far.nvim",
    config = function() require("grug-far").setup {} end,
    keys = {
      {
        "<leader>r/",
        function() require("grug-far").grug_far { prefills = { flags = vim.fn.expand "%" } } end,
        desc = "replace  current file",
      },
      {
        "<leader>rw",
        function() require("grug-far").grug_far { prefills = { search = vim.fn.expand "<cword>" } } end,
        desc = "search word",
      },
    },
  },
}
