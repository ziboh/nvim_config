---copyright 2023
---license GNU General Public License v3.0
---@class utils.toggle
local M = {}
local function bool2str(bool)
  return bool and "on" or "off"
end
local function ui_notify(silent, ...)
  return not silent and require("utils").notify(...)
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
    if not indent or indent == 0 then
      return
    end
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
  if curr_foldcolumn ~= "0" then
    last_active_foldcolumn = curr_foldcolumn
  end
  vim.wo.foldcolumn = curr_foldcolumn == "0" and (last_active_foldcolumn or "1") or "0"
  ui_notify(silent, ("foldcolumn=%s"):format(vim.wo.foldcolumn))
end

--- @param slient? boolean if true then don't sent a notification
function M.fittencode(slient)
  if vim.g.fittencode_enabled == false then
    vim.g.fittencode_enabled = true
    if slient == nil or slient == false then
      Utils.info("Enable Fittencode", { title = "Fittencode", timeout = 3000 })
    end
  else
    vim.g.fittencode_enabled = false
    if slient == nil or slient == false then
      Utils.info("Disable Fittencode", { title = "Fittencode", timeout = 3000 })
    end
  end
end


--- @param slient? boolean if true then don't sent a notification
function M.supermaven(slient)
  if vim.g.supermaven_enabled == false then
    vim.g.supermaven_enabled = true
    if slient == nil or slient == false then
      Utils.info("Enable SuperMaven", { title = "SuperMaven", timeout = 3000 })
    end
  else
    vim.g.supermaven_enabled = false
    if slient == nil or slient == false then
      Utils.info("Disable SuperMaven", { title = "SuperMaven", timeout = 3000 })
    end
  end
end
return M
