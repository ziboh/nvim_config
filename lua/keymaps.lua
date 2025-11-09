local utils = require("utils")
local has = utils.has
local maps = require("utils").get_mappings_template()
local safe_map = utils.safe_keymap_set
-- Normal mode --
-----------------
vim.keymap.set("n", "<C-n>", "5j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-p>", "5k", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>", "<NOP>", { noremap = true, silent = true })
vim.keymap.set("n", "q", "<NOP>", { noremap = true, silent = true })
vim.keymap.set("n", "J", "<NOP>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>", "<NOP>", { noremap = true, silent = true })
vim.keymap.set("n", "<tab>", "w", { noremap = true, silent = true })

vim.keymap.set("n", "L", "$", { noremap = true, silent = true, desc = "Move to end of line" })
vim.keymap.set("n", "H", "^", { noremap = true, silent = true, desc = "Move to first non-blank character" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Decrease window height" })
vim.keymap.set("n", "M", "J", { noremap = true, silent = true, desc = "Join the current line with the next line" })

vim.keymap.set("n", "<leader>/", "gcc", { remap = true, silent = true, desc = "Toggle Comment linewise" })
vim.keymap.set("v", "<leader>/", "gc", { remap = true, desc = "Toggle Comment lineise" })

-----------------
-- Visual mode --
-----------
vim.keymap.set("v", "<C-n>", "5j", { noremap = true, silent = true })
vim.keymap.set("v", "<C-p>", "5k", { noremap = true, silent = true })
vim.keymap.set("v", "L", "$h", { noremap = true, silent = true, desc = "Move to end of line" })
vim.keymap.set("v", "H", "^", { noremap = true, silent = true, desc = "Move to first non-blank character" })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true, desc = "Unindent line" })
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true, desc = "Unindent line" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv-gv", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv-gv", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set("v", "J", "<NOP>", { noremap = true, silent = true })
vim.keymap.set("v", "J", "j", { noremap = true, silent = true })
vim.keymap.set("v", "K", "k", { noremap = true, silent = true })

-----------------
-- Insert mode --
-----------------
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true, desc = "Move line down" })

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
vim.keymap.set("o", "H", "^", { noremap = true, silent = true, desc = "Move to first non-blank character" })
vim.keymap.set("o", "L", "$", { noremap = true, silent = true, desc = "Move to end of line" })

