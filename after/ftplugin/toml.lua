vim.keymap.set(
  "n",
  "<leader>lf",
  function()
    vim.lsp.buf.format {
      async = true,
    }
  end,
  { noremap = true, silent = true, buffer = 0, desc = "Formatting" }
)
