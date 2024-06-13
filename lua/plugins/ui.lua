return {
  {
    "AstroNvim/astrotheme",
    config = function()
      require("astrotheme").setup {
        opts = {
          palette = "astrodark",
          plugins = { ["dashboard-nvim"] = true },
        },
      }
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
  },
  {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_background = "hard"
      vim.cmd.colorscheme "everforest"
      vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#9DA9A0" })
    end,
  },
}
