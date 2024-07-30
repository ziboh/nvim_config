-- Hint: use `:h <option>` to figure out the meaning if needed
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.icons_enabled = true
vim.opt.wrap = false
vim.opt.fileformat = 'unix'

vim.g.transparent_enabled = false
vim.opt.laststatus = 3 --Global statusline.
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.mouse = "a" -- allow the mouse to be used in Nvim
vim.opt.scrolloff = 10 -- no less than 10 lines even if you keep scrolling down

-- Tab
vim.opt.tabstop = 4 -- number of visual spaces per TAB
vim.opt.softtabstop = 4 -- number of spacesin tab when editing
vim.opt.shiftwidth = 4 -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of python

-- UI config
vim.opt.number = true -- show absolute number
vim.opt.relativenumber = true -- add numbers to each line on the left side
vim.opt.cursorline = true -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
vim.opt.termguicolors = true -- enabl 24-bit RGB color in the TUI
vim.opt.showmode = false -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = false -- do not highlight matches
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered

-- For nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- For nvim-ufo
vim.opt.foldcolumn = "2" -- '0' is not bad
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- For heirline
vim.opt.showtabline = 2 -- always display tabline.

--For which-key
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- turn off swapfile
vim.opt.swapfile = false
-- Hint: use `:h <option>` to figure out the meaning if needed
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.icons_enabled = true
vim.opt.wrap = false

vim.g.transparent_enabled = false
vim.opt.laststatus = 3 --Global statusline.
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.mouse = "a" -- allow the mouse to be used in Nvim
vim.opt.scrolloff = 10 -- no less than 10 lines even if you keep scrolling down

-- Tab
vim.opt.tabstop = 4 -- number of visual spaces per TAB
vim.opt.softtabstop = 4 -- number of spacesin tab when editing
vim.opt.shiftwidth = 4 -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of python

-- UI config
vim.opt.number = true -- show absolute number
vim.opt.relativenumber = true -- add numbers to each line on the left side
vim.opt.cursorline = true -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
vim.opt.termguicolors = true -- enabl 24-bit RGB color in the TUI
vim.opt.showmode = false -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = false -- do not highlight matches
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered

-- For nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- For nvim-ufo
vim.opt.foldcolumn = "1" -- '0' is not bad
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- For heirline
vim.opt.showtabline = 2 -- always display tabline.
vim.opt.signcolumn = "yes" -- always display signcolumn.

--For which-key
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- turn off swapfile
vim.opt.swapfile = false

-- Enabled Fittencode
vim.g.enabled_fittencode = false

-- For ChatGpt
vim.g["codegpt_chat_completions_url"] = "https:/35.yunai.xyz/v1/chat/completions"

-- For rust-analyzer
vim.g.rust_analyzer_mason = true

-- For wrap
vim.wo.wrap = true -- local to window
