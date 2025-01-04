local utils = require("utils")
local has = utils.has
local maps = require("utils").get_mappings_template()
local toggle = require("utils.toggle")
local safe_map = utils.safe_keymap_set
-- Normal mode --
-----------------
vim.keymap.set("n", "<C-n>", "5j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-p>", "5k", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>", "<NOP>", { noremap = true, silent = true })
vim.keymap.set("n", "q", "<NOP>", { noremap = true, silent = true })
vim.keymap.set("n", "J", "<NOP>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>", "<NOP>", { noremap = true, silent = true })
vim.keymap.set("n", "<c-s>", "<cmd>w<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>q", "<cmd>q<cr>", { noremap = true, silent = true, desc = "quit" })
vim.keymap.set("n", "<tab>", "w", { noremap = true, silent = true })

vim.keymap.set("n", "L", "$", { noremap = true, silent = true, desc = "Move to end of line" })
vim.keymap.set("n", "H", "^", { noremap = true, silent = true, desc = "Move to first non-blank character" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Decrease window height" })
vim.keymap.set("n", "M", "J", { noremap = true, silent = true, desc = "Join the current line with the next line" })

vim.keymap.set("t", "<C-_>", [[<C-\><C-n>]], {})
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, silent = true, desc = "Toggle Comment linewise" })
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, silent = true, desc = "Toggle Comment linewise" })
vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Toggle Comment lineise" })
vim.keymap.set("v", "<leader>/", "gc", { remap = true, desc = "Toggle Comment lineise" })

