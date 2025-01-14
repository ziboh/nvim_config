return {
  -- "linux-cultist/venv-selector.nvim",
  "ziboh/venv-selector.nvim",
  dependencies = {
    -- "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
  },
  ft = { "python" },
  opts = function()
    local opts = {}
    if not Utils.is_win() then
      opts = {
        settings = {
          search = {
            rye = {
              command = "fd -p -g '**/bin/python' ~/.rye/py", -- read up on the fd flags so it searches what you need
            },
          },
        },
      }
    end
    return opts
  end,
  config = function(_, opts)
    require("venv-selector").setup(opts)
  end,
  keys = {
    { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Python venv" },
  },
}
