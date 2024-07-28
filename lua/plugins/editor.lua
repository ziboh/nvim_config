return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    config = function() require("tiny-inline-diagnostic").setup() end,
  },
  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup {
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
      }
    end,
  },
  {
    "adelarsq/image_preview.nvim",
    event = "VeryLazy",
    config = function() require("image_preview").setup() end,
  },
  {
    "echasnovski/mini.splitjoin",
    version = "*",
    -- No need to copy this inside `setup()`. Will be used automatically.
    opts = {
      mappings = { toggle = "gS", split = "", join = "" },
    },
  },
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    opts = {
      keymaps = {
        ["<C-k>"] = "actions.select_vsplit",
        ["<C-s>"] = false,
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
