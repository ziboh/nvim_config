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
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<leader>ri",
  "<cmd>lua require('kulala').from_curl()<cr>",
  { noremap = true, silent = true, desc = "Paste curl from clipboard as http request" }
)
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<leader>ro",
  "<cmd>lua require('kulala').copy()<cr>",
  { noremap = true, silent = true, desc = "Copy the current request as a curl command" }
)
