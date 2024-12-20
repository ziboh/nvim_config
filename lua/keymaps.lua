local utils = require "utils"
local get_icon = utils.get_icon
local is_available = utils.is_available
local maps = require("utils").get_mappings_template()
local toggle = require "utils.toggle"
local icons = {
  w = { group = "Window", icon = get_icon("Window", 0, true) },
  x = { group = "Trouble", icon = "" },
  r = { group = "Replace/" .. get_icon("Rust", 1, true) .. "Rust", icon = get_icon("Replace", 0, true) },
  f = { group = "Find" },
  p = { group = "Packages/" .. get_icon("Python", 1, true) .. "Python", icon = get_icon("Packages", 0, true) },
  l = { group = "LSP", icon = "" },
  u = { group = "UI", icon = get_icon("UI", 0, true) },
  du = { group = "DAP-UI", icon = get_icon("Debugger", 0, true) },
  b = { group = "Buffers", icon = "" },
  d = { group = "Debugger" },
  g = { group = "GIt", icon = { icon = get_icon "Git", hl = "DevIconGitAttributes" } },
  gt = { group = "GItsign Toggle", icon = { icon = get_icon "Git", hl = "DevIconGitAttributes" } },
  s = { group = "Session", icon = get_icon("Session", 0, true) },
  t = { group = "Terminal" },
  a = { group = "Ai", icon = get_icon("Ai", 0, true) },
  o = { group = "Overseer", icon = get_icon("Overseer", 0, true) },
}
maps.n["<leader>a"] = icons.a
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
-- vim.keymap.set("n", "z<space>", "za", { noremap = true, silent = true, desc ="Toggle fold under cursor" })

