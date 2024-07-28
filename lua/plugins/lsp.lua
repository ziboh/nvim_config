return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
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
}
