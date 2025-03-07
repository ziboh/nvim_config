return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = {
      "SupermavenUseFree",
      "SupermavenUsePro",
    },
    keys = {
      {
        "<leader>as",
        function()
          Utils.toggle.supermaven(false)
        end,
        desc = "Supermaven: Toggle",
      },
    },
    opts = {
      keymaps = {
        accept_suggestion = nil, -- handled by nvim-cmp / blink.cmp
      },
      disable_inline_completion = vim.g.ai_cmp,
      ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
    },
  },
  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "Starting Supermaven" },
              { find = "Supermaven Free Tier" },
            },
          },
          view = "mini",
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "supermaven-nvim", "saghen/blink.compat" },
    opts = {
      sources = {
        compat = { "supermaven" },
        providers = {
          supermaven = {
            enabled = function()
              return vim.g.supermaven_enabled and not vim.g.rime_enabled
            end,
            kind = "Supermaven",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
