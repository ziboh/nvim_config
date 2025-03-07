return {
  {
    "luozhiya/fittencode.nvim",
    event = "InsertEnter",
    init = function()
      if vim.g.rime_enabled and vim.g.fittencode_enabled then
        vim.notify("Please disable Rime first", { title = "Fittencode", timeout = 3000 })
        vim.g.fittencode_enabled = false
      end
    end,
    keys = {
      {
        "<leader>af",
        function()
          Utils.toggle.fittencode(false)
        end,
        desc = "Fittencode: Toggle",
      },
    },
    config = function()
      require("fittencode").setup({
        completion_mode = "source",
        source_completion = {
          enbaled = true,
          engine = "cmp",
          trigger_chars = {},
        },
      })
    end,
    lazy = true,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "luozhiya/fittencode.nvim" },
    opts = {
      sources = {
        default = { "fittencode" },
        providers = {
          fittencode = {
            name = "fittencode",
            enabled = function()
              return vim.g.fittencode_enabled and not vim.g.rime_enabled
            end,
            module = "fittencode.sources.blink",
            score_offset = 100,
            async = true,
            kind = "Fitten",
          },
        },
      },
    },
  },
}
