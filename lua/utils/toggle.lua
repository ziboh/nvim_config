---copyright 2023
---license GNU General Public License v3.0
---@class astrocore.toggles
local M = {}
local T = {}
local function bool2str(bool) return bool and "on" or "off" end
local function ui_notify(silent, ...) return not silent and require("utils").notify(...) end

--- Toggle autopairs
---@param silent? boolean if true then don't sent a notification
function M.autopairs(silent)
  local ok, autopairs = pcall(require, "nvim-autopairs")
  if ok then
    if autopairs.state.disabled then
      autopairs.enable()
    else
      autopairs.disable()
    end
    ui_notify(silent, ("autopairs %s"):format(bool2str(not autopairs.state.disabled)))
  else
    ui_notify(silent, "autopairs not available")
  end
end

--- Toggle background="dark"|"light"
---@param silent? boolean if true then don't sent a notification
function M.background(silent)
  vim.go.background = vim.go.background == "light" and "dark" or "light"
  ui_notify(silent, ("background=%s"):format(vim.go.background))
end

--- Toggle showtabline=2|0
---@param silent? boolean if true then don't sent a notification
function M.tabline(silent)
  vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 2 or 0
  ui_notify(silent, ("tabline %s"):format(bool2str(vim.opt.showtabline:get() == 2)))
end

--- Toggle conceal=2|0
---@param silent? boolean if true then don't sent a notification
function M.conceal(silent)
  vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 2 or 0
  ui_notify(silent, ("conceal %s"):format(bool2str(vim.opt.conceallevel:get() == 2)))
end

--- Toggle laststatus=3|2|0
---@param silent? boolean if true then don't sent a notification
function M.statusline(silent)
  local laststatus = vim.opt.laststatus:get()
  local status
  if laststatus == 0 then
    vim.opt.laststatus = 2
    status = "local"
  elseif laststatus == 2 then
    vim.opt.laststatus = 3
    status = "global"
  elseif laststatus == 3 then
    vim.opt.laststatus = 0
    status = "off"
  end
  ui_notify(silent, ("statusline %s"):format(status))
end

--- Toggle signcolumn="auto"|"no"
---@param silent? boolean if true then don't sent a notification
function M.signcolumn(silent)
  if vim.wo.signcolumn == "no" then
    vim.wo.signcolumn = "yes"
  elseif vim.wo.signcolumn == "yes" then
    vim.wo.signcolumn = "auto"
  else
    vim.wo.signcolumn = "no"
  end
  ui_notify(silent, ("signcolumn=%s"):format(vim.wo.signcolumn))
end

--- Set the indent and tab related numbers
---@param silent? boolean if true then don't sent a notification
function M.indent(silent)
  local input_avail, input = pcall(vim.fn.input, "Set indent value (>0 expandtab, <=0 noexpandtab): ")
  if input_avail then
    local indent = tonumber(input)
    if not indent or indent == 0 then return end
    vim.bo.expandtab = (indent > 0) -- local to buffer
    indent = math.abs(indent)
    vim.bo.tabstop = indent -- local to buffer
    vim.bo.softtabstop = indent -- local to buffer
    vim.bo.shiftwidth = indent -- local to buffer
    ui_notify(silent, ("indent=%d %s"):format(indent, vim.bo.expandtab and "expandtab" or "noexpandtab"))
  end
end

--- Change the number display modes
---@param silent? boolean if true then don't sent a notification
function M.number(silent)
  local number = vim.wo.number -- local to window
  local relativenumber = vim.wo.relativenumber -- local to window
  if not number and not relativenumber then
    vim.wo.number = true
  elseif number and not relativenumber then
    vim.wo.relativenumber = true
  elseif number and relativenumber then
    vim.wo.number = false
  else -- not number and relativenumber
    vim.wo.relativenumber = false
  end
  ui_notify(silent, ("number %s, relativenumber %s"):format(bool2str(vim.wo.number), bool2str(vim.wo.relativenumber)))
end

--- Toggle spell
---@param silent? boolean if true then don't sent a notification
function M.spell(silent)
  vim.wo.spell = not vim.wo.spell -- local to window
  ui_notify(silent, ("spell %s"):format(bool2str(vim.wo.spell)))
end

--- Toggle wrap
---@param silent? boolean if true then don't sent a notification
function M.wrap(silent)
  vim.wo.wrap = not vim.wo.wrap -- local to window
  ui_notify(silent, ("wrap %s"):format(bool2str(vim.wo.wrap)))
end

local last_active_foldcolumn
--- Toggle foldcolumn=0|1
---@param silent? boolean if true then don't sent a notification
function M.foldcolumn(silent)
  local curr_foldcolumn = vim.wo.foldcolumn
  if curr_foldcolumn ~= "0" then last_active_foldcolumn = curr_foldcolumn end
  vim.wo.foldcolumn = curr_foldcolumn == "0" and (last_active_foldcolumn or "1") or "0"
  ui_notify(silent, ("foldcolumn=%s"):format(vim.wo.foldcolumn))
end

--- Toggle diagnostics
---@param silent? boolean if true then don't sent a notification
function M.diagnostics(silent)
  local config = require "config"
  config.diagnostics.diagnostics_mode = (config.diagnostics.diagnostics_mode - 1) % 3
  vim.diagnostic.config(config.diagnostics.diagnostics_config[config.diagnostics.diagnostics_mode])
  if vim.g.diagnostics_mode == 0 then
    ui_notify(silent, "diagnostics off")
  elseif vim.g.diagnostics_mode == 1 then
    ui_notify(silent, "only status diagnostics")
  else
    ui_notify(silent, "all diagnostics on")
  end
end

function M.fittencode(slient)
  local ok, fittencode = pcall(require, "fittencode")
  if ok then
    local statuscode = fittencode.get_current_status()
    if statuscode == 1 then
      fittencode.enable_completions { enable = true }
      ui_notify(slient, "Enable Fittencode")
    else
      fittencode.enable_completions { enable = false }
      ui_notify(slient, "Disable Fittencode")
    end
    vim.api.nvim_exec_autocmds("User", {
      pattern = "ToggleFitten",
      modeline = false,
    })
  end
end

--- 使用 toggleterm 打开外部命令
---@param opts string | table
function M.toggle_cmd(opts)
  local cmd
  local terminal
  local Terminal = require("toggleterm.terminal").Terminal
  local default_opts = {
    dir = "git_dir",
    direction = "float",
    float_opts = {
      border = "double",
    },
    -- function to run on opening the terminal
    on_open = function(term)
      vim.cmd "startinsert!"
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
    -- function to run on closing the terminal
    on_close = function(term) vim.cmd "startinsert!" end,
  }
  if type(opts) == "string" then
    cmd = opts
    opts = vim.tbl_deep_extend("force", default_opts, { cmd = opts })
  elseif type(opts) == "table" then
    cmd = opts.cmd
    opts = vim.tbl_deep_extend("force", default_opts, opts)
  end
  if T[cmd] then
    terminal = T[cmd]
  else
    vim.notify("创建新的终端", vim.log.levels.INFO, {})
    terminal = Terminal:new(opts)
    T[cmd] = terminal
  end

  terminal:toggle()
end

return M
