-- This file is automatically loaded by plugins.core
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.rime_enabled = false
vim.g.disable_rime_ls_pattern = {
  -- disable in ``
  "`(.*)`",
  -- disable in ''
  "'(.*)'",
  -- disable in ""
  '"(.*)"',
  -- disable in []
  "%[.*%]",
}

vim.g.fittencode_enabled = true
vim.g.supermaven_enabled = true

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
vim.g.ai_cmp = true

vim.g.icons_enabled = true
vim.g.git_worktrees = {
  {
    toplevel = vim.env.HOME,
    gitdir = vim.env.HOME .. "/.local/share/yadm/repo.git",
  },
}
-- For nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.transparent_enabled = false

-- For rust-analyzer
vim.g.rust_analyzer_mason = true

local opt = vim.opt

opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.autowrite = true
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

opt.laststatus = 3 --Global statusline.
opt.completeopt = { "menu", "menuone", "noselect" }
opt.mouse = "a" -- allow the mouse to be used in Nvim
opt.scrolloff = 10 -- no less than 10 lines even if you keep scrolling down

opt.grepprg = "rg --vimgrep"
opt.undofile = true

opt.tabstop = 4 -- number of visual spaces per TAB
opt.softtabstop = 4 -- number of spacesin tab when editing
opt.shiftwidth = 4 -- insert 4 spaces on a tab
opt.expandtab = true -- tabs are spaces, mainly because of python

opt.number = true -- show absolute number
opt.relativenumber = true -- add numbers to each line on the left side
opt.cursorline = true -- highlight cursor line underneath the cursor horizontally
opt.splitbelow = true -- open new vertical split bottom
opt.splitright = true -- open new horizontal splits right
opt.termguicolors = true -- enabl 24-bit RGB color in the TUI
opt.showmode = false -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
opt.incsearch = true -- search as characters are entered
opt.hlsearch = false -- do not highlight matches
opt.ignorecase = true -- ignore case in searches by default
opt.smartcase = true -- but make it case sensitive if an uppercase is entered

-- For heirline
opt.showtabline = 2 -- always display tabline.
opt.signcolumn = "yes" -- always display signcolumn.

-- turn off swapfile
opt.swapfile = false

opt.wrap = true -- wrap lines by default
opt.breakat = ""
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

opt.foldlevel = 99
opt.smoothscroll = true
opt.foldexpr = "v:lua.require'utils'.ui.foldexpr()"
opt.foldmethod = "expr"
opt.foldtext = ""
opt.clipboard = "unnamedplus"

vim.opt.title = true
vim.opt.titlestring = "neovim"

-- Special handling for pwsh
if vim.fn.has("win32") == 1 then
  -- Check if 'pwsh' is executable and set the shell accordingly
  if vim.fn.executable("pwsh") == 1 then
    vim.o.shell = "pwsh"
  elseif vim.fn.executable("powershell") == 1 then
    vim.o.shell = "powershell"
  else
    return Utils.error("No powershell executable found")
  end
  vim.o.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"

  vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"

  vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"

  vim.o.shellquote = ""

  vim.o.shellxquote = ""
end

local setreg = vim.fn.setreg
---@diagnostic disable-next-line: duplicate-set-field
vim.fn.setreg = function(rename, value, opts)
  setreg(rename, value, opts)
  if rename == "+" then
    setreg('"', value, opts)
  end
end
