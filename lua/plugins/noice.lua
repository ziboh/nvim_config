return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    notify = {
      enabled = true,
      view = "notify",
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
      inc_rename = true,
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
    -- local notify = require "notify"
    -- vim.notify = function(msg, level, opts)
    --   if string.find(msg, "Invalid offset") then return end
    --   notify(msg, level, opts)
    -- end
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  keys = {
    {
      "<c-f>",
      function()
        if not require("noice.lsp").scroll(-4) then return "<c-f>" end
      end,
      silent = true,
      expr = true,
      desc = "Scroll Backward",
      mode = { "i", "n", "s" },
    },
    {
      "<c-b>",
      function()
        if not require("noice.lsp").scroll(4) then return "<c-b>" end
      end,
      silent = true,
      expr = true,
      desc = "Scroll Forward",
      mode = { "i", "n", "s" },
    },
  },
}
