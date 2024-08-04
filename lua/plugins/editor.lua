return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function(opts)
      local npairs = require "nvim-autopairs"
      npairs.setup(opts)
      local utils = require "utils"
      utils.on_load(
        "nvim-cmp",
        function()
          require("cmp").event:on(
            "confirm_done",
            require("nvim-autopairs.completion.cmp").on_confirm_done { tex = false }
          )
        end
      )
    end,
  },
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
  {
    "mistweaverco/kulala.nvim",
    init = function()
      vim.filetype.add {
        extension = {
          ["http"] = "http",
        },
      }
    end,
    config = function()
      -- Setup is required, even if you don't pass any options
      require("kulala").setup {
        -- default_view, body or headers
        default_view = "body",
        -- dev, test, prod, can be anything
        -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
        default_env = "dev",
        -- enable/disable debug mode
        debug = false,
        -- default formatters for different content types
        formatters = {
          json = { "jq", "." },
          xml = { "xmllint", "--format", "-" },
          html = { "xmllint", "--format", "--html", "-" },
        },
        -- default icons
        icons = {
          inlay = {
            loading = "⏳",
            done = "✅",
            error = "❌",
          },
          lualine = "🐼",
        },
        -- additional cURL options
        -- see: https://curl.se/docs/manpage.html
        additional_curl_options = {},
      }
    end,
  },
}
