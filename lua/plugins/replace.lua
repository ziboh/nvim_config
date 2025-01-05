return {
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>r/",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
      {
        "<leader>rw",
        function()
          local path = vim.fn.expand("%")
          local grug = require("grug-far")
          grug.open({
            transient = true,
            prefills = {
              paths = path,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace (Current File)",
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      if opts == nil then
        Utils.warn("which-key 为nil")
      end
      if not opts.disable then
        opts.disable = {}
      end
      opts.disable.ft = Utils.list_insert_unique(opts.disable.ft, { "grug-far" })
    end,
  },
}
