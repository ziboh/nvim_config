return {
  "stevearc/aerial.nvim",
  config = function()
    require("aerial").setup {
      layout = {
        max_width = { 100, 0.4 },
        width = nil,
        min_width = 30,
      },
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    }
  end,
  keys = {
    { "<leader>ls", "<cmd>AerialToggle!<cr>", desc = "Aerial (Symbols)" },
  },
}
