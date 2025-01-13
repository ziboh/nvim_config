return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    defaults = {},
    spec = {
      {
        mode = "i",
        { "<c-g>", group = "ai", icon = { icon = " ", color = "cyan" } },
      },
      {
        mode = { "n", "v" },
        { "<leader><tab>", group = "tab", icon = { icon = " ", color = "cyan" } },
        { "<leader>gh", group = "hunks" },
        { "<leader>gn", group = "neogit" },
        { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>a", group = "ai", icon = { icon = " ", color = "cyan" } },
        { "<c-g>", group = "ai", icon = { icon = " ", color = "cyan" } },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp", icon = { icon = " ", color = "cyan" } },
        { "<leader>f", group = "file/find" },
        { "<leader>d", group = "debug" },
        { "<leader>du", group = "debug-ui" },
        { "<leader>p", group = "package", icon = { icon = "󰏖 ", color = "cyan" } },
        { "<leader>r", group = "replace", icon = { icon = " ", color = "cyan" } },
        { "<leader>o", group = "task", icon = { icon = " ", color = "cyan" } },
        { "<leader>t", group = "terminal" },
        { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
        { "g", group = "goto" },
        {
          "<leader>b",
          group = "buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        { "]", group = "next" },
        { "[", group = "prev" },
        { "<leader>bs", desc = "Sort Buffer" },
      },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
  end,
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Keymaps (which-key)",
    },
    {
      "<c-w><space>",
      function()
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
  },
}
