local event = "VimEnter"
if vim.fn.expand "%" == "" then event = "VeryLazy" end
return {
  {
    "williamboman/mason.nvim",
    event = event,
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function() require "plugins.config.lsp"() end,
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>ls", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {},
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
}
