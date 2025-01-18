local function contains_unacceptable_character(content)
  if content == nil then
    return true
  end
  local ignored_head_number = false
  for i = 1, #content do
    local b = string.byte(content, i)
    if b >= 48 and b <= 57 or b == 32 or b == 46 then
      -- number dot and space
      if ignored_head_number then
        return true
      end
    elseif b <= 127 then
      return true
    else
      ignored_head_number = true
    end
  end
  return false
end

---@class utils.rime
local M = {}

-- Return if rime_ls should be disabled in current context
function M.rime_ls_disabled(context)
  local line = context.line
  local cursor_column = context.cursor[2]
  for _, pattern in ipairs(vim.g.disable_rime_ls_pattern) do
    local start_pos = 1
    while true do
      local match_start, match_end = string.find(line, pattern, start_pos)
      if not match_start then
        break
      end
      if cursor_column >= match_start and cursor_column < match_end then
        return true
      end
      start_pos = match_end + 1
    end
  end
  return false
end

function M.is_rime_item(item)
  if item == nil or item.source_name ~= "rime_ls" then
    return false
  end
  local client = vim.lsp.get_client_by_id(item.client_id)
  return client ~= nil and client.name == "rime_ls"
end

function M.rime_item_acceptable(item)
  return not contains_unacceptable_character(item.label) or item.label:match("%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d%")
end

function M.rime_status_icon()
  return vim.g.rime_enabled and "ㄓ" or ""
end

function M.get_n_rime_item_index(n, items)
  if items == nil then
    items = require("blink.cmp.completion.list").items
  end
  local result = {}
  if items == nil or #items == 0 then
    return result
  end
  for i, item in ipairs(items) do
    if M.is_rime_item(item) then
      result[#result + 1] = i
      if #result == n then
        break
      end
    end
  end
  return result
end

--- @class RimeSetupOpts
--- @field filetype string|string[]

--- @param opts? RimeSetupOpts
function M.setup(opts)
  opts = opts or {}
  local filetypes = opts and opts.filetype or { "*" }
  if type(filetypes) == "string" then
    opts.filetype = { filetypes }
  end
  local configs = require("lspconfig.configs")
  vim.g.rclone_sync_rime = false
  if Utils.is_remote() and vim.fn.executable("rclone") == 1 then
    vim.g.rclone_sync_rime = true
    vim.g.rclone_rime_remote_path = "od:webdav/rime"
    vim.g.rclone_rime_local_path = vim.fn.expand("~/rclone/rime")
  end
  configs.rime_ls = {
    default_config = {
      name = "rime_ls",
      cmd = { "rime_ls" },
      filetypes = opts.filetype,
      single_file_support = true,
    },
    settings = {},
  }
end

return M
