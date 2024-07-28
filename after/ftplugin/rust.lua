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

vim.keymap.set(
  "n",
  "<leader>rt",
  "<cmd> RustLsp testables<CR>",
  { noremap = true, silent = true, buffer = 0, desc = "Rust Test" }
)

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
vim.keymap.set("n", "<leader>ra", function()
  local input_opts = { prompt = "Rust run with arguments: ", default = "" }
  vim.ui.input(input_opts, function(content)
    local cmd = "RustLsp run " .. content
    vim.cmd(cmd)
  end)
end, { noremap = true, silent = true, buffer = 0, desc = "Rust Run with arguments" })

vim.keymap.set("n", "<leader>rR", function()
  local termopen = require "rustaceanvim.executors.termopen"
  termopen.execute_command("cargo run", {})
end, { buffer = 0, noremap = true, silent = true, desc = "Cargo run" })
