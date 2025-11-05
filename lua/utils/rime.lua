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
  local filetypes = (opts and opts.filetype) and opts.filetype or { "*" }
  if type(filetypes) == "string" then
    opts.filetype = { filetypes }
  end
  local port = Utils.is_win() and 9528 or 9527
  local rime_started = false

  if not Utils.is_port_in_use(port) then
    vim.system({ "rime_ls", "--listen", "127.0.0.1:" .. port }, { detach = true })

    -- 等待 rime_ls 启动，最多等待 5 秒
    local max_attempts = 50 -- 5秒 = 50次 * 100毫秒
    local attempt = 0

    while attempt < max_attempts and not Utils.is_port_in_use(port) do
      vim.wait(100) -- 等待 100 毫秒
      attempt = attempt + 1
    end

    if Utils.is_port_in_use(port) then
      rime_started = true
    else
      vim.notify("rime_ls 启动超时，请检查是否已正确安装", vim.log.levels.WARN)
    end
  else
    rime_started = true
  end

  if rime_started then
    vim.lsp.config.rime_ls = {
      name = "rime_ls",
      cmd = vim.lsp.rpc.connect("127.0.0.1", port),
      filetypes = opts.filetype,
      single_file_support = true,
    }
  else
    vim.notify("未能启动 rime_ls，跳过 LSP 配置", vim.log.levels.WARN)
  end

  Utils.on_load("blink.cmp", function()
    require("blink.cmp.completion.list").show_emitter:on(function(event)
      if not vim.g.rime_enabled then
        return
      end
      local col = vim.fn.col(".") - 1
      if event.context.line:sub(col, col):match("%d") == nil then
        return
      end

      local rime_item_index = Utils.rime.get_n_rime_item_index(2, event.items)

      if #rime_item_index ~= 1 then
        return
      end

      vim.schedule(function()
        require("blink.cmp").accept({ index = rime_item_index[1] })
      end)
    end)
  end)
end

return M
