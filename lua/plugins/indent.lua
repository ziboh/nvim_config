return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  {
    "nmac427/guess-indent.nvim",
    enabled = true,
    config = function() require("guess-indent").setup {} end,
  },
}
