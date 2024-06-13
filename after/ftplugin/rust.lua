vim.keymap.set(
  "n",
  "<leader>rd",
  "<cmd>RustLsp debug<CR>",
  { noremap = true, silent = true, buffer = 0, desc = "Rust Debug" }
)

vim.keymap.set(
  "n",
  "<leader>rr",
  "<cmd>RustLsp run<CR>",
  { noremap = true, silent = true, buffer = 0, desc = "Rust Run" }
)
