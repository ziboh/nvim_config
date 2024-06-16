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
  {
    "folke/zen-mode.nvim",
    keys = { { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zenmode" } },
  },
  {
    "uga-rosa/ccc.nvim",
    event = "VeryLazy",
    cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable", "CccHighlighterToggle" },
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
      },
    },
    config = function(_, opts)
      require("ccc").setup(opts)
      if opts.highlighter and opts.highlighter.auto_enable then vim.cmd.CccHighlighterEnable() end
    end,
  },
}
