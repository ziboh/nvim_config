return {
  -- "linux-cultist/venv-selector.nvim",
  dir = "~/projects/venv-selector.nvim",
  dependencies = {
    -- "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
  },
  ft = { "python" },
  branch = "regexp", -- This is the regexp branch, use this for the new version
  config = function()
    require("venv-selector").setup({
      settings = {
        search = {
          pyenv = {
            command = "fd -p -g '**/bin/python' ~/.rye/py", -- read up on the fd flags so it searches what you need
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Python venv" },
  },
}
