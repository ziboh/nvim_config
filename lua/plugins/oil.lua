return {
  "stevearc/oil.nvim",
  opts = {
    keymaps = {
      ["<C-k>"] = "actions.select_vsplit",
      ["<C-s>"] = false,
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
