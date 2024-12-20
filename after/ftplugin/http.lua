vim.api.nvim_set_keymap(
  "n",
  "<leader>hp",
  ":lua require('kulala').jump_prev()<CR>",
  { noremap = true, silent = true, buffer = 0, desc = "Prev Http" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>hc",
  ":lua require('kulala').copy()<CR>",
  { noremap = true, silent = true, buffer = 0, desc = "Copy http" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>hn",
  ":lua require('kulala').jump_next()<CR>",
  { noremap = true, silent = true, buffer = 0, desc = "Next http" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>hr",
  ":lua require('kulala').run()<CR>",
  { noremap = true, silent = true, buffer = 0, desc = "Http Run" }
)
