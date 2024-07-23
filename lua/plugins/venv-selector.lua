return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python", --optional
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  lazy = true,
  branch = "regexp", -- This is the regexp branch, use this for the new version
  config = function()
    require("venv-selector").setup {
      -- settings = {
      --   search = {
      --     pyenv = {
      --       command = "fdfind --hidden -p -g '**/bin/python' ~/.pyenv/versions -I", -- read up on the fd flags so it searches what you need
      --     },
      --   },
      -- },
    }
  end,
  keys = {
    { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Python venv" },
  },
}
