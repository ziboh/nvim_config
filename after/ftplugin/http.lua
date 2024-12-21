vim.keymap.set(
  "n",
  "<leader>rp",
  ":lua require('kulala').jump_prev()<CR>",
  { noremap = true, silent = true, buffer = 0, desc = "Prev Http" }
)
vim.keymap.set(
  "n",
  "<leader>rc",
  ":lua require('kulala').copy()<CR>",
  { noremap = true, silent = true, buffer = 0, desc = "Copy http" }
)
vim.keymap.set(
  "n",
  "<leader>rn",
  ":lua require('kulala').jump_next()<CR>",
  { noremap = true, silent = true, buffer = 0, desc = "Next http" }
)
vim.keymap.set(
  "n",
  "<leader>rr",
  ":lua require('kulala').run()<CR>",
  { noremap = true, silent = true, buffer = 0, desc = "Http Run" }
)