-----------------
-- Visual mode --
-----------------
vim.keymap.set("v", "<C-n>", "5j", { noremap = true, silent = true })
vim.keymap.set("v", "<C-p>", "5k", { noremap = true, silent = true })
vim.keymap.set("v", "L", "$h", { noremap = true, silent = true, desc = "Move to end of line" })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true, desc = "Unindent line" })
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true, desc = "Unindent line" })
vim.keymap.set("v", "H", "^", { noremap = true, silent = true, desc = "Move to first non-blank character" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv-gv", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv-gv", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set("v", "J", "<NOP>", { noremap = true, silent = true })
vim.keymap.set("v", "J", "j", { noremap = true, silent = true })
vim.keymap.set("v", "K", "k", { noremap = true, silent = true })

-----------------
-- Insert mode --
-----------------
vim.keymap.set("i", "<c-s>", "<esc><cmd>w<cr>a", { noremap = true, silent = true })
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
safe_map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
safe_map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
safe_map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
safe_map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

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

maps.n["<leader>ba"] = {
  function()
    vim.cmd("wa")
  end,
  desc = "Write all changed buffers",
}
maps.n["]]"] = {
  function()
    require("heirline-components.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
  end,
  desc = "Next buffer",
}
maps.n["[["] = {
  function()
    require("heirline-components.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
  end,
  desc = "Previous buffer",
}
maps.n["]b"] = {
  function()
    require("heirline-components.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
  end,
  desc = "Next buffer",
}
maps.n["[b"] = {
  function()
    require("heirline-components.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
  end,
  desc = "Previous buffer",
}
maps.n[">b"] = {
  function()
    require("heirline-components.buffer").move(vim.v.count > 0 and vim.v.count or 1)
  end,
  desc = "Move buffer tab right",
}
maps.n["<b"] = {
  function()
    require("heirline-components.buffer").move(-(vim.v.count > 0 and vim.v.count or 1))
  end,
  desc = "Move buffer tab left",
}

maps.n["<leader>bl"] = {
  function()
    require("heirline-components.buffer").close_left()
  end,
  desc = "Close all buffers to the left",
}
maps.n["<leader>br"] = {
  function()
    require("heirline-components.buffer").close_right()
  end,
  desc = "Close all buffers to the right",
}
maps.n["<leader>bse"] = {
  function()
    require("heirline-components.buffer").sort("extension")
  end,
  desc = "Sort by extension (buffers)",
}
maps.n["<leader>bsr"] = {
  function()
    require("heirline-components.buffer").sort("unique_path")
  end,
  desc = "Sort by relative path (buffers)",
}
maps.n["<leader>bsp"] = {
  function()
    require("heirline-components.buffer").sort("full_path")
  end,
  desc = "Sort by full path (buffers)",
}
maps.n["<leader>bsi"] = {
  function()
    require("heirline-components.buffer").sort("bufnr")
  end,
  desc = "Sort by buffer number (buffers)",
}
maps.n["<leader>bsm"] = {
  function()
    require("heirline-components.buffer").sort("modified")
  end,
  desc = "Sort by modification (buffers)",
}
maps.n["<leader>bc"] = {
  function()
    require("heirline-components.buffer").close_all(true)
  end,
  desc = "Close all buffers except current",
}
maps.n["<leader>bC"] = {
  function()
    require("heirline-components.buffer").close_all()
  end,
  desc = "Close all buffers",
}
maps.n["<leader>bb"] = {
  function()
    require("heirline-components.all").heirline.buffer_picker(function(bufnr)
      vim.api.nvim_win_set_buf(0, bufnr)
    end)
  end,
  desc = "Select buffer from tabline",
}
maps.n["<leader>bd"] = {
  function()
    require("heirline-components.all").heirline.buffer_picker(function(bufnr)
      require("heirline-components.buffer").close(bufnr)
    end)
  end,
  desc = "Delete buffer from tabline",
}
maps.n["<leader>b\\"] = {
  function()
    require("heirline-components.all").heirline.buffer_picker(function(bufnr)
      vim.cmd.split()
      vim.api.nvim_win_set_buf(0, bufnr)
    end)
  end,
  desc = "Horizontal split buffer from tabline",
}
maps.n["<leader>b|"] = {
  function()
    require("heirline-components.all").heirline.buffer_picker(function(bufnr)
      vim.cmd.vsplit()
      vim.api.nvim_win_set_buf(0, bufnr)
    end)
  end,
  desc = "Vertical split buffer from tabline",
}

-- smart-splits.nivm
if has("smart-splits.nvim") then
  maps.n["<C-h>"] = {
    function()
      require("smart-splits").move_cursor_left()
    end,
    desc = "Move to left split",
  }
  maps.n["<C-j>"] = {
    function()
      require("smart-splits").move_cursor_down()
    end,
    desc = "Move to below split",
  }
  maps.n["<C-k>"] = {
    function()
      require("smart-splits").move_cursor_up()
    end,
    desc = "Move to above split",
  }
  maps.n["<C-l>"] = {
    function()
      require("smart-splits").move_cursor_right()
    end,
    desc = "Move to right split",
  }
  maps.n["<C-Up>"] = {
    function()
      require("smart-splits").resize_up()
    end,
    desc = "Resize split up",
  }
  maps.n["<C-Down>"] = {
    function()
      require("smart-splits").resize_down()
    end,
    desc = "Resize split down",
  }
  maps.n["<C-Left>"] = {
    function()
      require("smart-splits").resize_left()
    end,
    desc = "Resize split left",
  }
  maps.n["<C-Right>"] = {
    function()
      require("smart-splits").resize_right()
    end,
    desc = "Resize split right",
  }
else
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

-- For ToggleTerm
maps.n["<Leader>tf"] = { "<Cmd>ToggleTerm direction=float<CR>", desc = "ToggleTerm float" }
maps.n["<Leader>th"] = { "<Cmd>ToggleTerm size=10 direction=horizontal<CR>", desc = "ToggleTerm horizontal split" }
maps.n["<Leader>tv"] = { "<Cmd>ToggleTerm size=50 direction=vertical<CR>", desc = "ToggleTerm vertical split" }
maps.n["<Leader>t<tab>"] = { "<Cmd>ToggleTerm  direction=tab<CR>", desc = "ToggleTerm new tab" }
maps.n["<leader>tt"] = { '<Cmd>execute v:count . "ToggleTerm"<CR>', desc = "Toggle terminal" }
maps.n["<F7>"] = { '<Cmd>execute v:count . "ToggleTerm"<CR>', desc = "Toggle terminal" }
maps.t["<F7>"] = { "<Cmd>ToggleTerm<CR>", desc = "Toggle terminal" }
maps.i["<F7>"] = { "<Esc><Cmd>ToggleTerm<CR>", desc = "Toggle terminl" }
maps.n["<C-'>"] = { '<Cmd>execute v:count . "ToggleTerm"<CR>', desc = "Toggle terminal" } -- requires terminal that supports binding <C-'>
maps.t["<C-'>"] = { "<Cmd>ToggleTerm<CR>", desc = "Toggle terminal" } -- requires terminal that supports binding <C-'>
maps.i["<C-'>"] = { "<Esc><Cmd>ToggleTerm<CR>", desc = "Toggle terminl" } -- requires terminal that supports binding <C-'>
if vim.fn.executable("btm") == 1 then
  maps.n["<Leader>bt"] = {
    function()
      utils.toggle_term_cmd({ cmd = "btm", direction = "float" })
    end,
    desc = "ToggleTerm btm",
  }
end
maps.n["<leader>tc"] = {
  function()
    local input_opts = { prompt = "Put Commands", default = "" }
    vim.ui.input(input_opts, function(cmd)
      if not cmd or #cmd == 0 then
        return
      end
      utils.toggle_term_cmd(cmd)
    end)
  end,
  desc = "Put commands",
}

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

-- For Fittencode
if utils.has("fittencode.nvim") then
  maps.n["<leader>aF"] = {
    function()
      toggle.fittencode()
    end,
    desc = "Toggle Fitten Code",
  }
end

-- For diagnostic
maps.n["<leader>ld"] = {
  function()
    vim.diagnostic.open_float()
  end,
  desc = "Hover diagnostics",
}
if vim.fn.has("nvim-0.11") == 0 then
  maps.n["[d"] = {
    function()
      vim.diagnostic.goto_prev()
    end,
    desc = "Previous diagnostic",
  }
  maps.n["]d"] = {
    function()
      vim.diagnostic.goto_next()
    end,
    desc = "Next diagnostic",
  }
end

vim.keymap.set("n", "<leader>lf", function()
  require("conform").format()
end, { noremap = true, silent = true, desc = "Formatting" })

require("utils").set_mappings(maps)
