vim.keymap.set(
  "n",
  "]]",
  function() require("heirline-components.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
  { noremap = true, silent = true, buffer = 0, desc = "Next buffer" }
)
vim.keymap.set(
  "n",
  "[[",
  function() require("heirline-components.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
  { noremap = true, silent = true, buffer = 0, desc = "Previous buffer" }
)
vim.keymap.set(
  "n",
  "<C-CR>",
  "<CMD>GpChatResponse<CR>",
  { noremap = true, silent = true, buffer = 0, desc = "Send GpChat" }
)
