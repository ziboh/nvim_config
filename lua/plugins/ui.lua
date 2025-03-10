return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config'), confirm = { 'tcd_cwd', 'jump' } })",
            },
            {
              icon = " ",
              key = "p",
              desc = "Projects",
              action = ":lua Snacks.picker.projects()",
            },
            { icon = " ", key = "l", desc = "Leet", action = "<cmd>Leet<cr>" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = {},
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    init = function()
      vim.opt.termguicolors = true
    end,
    opts = {
      -- 设置样式：storm, night, day, moon
      style = "moon",
      -- 启用终端颜色
      terminal_colors = false,
      -- 使终端背景透明
      transparent = false, -- 如果想要透明背景，设置为 true
    },
  },
  {
    "echasnovski/mini.hipatterns",
    version = false,
    event = "User LazyFile",
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },
}
