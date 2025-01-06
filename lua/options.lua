-- This file is automatically loaded by plugins.core
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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

--For which-key
opt.timeout = true
opt.timeoutlen = 300

-- turn off swapfile
opt.swapfile = false

opt.wrap = true -- wrap lines by default

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

if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = true,
  }
end
