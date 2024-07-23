return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    icons = {
      group = vim.g.icons_enabled ~= false and "" or "+",
      separator = "-",
    },
    spec = {
      { "<leader>,", "<CMD>WhichKey<CR>", desc = "Which key", icon = "󱕴" },
      { "<leader>e", icon = "" },
    },
  },
  config = function(_, opts)
    require("which-key").setup(opts)
    require("utils").which_key_register()
  end,
}