-- tabs
safe_map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
safe_map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
safe_map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
safe_map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
safe_map("n", "<leader><tab><tab>", "<cmd>tabnext<cr>", { desc = "New Tab" })
safe_map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
safe_map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
safe_map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- better up/down
safe_map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
safe_map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
safe_map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
safe_map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Terminal Mappings
safe_map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
safe_map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
safe_map("t", "<C-t>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- quit
safe_map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
safe_map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit All" })

-- highlights under cursor
safe_map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
safe_map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

safe_map("i", "<C-n>", function()
  require("blink.cmp").show()
end, { desc = "Open Cmp menu" })
safe_map("i", "<C-p>", function()
  require("blink.cmp").show()
end, { desc = "Open Cmp menu" })

-- floating terminal
safe_map("n", "<leader>tm", function()
  Snacks.terminal("btm")
end, { desc = "Open Bottom" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
safe_map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
safe_map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
safe_map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
safe_map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
safe_map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
safe_map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
safe_map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
safe_map("n", "<leader>ld", function()
  vim.diagnostic.open_float()
end, { desc = "Hover diagnostics" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
safe_map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
safe_map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
safe_map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
safe_map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
safe_map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
safe_map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- save file
safe_map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
-- buffers/tabs [buffers ]--------------------------------------------------
maps.n["<leader>c"] = {
  function()
    utils.close()
  end,
  desc = "Close buffer",
}
maps.n["<leader>C"] = {
  function()
    utils.close(0, true)
  end,
  desc = "Force close buffer",
}

-- smart-splits.nivm
if not has("smart-splits.nvim") then
  maps.n["<C-h>"] = { "<C-w>h", desc = "Move to left split" }
  maps.n["<C-j>"] = { "<C-w>j", desc = "Move to below split" }
  maps.n["<C-k>"] = { "<C-w>k", desc = "Move to above split" }
  maps.n["<C-l>"] = { "<C-w>l", desc = "Move to right split" }
  maps.n["<C-Up>"] = { "<cmd>resize -2<CR>", desc = "Resize split up" }
  maps.n["<C-Down>"] = { "<cmd>resize +2<CR>", desc = "Resize split down" }
  maps.n["<C-Left>"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" }
  maps.n["<C-Right>"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" }
end

maps.n["<leader>wp"] = {
  function()
    local winid = require("window-picker").pick_window()
    if winid then
      vim.api.nvim_set_current_win(winid)
    end
  end,
  desc = "Pick window",
}
maps.n["<leader>ww"] = { "<c-w>w", desc = "other window" }
maps.n["<leader>wd"] = { "<c-w>c", desc = "delete window" }
maps.n["<leader>wl"] = { "<c-w>v", desc = "spite window right" }
maps.n["<leader>wj"] = { "<c-w>s", desc = "splite window below" }
maps.n["<leader>wo"] = { "<c-w>o", desc = "only window" }
maps.n["<leader>wx"] = { "<c-w>x", desc = "Swap current with next" }
maps.n["<leader>wf"] = { "<c-w>p", desc = "switch window" }
maps.n["|"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" }

-- For package
maps.n["<leader>pl"] = { "<cmd>Lazy<CR>", desc = "Lazy" }
maps.n["<leader>pm"] = { "<cmd>Mason<CR>", desc = "Mason" }

-- Dap
-- modified function keys found with `showkey -a` in the terminal to get key code
-- run `nvim -V3log +quit` and search through the "Terminal info" in the `log` file for the correct keyname
maps.n["<F5>"] = {
  function()
    require("dap").continue()
  end,
  desc = "Debugger: Start",
}
maps.n["<F17>"] = {
  function()
    require("dap").terminate()
  end,
  desc = "Debugger: Stop",
} -- Shift+F5
maps.n["<F29>"] = {
  function()
    require("dap").restart_frame()
  end,
  desc = "Debugger: Restart",
} -- Control+F5
maps.n["<F6>"] = {
  function()
    require("dap").pause()
  end,
  desc = "Debugger: Pause",
}
maps.n["<F9>"] = {
  function()
    require("dap").toggle_breakpoint()
  end,
  desc = "Debugger: Toggle Breakpoint",
}
maps.n["<F10>"] = {
  function()
    require("dap").step_over()
  end,
  desc = "Debugger: Step Over",
}
maps.n["<F11>"] = {
  function()
    require("dap").step_into()
  end,
  desc = "Debugger: Step Into",
}
maps.n["<F23>"] = {
  function()
    require("dap").step_out()
  end,
  desc = "Debugger: Step Out",
} -- Shift+F11
maps.n["<Leader>db"] = {
  function()
    require("dap").toggle_breakpoint()
  end,
  desc = "Toggle Breakpoint (F9)",
}
maps.n["<Leader>dB"] = {
  function()
    require("dap").clear_breakpoints()
  end,
  desc = "Clear Breakpoints",
}
maps.n["<Leader>dc"] = {
  function()
    require("dap").continue()
  end,
  desc = "Start/Continue (F5)",
}
maps.n["<Leader>di"] = {
  function()
    require("dap").step_into()
  end,
  desc = "Step Into (F11)",
}
maps.n["<Leader>do"] = {
  function()
    require("dap").step_over()
  end,
  desc = "Step Over (F10)",
}
maps.n["<Leader>dO"] = {
  function()
    require("dap").step_out()
  end,
  desc = "Step Out (S-F11)",
}
maps.n["<Leader>dq"] = {
  function()
    require("dap").close()
  end,
  desc = "Close Session",
}
maps.n["<Leader>dQ"] = {
  function()
    require("dap").terminate()
  end,
  desc = "Terminate Session (S-F5)",
}
maps.n["<Leader>dp"] = {
  function()
    require("dap").pause()
  end,
  desc = "Pause (F6)",
}
maps.n["<Leader>dr"] = {
  function()
    require("dap").restart_frame()
  end,
  desc = "Restart (C-F5)",
}
maps.n["<Leader>dR"] = {
  function()
    require("dap").repl.toggle()
  end,
  desc = "Toggle REPL",
}
maps.n["<Leader>ds"] = {
  function()
    require("dap").run_to_cursor()
  end,
  desc = "Run To Cursor",
}
maps.n["<F21>"] = { -- Shift+F9
  function()
    vim.ui.input({ prompt = "Condition: " }, function(condition)
      if condition then
        require("dap").set_breakpoint(condition)
      end
    end)
  end,
  desc = "Debugger: Conditional Breakpoint",
}
maps.n["<Leader>dC"] = {
  function()
    vim.ui.input({ prompt = "Condition: " }, function(condition)
      if condition then
        require("dap").set_breakpoint(condition)
      end
    end)
  end,
  desc = "Conditional Breakpoint (S-F9)",
}
maps.n["<Leader>duc"] = {
  function()
    require("dapui").close()
  end,
  desc = "Close Dap UI",
}
maps.n["<Leader>duo"] = {
  function()
    require("dapui").open()
  end,
  desc = "Open Dap UI",
}

safe_map("i", "<C-.>", function()
  Utils.notify("C-.")
end, { desc = "<C-.>", expr = true, silent = true })

-- commenting
safe_map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
safe_map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })


require("utils").set_mappings(maps)