vim.keymap.set("n", "L", "$", { noremap = true, silent = true, desc = "Move to end of line" })
vim.keymap.set("n", "H", "^", { noremap = true, silent = true, desc = "Move to first non-blank character" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Decrease window height" })
vim.keymap.set("n", "M", "J", { noremap = true, silent = true, desc = "Join the current line with the next line" })

vim.keymap.set("t", "<C-_>", [[<C-\><C-n>]], {})
vim.keymap.set("t", "jk", [[<C-\><C-n>]], {})
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
-- For toggletrem

-- buffers/tabs [buffers ]--------------------------------------------------
maps.n["<leader>c"] = { -- Close window and buffer at the same time.
  function() require("heirline-components.buffer").wipe() end,
  desc = "Wipe buffer",
}
maps.n["<leader>C"] = { -- Close buffer keeping the window.
  function() require("heirline-components.buffer").close() end,
  desc = "Close buffer",
}

maps.n["<leader>ba"] = { function() vim.cmd "wa" end, desc = "Write all changed buffers" }
maps.n["]]"] = {
  function() require("heirline-components.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
  desc = "Next buffer",
}
maps.n["[["] = {
  function() require("heirline-components.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
  desc = "Previous buffer",
}
maps.n["]b"] = {
  function() require("heirline-components.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
  desc = "Next buffer",
}
maps.n["[b"] = {
  function() require("heirline-components.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
  desc = "Previous buffer",
}
maps.n[">b"] = {
  function() require("heirline-components.buffer").move(vim.v.count > 0 and vim.v.count or 1) end,
  desc = "Move buffer tab right",
}
maps.n["<b"] = {
  function() require("heirline-components.buffer").move(-(vim.v.count > 0 and vim.v.count or 1)) end,
  desc = "Move buffer tab left",
}

maps.n["<leader>b"] = icons.b
maps.n["<leader>bs"] = { desc = "Sort Buffer" }
maps.n["<leader>bl"] =
  { function() require("heirline-components.buffer").close_left() end, desc = "Close all buffers to the left" }
maps.n["<leader>br"] =
  { function() require("heirline-components.buffer").close_right() end, desc = "Close all buffers to the right" }
maps.n["<leader>bse"] =
  { function() require("heirline-components.buffer").sort "extension" end, desc = "Sort by extension (buffers)" }
maps.n["<leader>bsr"] =
  { function() require("heirline-components.buffer").sort "unique_path" end, desc = "Sort by relative path (buffers)" }
maps.n["<leader>bsp"] =
  { function() require("heirline-components.buffer").sort "full_path" end, desc = "Sort by full path (buffers)" }
maps.n["<leader>bsi"] =
  { function() require("heirline-components.buffer").sort "bufnr" end, desc = "Sort by buffer number (buffers)" }
maps.n["<leader>bsm"] =
  { function() require("heirline-components.buffer").sort "modified" end, desc = "Sort by modification (buffers)" }
maps.n["<leader>bc"] =
  { function() require("heirline-components.buffer").close_all(true) end, desc = "Close all buffers except current" }
maps.n["<leader>bC"] = { function() require("heirline-components.buffer").close_all() end, desc = "Close all buffers" }
maps.n["<leader>bb"] = {
  function()
    require("heirline-components.all").heirline.buffer_picker(function(bufnr) vim.api.nvim_win_set_buf(0, bufnr) end)
  end,
  desc = "Select buffer from tabline",
}
maps.n["<leader>bd"] = {
  function()
    require("heirline-components.all").heirline.buffer_picker(
      function(bufnr) require("heirline-components.buffer").close(bufnr) end
    )
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

-- For which-key
maps.n["<leader>l"] = icons.l
maps.n["<leader>g"] = icons.g
maps.n["<leader>x"] = icons.x
maps.n["<leader>t"] = icons.t
maps.n["<leader>r"] = icons.r
maps.n["<leader>f"] = icons.f
maps.n["<leader>gn"] = { group = "Neogit" }
maps.n["<leader>gt"] = icons.gt

-- For Rest
maps.n["<leader>rc"] = { "<cmd>Rest run<CR>", desc = "Run Rest" }
-- For telescope
if is_available "telescope.nvim" then
  maps.n["<leader>f"] = icons.f
  maps.n["<leader>gb"] = { function() require("telescope.builtin").git_branches() end, desc = "Git branches" }
  maps.n["<leader>gc"] =
    { function() require("telescope.builtin").git_commits() end, desc = "Git commits (repository)" }
  maps.n["<leader>gC"] =
    { function() require("telescope.builtin").git_bcommits() end, desc = "Git commits (current file)" }
  maps.n["<leader>f<CR>"] = { function() require("telescope.builtin").resume() end, desc = "Resume previous search" }
  maps.n["<leader>f'"] = { function() require("telescope.builtin").marks() end, desc = "Find marks" }
  maps.n["<leader>fb"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers" }
  maps.n["<leader>fp"] = { function() require("telescope").extensions.projects.projects {} end, desc = "Find Project" }
  maps.n["<leader>fw"] =
    { function() require("telescope.builtin").grep_string() end, desc = "Find word under cursor in project" }
  maps.n["<leader>fc"] = { function() require("telescope.builtin").commands() end, desc = "Find commands" }
  maps.n["<leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Find help" }
  maps.n["<leader>fk"] = { function() require("telescope.builtin").keymaps() end, desc = "Find keymaps" }
  maps.n["<leader>fm"] = { function() require("telescope.builtin").man_pages() end, desc = "Find man" }
  maps.n["<leader>fo"] = { function() require("telescope.builtin").oldfiles() end, desc = "Find recent" }
  maps.n["<leader>fv"] = { function() require("telescope.builtin").registers() end, desc = "Find vim registers" }
  maps.n["<leader>ff"] = { function() require("telescope.builtin").live_grep() end, desc = "Find words in project" }
  maps.n["<leader> "] = { function() require("telescope.builtin").find_files() end, desc = "Find file" }
  maps.n["<leader>fH"] = { function() require("telescope.builtin").highlights() end, desc = "Lists highlights" }
  maps.n["<leader>f/"] =
    { function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Find words in current buffer" }
  maps.n["<leader>ft"] = {
    function()
      pcall(vim.api.nvim_command, "doautocmd User LoadColorSchemes")
      pcall(require("telescope.builtin").colorscheme, { enable_preview = true })
    end,
    desc = "Find themes",
  }
  maps.n["<leader>fa"] = {
    function()
      local cwd = vim.fn.stdpath "config" .. "/.."
      local search_dirs = { vim.fn.stdpath "config" }
      if #search_dirs == 1 then cwd = search_dirs[1] end -- if only one directory, focus cwd
      require("telescope.builtin").find_files {
        prompt_title = "Config Files",
        search_dirs = search_dirs,
        cwd = cwd,
        follow = true,
      } -- call telescope
    end,
    desc = "Find nvim config files",
  }

  if is_available "nvim-notify" then
    maps.n["<leader>fn"] =
      { function() require("telescope").extensions.notify.notify() end, desc = "Find notifications" }
  end

  maps.n["<leader>lS"] = {
    function()
      local aerial_avail, _ = pcall(require, "aerial")
      if aerial_avail then
        require("telescope").extensions.aerial.aerial()
      else
        require("telescope.builtin").lsp_document_symbols()
      end
    end,
    desc = "Search symbol in buffer", -- Useful to find every time a variable is assigned.
  }
  maps.n["gs"] = {
    function()
      local aerial_avail, _ = pcall(require, "aerial")
      if aerial_avail then
        require("telescope").extensions.aerial.aerial()
      else
        require("telescope.builtin").lsp_document_symbols()
      end
    end,
    desc = "Search symbol in buffer", -- Useful to find every time a variable is assigned.
  }

  -- extra - luasnip
  if is_available "LuaSnip" and is_available "telescope-luasnip.nvim" then
    maps.n["<leader>fs"] = {
      function() require("telescope").extensions.luasnip.luasnip {} end,
      desc = "Find snippets",
    }
  end

  -- extra - undotree
  if is_available "telescope-undo.nvim" then
    maps.n["<leader>fu"] = {
      function() require("telescope").extensions.undo.undo() end,
      desc = "Find in undo tree",
    }
  end

  -- extra - compiler
  if is_available "compiler.nvim" and is_available "overseer.nvim" then
    maps.n["<leader>m"] = icons.c
    maps.n["<leader>mm"] = { function() vim.cmd "CompilerOpen" end, desc = "Open compiler" }
    maps.n["<leader>mr"] = { function() vim.cmd "CompilerRedo" end, desc = "Compiler redo" }
    maps.n["<leader>mt"] = { function() vim.cmd "CompilerToggleResults" end, desc = "compiler results" }
    maps.n["<F6>"] = { function() vim.cmd "CompilerOpen" end, desc = "Open compiler" }
    maps.n["<S-F6>"] = { function() vim.cmd "CompilerRedo" end, desc = "Compiler redo" }
    maps.n["<S-F7>"] = { function() vim.cmd "CompilerToggleResults" end, desc = "compiler resume" }
  end
end

-- smart-splits.nivm
if is_available "smart-splits.nvim" then
  maps.n["<C-h>"] = { function() require("smart-splits").move_cursor_left() end, desc = "Move to left split" }
  maps.n["<C-j>"] = { function() require("smart-splits").move_cursor_down() end, desc = "Move to below split" }
  maps.n["<C-k>"] = { function() require("smart-splits").move_cursor_up() end, desc = "Move to above split" }
  maps.n["<C-l>"] = { function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" }
  maps.n["<C-Up>"] = { function() require("smart-splits").resize_up() end, desc = "Resize split up" }
  maps.n["<C-Down>"] = { function() require("smart-splits").resize_down() end, desc = "Resize split down" }
  maps.n["<C-Left>"] = { function() require("smart-splits").resize_left() end, desc = "Resize split left" }
  maps.n["<C-Right>"] = { function() require("smart-splits").resize_right() end, desc = "Resize split right" }
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

maps.n["<leader>w"] = icons.w
maps.n["<leader>wp"] = {
  function()
    local winid = require("window-picker").pick_window()
    if winid then vim.api.nvim_set_current_win(winid) end
  end,
  desc = "Pick window",
}
maps.n["<leader>ww"] = { "<c-w>w", desc = "other window" }
maps.n["<leader>wd"] = { "<c-w>c", desc = "delete window" }
maps.n["<leader>wl"] = { "<c-w>v", desc = "spite window right" }
maps.n["<leader>wj"] = { "<c-w>s", desc = "splite window below" }
maps.n["<leader>wo"] = { "<c-w>o", desc = "only window" }
maps.n["<leader>wx"] = { "<c-w>x", desc = "Swap current with next" }
maps.n["<leader>wf"] = { "<c-w>pa", desc = "switch window" }
maps.n["|"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" }

-- For package
maps.n["<leader>p"] = icons.p
maps.n["<leader>pl"] = { "<cmd>Lazy<CR>", desc = "Lazy" }
maps.n["<leader>pm"] = { "<cmd>Mason<CR>", desc = "Mason" }
maps.n["<leader><tab>"] = { "<cmd>tabNext<CR>", desc = "Next tab" }

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
maps.n["<leader>gg"] = {
  function()
    require("utils.toggle").toggle_cmd {
      cmd = "lazygit",
      dir = "git_dir",
      direction = "tab",
      -- function to run on opening the terminal
      on_open = function(term)
        vim.cmd "startinsert!"
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      end,
      -- function to run on closing the terminal
      on_close = function(_) vim.cmd "startinsert!" end,
    }
  end,
  desc = "Toggle Lazygit",
}
maps.n["<leader>tc"] = {
  function()
    local input_opts = { prompt = "Put Commands", default = "" }
    vim.ui.input(input_opts, function(cmd)
      if not cmd or #cmd == 0 then return end
      utils.toggle_term_cmd(cmd)
    end)
  end,
  desc = "chat with Fitten Code",
}

-- For ui
maps.n["<leader>u"] = icons.u
maps.n["<leader>ub"] = { function() toggle.background() end, desc = "Toggle Background" }
maps.n["<leader>ua"] = { function() toggle.autopairs() end, desc = "Toggle Autopairs" }
maps.n["<leader>uw"] = { function() toggle.wrap() end, desc = "Toggle Wrap" }
maps.n["<leader>uz"] = { function() toggle.foldcolumn() end, desc = "Toggle Foldcolumu" }
maps.n["<leader>ud"] = { function() toggle.diagnostics(true) end, desc = "Toggle Diagnostics" }
maps.n["<leader>ut"] = { function() toggle.tabline() end, desc = "Toggle Tabline" }
maps.n["<leader>uc"] = { function() toggle.conceal() end, desc = "Toggle Conceal" }
maps.n["<leader>us"] = { function() toggle.statusline() end, desc = "Toggle Statusline" }
maps.n["<leader>ui"] = { function() toggle.indent() end, desc = "Toggle Indent" }
maps.n["<leader>uN"] = { function() toggle.number() end, desc = "Toggle Number" }
maps.n["<leader>us"] = { function() toggle.spell() end, desc = "Toggle Spell" }
maps.n["<leader>un"] =
  { function() require("notify").dismiss { silent = true, pending = true } end, desc = "Dismiss Notifications" }

-- Dap
maps.n["<Leader>d"] = icons.d
maps.n["<Leader>du"] = icons.du
-- modified function keys found with `showkey -a` in the terminal to get key code
-- run `nvim -V3log +quit` and search through the "Terminal info" in the `log` file for the correct keyname
maps.n["<F5>"] = { function() require("dap").continue() end, desc = "Debugger: Start" }
maps.n["<F17>"] = { function() require("dap").terminate() end, desc = "Debugger: Stop" } -- Shift+F5
maps.n["<F29>"] = { function() require("dap").restart_frame() end, desc = "Debugger: Restart" } -- Control+F5
maps.n["<F6>"] = { function() require("dap").pause() end, desc = "Debugger: Pause" }
maps.n["<F9>"] = { function() require("dap").toggle_breakpoint() end, desc = "Debugger: Toggle Breakpoint" }
maps.n["<F10>"] = { function() require("dap").step_over() end, desc = "Debugger: Step Over" }
maps.n["<F11>"] = { function() require("dap").step_into() end, desc = "Debugger: Step Into" }
maps.n["<F23>"] = { function() require("dap").step_out() end, desc = "Debugger: Step Out" } -- Shift+F11
maps.n["<Leader>db"] = { function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (F9)" }
maps.n["<Leader>dB"] = { function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" }
maps.n["<Leader>dc"] = { function() require("dap").continue() end, desc = "Start/Continue (F5)" }
maps.n["<Leader>di"] = { function() require("dap").step_into() end, desc = "Step Into (F11)" }
maps.n["<Leader>do"] = { function() require("dap").step_over() end, desc = "Step Over (F10)" }
maps.n["<Leader>dO"] = { function() require("dap").step_out() end, desc = "Step Out (S-F11)" }
maps.n["<Leader>dq"] = { function() require("dap").close() end, desc = "Close Session" }
maps.n["<Leader>dQ"] = { function() require("dap").terminate() end, desc = "Terminate Session (S-F5)" }
maps.n["<Leader>dp"] = { function() require("dap").pause() end, desc = "Pause (F6)" }
maps.n["<Leader>dr"] = { function() require("dap").restart_frame() end, desc = "Restart (C-F5)" }
maps.n["<Leader>dR"] = { function() require("dap").repl.toggle() end, desc = "Toggle REPL" }
maps.n["<Leader>ds"] = { function() require("dap").run_to_cursor() end, desc = "Run To Cursor" }
maps.n["<F21>"] = { -- Shift+F9
  function()
    vim.ui.input({ prompt = "Condition: " }, function(condition)
      if condition then require("dap").set_breakpoint(condition) end
    end)
  end,
  desc = "Debugger: Conditional Breakpoint",
}
maps.n["<Leader>dC"] = {
  function()
    vim.ui.input({ prompt = "Condition: " }, function(condition)
      if condition then require("dap").set_breakpoint(condition) end
    end)
  end,
  desc = "Conditional Breakpoint (S-F9)",
}
maps.n["<Leader>duc"] = {
  function() require("dapui").close() end,
  desc = "Close Dap UI",
}
maps.n["<Leader>duo"] = {
  function() require("dapui").open() end,
  desc = "Open Dap UI",
}

-- For Fittencode
if utils.is_available "fittencode.nvim" then
  maps.n["<leader>aF"] = {
    function() toggle.fittencode() end,
    desc = "Toggle Fitten Code",
  }
end

-- For diagnostic
maps.n["<leader>ld"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" }
if vim.fn.has "nvim-0.11" == 0 then
  maps.n["[d"] = { function() vim.diagnostic.goto_prev() end, desc = "Previous diagnostic" }
  maps.n["]d"] = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" }
end

vim.keymap.set(
  "n",
  "<leader>lf",
  function() require("conform").format() end,
  { noremap = true, silent = true, desc = "Formatting" }
)

-- FOr ccc
maps.n["<Leader>uC"] = { "<Cmd>CccHighlighterToggle<CR>", desc = "Toggle colorizer" }
maps.n["<Leader>pg"] = { "<Cmd>CccConvert<CR>", desc = "Convert color" }
maps.n["<Leader>pc"] = { "<Cmd>CccPick<CR>", desc = "Pick Color" }

-- For Gp
-- Chat commands

maps.n["<C-g>"] = icons.a
maps.n["<C-g>c"] = { "<cmd>GpChatNew vsplit<cr>", desc = "New Chat" }
maps.i["<C-g>c"] = { "<cmd>GpChatNew vsplit<cr>", desc = "New Chat" }

maps.n["<C-g>t"] = { "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" }
maps.i["<C-g>t"] = { "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" }

maps.n["<C-g>f"] = { "<cmd>GpChatFinder<cr>", desc = "Chat Finder" }
maps.i["<C-g>f"] = { "<cmd>GpChatFinder<cr>", desc = "Chat Finder" }

maps.v["<C-g>c"] = { ":'<,'>GpChatNew vsplit<cr>", desc = "Visual Chat New" }
maps.v["<C-g>p"] = { ":'<,'>GpChatPaste<cr>", desc = "Visual Chat Paste" }
maps.v["<C-g>t"] = { ":'<,'>GpChatToggle<cr>", desc = "Visual Toggle Chat" }

maps.n["<C-g><C-x>"] = { "<cmd>GpChatNew split<cr>", desc = "New Chat split" }
maps.i["<C-g><C-x>"] = { "<cmd>GpChatNew split<cr>", desc = "New Chat split" }

maps.n["<C-g><C-v>"] = { "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" }
maps.i["<C-g><C-v>"] = { "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" }

maps.n["<C-g><C-t>"] = { "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" }
maps.i["<C-g><C-t>"] = { "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" }

maps.v["<C-g><C-x>"] = { ":'<,'>GpChatNew split<cr>", desc = "Visual Chat New split" }
maps.v["<C-g><C-v>"] = { ":'<,'>GpChatNew vsplit<cr>", desc = "Visual Chat New vsplit" }
maps.v["<C-g><C-t>"] = { ":'<,'>GpChatNew tabnew<cr>", desc = "Visual Chat New tabnew" }

-- Prompt commands
maps.n["<C-g>r"] = { "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" }
maps.i["<C-g>r"] = { "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" }

maps.n["<C-g>a"] = { "<cmd>GpAppend<cr>", desc = "Append (after)" }
maps.i["<C-g>a"] = { "<cmd>GpAppend<cr>", desc = "Append (after)" }

maps.n["<C-g>b"] = { "<cmd>GpPrepend<cr>", desc = "Prepend (before)" }
maps.i["<C-g>b"] = { "<cmd>GpPrepend<cr>", desc = "Prepend (before)" }

maps.v["<C-g>r"] = { ":'<,'>GpRewrite<cr>", desc = "Visual Rewrite" }
maps.v["<C-g>a"] = { ":'<,'>GpAppend<cr>", desc = "Visual Append (after)" }
maps.v["<C-g>b"] = { ":'<,'>GpPrepend<cr>", desc = "Visual Prepend (before)" }
maps.v["<C-g>i"] = { ":'<,'>GpImplement<cr>", desc = "Implement selection" }

maps.n["<C-g>g"] = { group = "Gp", icon = get_icon("Ai", 0, true) }
maps.n["<C-g>gp"] = { "<cmd>GpPopup<cr>", desc = "Popup" }
maps.i["<C-g>gp"] = { "<cmd>GpPopup<cr>", desc = "Popup" }

maps.n["<C-g>ge"] = { "<cmd>GpEnew<cr>", desc = "GpEnew" }
maps.i["<C-g>ge"] = { "<cmd>GpEnew<cr>", desc = "GpEnew" }

maps.n["<C-g>gn"] = { "<cmd>GpNew<cr>", desc = "GpNew" }
maps.i["<C-g>gn"] = { "<cmd>GpNew<cr>", desc = "GpNew" }

maps.n["<C-g>gv"] = { "<cmd>GpVnew<cr>", desc = "GpVnew" }
maps.i["<C-g>gv"] = { "<cmd>GpVnew<cr>", desc = "GpVnew" }

maps.n["<C-g>gt"] = { "<cmd>GpTabnew<cr>", desc = "GpTabnew" }
maps.i["<C-g>gt"] = { "<cmd>GpTabnew<cr>", desc = "GpTabnew" }

maps.v["<C-g>gp"] = { ":'<,'>GpPopup<cr>", desc = "Visual Popup" }
maps.v["<C-g>ge"] = { ":'<,'>GpEnew<cr>", desc = "Visual GpEnew" }
maps.v["<C-g>gn"] = { ":'<,'>GpNew<cr>", desc = "Visual GpNew" }
maps.v["<C-g>gv"] = { ":'<,'>GpVnew<cr>", desc = "Visual GpVnew" }
maps.v["<C-g>gt"] = { ":'<,'>GpTabnew<cr>", desc = "Visual GpTabnew" }

maps.n["<C-g>x"] = { "<cmd>GpContext<cr>", desc = "Toggle Context" }
maps.i["<C-g>x"] = { "<cmd>GpContext<cr>", desc = "Toggle Context" }
maps.v["<C-g>x"] = { ":'<,'>GpContext<cr>", desc = "Visual Toggle Context" }

maps.n["<C-g>s"] = { "<cmd>GpStop<cr>", desc = "Stop" }
maps.i["<C-g>s"] = { "<cmd>GpStop<cr>", desc = "Stop" }
maps.v["<C-g>s"] = { "<cmd>GpStop<cr>", desc = "Stop" }
maps.x["<C-g>s"] = { "<cmd>GpStop<cr>", desc = "Stop" }

maps.n["<C-g>n"] = { "<cmd>GpNextAgent<cr>", desc = "Next Agent" }
maps.i["<C-g>n"] = { "<cmd>GpNextAgent<cr>", desc = "Next Agent" }
maps.v["<C-g>n"] = { "<cmd>GpNextAgent<cr>", desc = "Next Agent" }
maps.x["<C-g>n"] = { "<cmd>GpNextAgent<cr>", desc = "Next Agent" }

-- Optional Whisper commands with prefix <C-g>w
maps.n["<C-g>w"] = { group = "whisper", icon = get_icon("Ai", 0, true) }
maps.n["<C-g>ww"] = { "<cmd>GpWhisper<cr>", desc = "Whisper" }
maps.i["<C-g>ww"] = { "<cmd>GpWhisper<cr>", desc = "Whisper" }
maps.v["<C-g>ww"] = { ":'<,'>GpWhisper<cr>", desc = "Visual Whisper" }

maps.n["<C-g>wr"] = { "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" }
maps.i["<C-g>wr"] = { "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" }

maps.n["<C-g>wa"] = { "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" }
maps.i["<C-g>wa"] = { "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" }

maps.n["<C-g>wb"] = { "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" }
maps.i["<C-g>wb"] = { "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" }

maps.v["<C-g>wr"] = { ":'<,'>GpWhisperRewrite<cr>", desc = "Visual Whisper Rewrite" }
maps.v["<C-g>wa"] = { ":'<,'>GpWhisperAppend<cr>", desc = "Visual Whisper Append (after)" }
maps.v["<C-g>wb"] = { ":'<,'>GpWhisperPrepend<cr>", desc = "Visual Whisper Prepend (before)" }

maps.n["<C-g>wp"] = { "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" }
maps.i["<C-g>wp"] = { "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" }

maps.n["<C-g>we"] = { "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" }
maps.i["<C-g>we"] = { "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" }

maps.n["<C-g>wn"] = { "<cmd>GpWhisperNew<cr>", desc = "Whisper New" }
maps.i["<C-g>wn"] = { "<cmd>GpWhisperNew<cr>", desc = "Whisper New" }

maps.n["<C-g>wv"] = { "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" }
maps.i["<C-g>wv"] = { "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" }

maps.n["<C-g>wt"] = { "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" }
maps.i["<C-g>wt"] = { "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" }

maps.v["<C-g>wp"] = { ":'<,'>GpWhisperPopup<cr>", desc = "Visual Whisper Popup" }
maps.v["<C-g>we"] = { ":'<,'>GpWhisperEnew<cr>", desc = "Visual Whisper Enew" }
maps.v["<C-g>wn"] = { ":'<,'>GpWhisperNew<cr>", desc = "Visual Whisper New" }
maps.v["<C-g>wv"] = { ":'<,'>GpWhisperVnew<cr>", desc = "Visual Whisper Vnew" }
maps.v["<C-g>wt"] = { ":'<,'>GpWhisperTabnew<cr>", desc = "Visual Whisper Tabnew" }

-- For  Overseer
maps.n["<leader>o"] = icons.o
maps.n["<Leader>pa"] = { "<cmd>Alpha<cr>", desc = "Alpha" }
maps.n["<Leader>or"] = { "<cmd>OverseerRun<cr>", desc = "Overseer Run" }
maps.n["<Leader>oR"] = { "<cmd>OverseerRunCmd<cr>", desc = "Overseer RunCmd" }
maps.n["<Leader>ot"] = { "<cmd>OverseerToggle<cr>", desc = "Overseer Toggle" }
maps.n["<Leader>ob"] = { "<cmd>OverseerBuild<cr>", desc = "Overseer Build" }
maps.n["<Leader>oi"] = { "<cmd>OverseerInfo<cr>", desc = "Overseer Info" }
maps.n["<Leader>oo"] = { "<cmd>Oil<cr>", desc = "Oil" }

require("utils").set_mappings(maps)
