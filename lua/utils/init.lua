--- @class UserUtils: LazyUtilCore
--- @field icons utils.icons
--- @field ui utils.ui
--- @field cmp utils.cmp
--- @field lsp utils.lsp
--- @field pick utils.pick
--- @field rime utils.rime
--- @field toggle utils.toggle
--- @field mini utils.mini
--- @field root utils.root
local M = {}

M.user_terminals = {}

setmetatable(M, {
  __index = function(t, k)
    local LazyUtil = require("lazy.core.util")
    if LazyUtil[k] then
      return LazyUtil[k]
    end
    t[k] = require("utils." .. k)
    return t[k]
  end,
})

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

M.which_key_queue = {}

--- Insert one or more values into a list like table and maintain that you do not insert non-unique values (THIS MODIFIES `dst`)
---@param dst any[]|nil The list like table that you want to insert into
---@param src any[] Values to be inserted
---@return any[] # The modified list like table
function M.list_insert_unique(dst, src)
  if not dst then
    dst = {}
  end
  -- TODO: remove check after dropping support for Neovim v0.9
  assert(vim.islist(dst), "Provided table is not a list like table")
  local added = {}
  for _, val in ipairs(dst) do
    added[val] = true
  end
  for _, val in ipairs(src) do
    if not added[val] then
      table.insert(dst, val)
      added[val] = true
    end
  end
  return dst
end

--- Get the first worktree that a file belongs to
---@param file string? the file to check, defaults to the current file
---@param worktrees table<string, string>[]? an array like table of worktrees with entries `toplevel` and `gitdir`, default retrieves from `vim.g.git_worktrees`
---@return table<string, string>|nil # a table specifying the `toplevel` and `gitdir` of a worktree or nil if not found
function M.file_worktree(file, worktrees)
  worktrees = worktrees or vim.g.git_worktrees
  if not worktrees then
    return
  end
  file = file or vim.fn.expand("%") --[[@as string]]
  if file ~= "" then
    for _, worktree in ipairs(worktrees) do
      if
        M.cmd({
          "git",
          "--work-tree",
          worktree.toplevel,
          "--git-dir",
          worktree.gitdir,
          "ls-files",
          "--error-unmatch",
          file,
        }, false)
      then
        return worktree
      end
    end
  else
    for _, worktree in ipairs(worktrees) do
      if vim.uv.cwd() == worktree.toplevel then
        return worktree
      end
    end
  end
end

function M.is_loaded(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
function M.extend_tbl(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end

--- Trigger an AstroNvim user event
---@param event string|vim.api.keyset_exec_autocmds The event pattern or full autocmd options (pattern always prepended with "Astro")
---@param instant boolean? Whether or not to execute instantly or schedule
function M.event(event, instant)
  if type(event) == "string" then
    event = { pattern = event }
  end
  event = M.extend_tbl({ modeline = false }, event)
  event.pattern = "Lazy" .. event.pattern
  if instant then
    vim.api.nvim_exec_autocmds("User", event)
  else
    vim.schedule(function()
      vim.api.nvim_exec_autocmds("User", event)
    end)
  end
end

--- Run a shell command and capture the output and if the command succeeded or failed
---@param cmd string|string[] The terminal command to execute
---@param show_error? boolean Whether or not to show an unsuccessful command as an error to the user
---@return string|nil # The result of a successfully executed command or nil
function M.cmd(cmd, show_error)
  if type(cmd) == "string" then
    cmd = { cmd }
  end
  if vim.fn.has("win32") == 1 then
    cmd = vim.list_extend({ "cmd.exe", "/C" }, cmd)
  end
  local result = vim.fn.system(cmd)
  local success = vim.api.nvim_get_vvar("shell_error") == 0
  if not success and (show_error == nil or show_error) then
    Snacks.notify.error(("Error running command %s\nError message:\n%s"):format(table.concat(cmd, " "), result))
  end
  return success and assert(result):gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists.
-- It will also set `silent` to true by default.
function M.safe_keymap_set(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  local modes = type(mode) == "string" and { mode } or mode

  ---@param m string
  modes = vim.tbl_filter(function(m)
    return not (keys.have and keys:have(lhs, m))
  end, modes)

  -- do not create the keymap if a lazy keys handler exists
  if #modes > 0 then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      ---@diagnostic disable-next-line: no-unknown
      opts.remap = nil
    end
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

--- --- Get an icon from `lspkind` if it is available and return it.
--- ---@param kind string The kind of icon in `lspkind` to retrieve.
--- ---@return string icon.
--- function M.get_icon(kind, padding, no_fallback)
---   if not vim.g.icons_enabled and no_fallback then
---     return ""
---   end
---   local icon_pack = vim.g.icons_enabled and "icons" or "text_icons"
---   if next(M[icon_pack]) == nil then
---     M.icons = require("icons.nerd_font")
---     M.text_icons = require("icons.text")
---   end
---   local icon = M[icon_pack] and M[icon_pack][kind]
---   return icon and icon .. string.rep(" ", padding or 0) or ""
--- end

--- Get an empty table of mappings with a key for each map mode.
---@return table<string,table> # a table with entries for each map mode.
function M.get_mappings_template()
  local maps = {}
  for _, mode in ipairs({ "", "n", "v", "x", "s", "o", "!", "i", "l", "c", "t" }) do
    maps[mode] = {}
  end
  if vim.fn.has("nvim-0.10.0") == 1 then
    for _, abbr_mode in ipairs({ "ia", "ca", "!a" }) do
      maps[abbr_mode] = {}
    end
  end
  return maps
end

---@param name string
---@param path string?
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  path = path and "/" .. path or ""
  return plugin and (plugin.dir .. path)
end

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

--- Sends a notification with 'Neovim' as default title.
--- Same as using vim.notify, but it saves us typing the title every time.
---@param msg string The notification body.
---@param opts? table The nvim-notify options to use (:help notify-options).
function M.notify(msg, opts)
  opts = opts or {}
  local level = opts.levels or vim.log.levels.INFO
  vim.schedule(function()
    vim.notify(msg, level, vim.tbl_deep_extend("force", { title = "Neovim" }, opts or {}))
  end)
end

--- Set a table of mappings.
---
--- This wrapper prevents a  boilerplate code, and takes care of `whichkey.nvim`.
---@param map_table table A nested table where the first key is the vim mode,
---                       the second key is the key to map, and the value is
---                       the function to set the mapping to.
---@param base? table A base set of options to set on every keybinding.
function M.set_mappings(map_table, base)
  -- iterate over the first keys for each mode
  base = base or {}
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd = options
        local keymap_opts = base
        if type(options) == "table" then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
          keymap_opts[1] = nil
        end
        if not cmd or keymap_opts.name then -- if which-key mapping, queue it
          -- if not keymap_opts.name then keymap_opts.name = keymap_opts.desc end
          if not M.which_key_queue[mode] then
            M.which_key_queue[mode] = {}
          end
          M.which_key_queue[mode][keymap] = keymap_opts
        else -- if not which-key mapping, set it
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
  -- if which-key is loaded already, register
  if package.loaded["which-key"] then
    M.which_key_register()
  end
end

--- Register queued which-key mappings.
function M.which_key_register()
  if M.which_key_queue then
    local wk_avail, wk = pcall(require, "which-key")
    local spec = {}
    if wk_avail then
      for mode, opts in pairs(M.which_key_queue) do
        for k, v in pairs(opts) do
          local result = { k, mode = mode }
          table.insert(spec, vim.tbl_extend("force", v, result))
        end
      end
      M.which_key_queue = nil
      wk.add(spec)
    end
  end
end

function M.on_load(plugins, load_op)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  if lazy_config_avail then
    if type(plugins) == "string" then
      plugins = { plugins }
    end
    if type(load_op) ~= "function" then
      local to_load = type(load_op) == "string" and { load_op } or load_op --[=[@as string[]]=]
      load_op = function()
        require("lazy").load({ plugins = to_load })
      end
    end

    for _, plugin in ipairs(plugins) do
      if vim.tbl_get(lazy_config.plugins, plugin, "_", "loaded") then
        vim.schedule(load_op)
        return
      end
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      desc = ("A function to be ran when one of these plugins runs: %s"):format(vim.inspect(plugins)),
      callback = function(args)
        if vim.tbl_contains(plugins, args.data) then
          load_op()
          return true
        end
      end,
    })
  end
end

--- 判断字符串是否在表中
---@param table any
---@param searchString any
---@return boolean
function M.stringInTable(table, searchString)
  for _, value in ipairs(table) do
    if value == searchString then
      return true
    end
  end
  return false
end

function M.is_image(file_path)
  -- 创建一个图片后缀的表
  local image_suffix = { ".jpg", ".jpeg", ".png", ".gif", ".bmp" }
  -- 获取文件后缀
  local file_suffix = string.lower(string.sub(file_path, -4))
  -- 判断文件后缀是否在图片后缀表中
  for _, v in ipairs(image_suffix) do
    if file_suffix == v then
      return true
    end
  end
  return false
end

--- Check if a buffer is valid
---@param bufnr integer? The buffer to check, default to current buffer
---@return boolean # Whether the buffer is valid or not
function M.is_valid(bufnr)
  if not bufnr then
    bufnr = 0
  end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

--- Helper function to power a save confirmation prompt before `mini.bufremove`
---@param func fun(bufnr:integer,force:boolean?) The function to execute if confirmation is passed
---@param bufnr integer The buffer to close or the current buffer if not provided
---@param force? boolean Whether or not to foce close the buffers or confirm changes (default: false)
---@return boolean? # new value for whether to force save, `nil` to skip saving
local function mini_confirm(func, bufnr, force)
  if not force and vim.bo[bufnr].modified then
    local bufname = vim.fn.expand("%")
    local empty = bufname == ""
    if empty then
      bufname = "Untitled"
    end
    local confirm = vim.fn.confirm(('Save changes to "%s"?'):format(bufname), "&Yes\n&No\n&Cancel", 1, "Question")
    if confirm == 1 then
      if empty then
        return
      end
      vim.cmd.write()
    elseif confirm == 2 then
      force = true
    else
      return
    end
  end
  func(bufnr, force)
end

--- Close a given buffer
---@param bufnr? integer The buffer to close or the current buffer if not provided
---@param force? boolean Whether or not to foce close the buffers or confirm changes (default: false)
function M.close(bufnr, force)
  if not bufnr or bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end
  if M.has("mini.bufremove") and M.is_valid(bufnr) and #vim.t.bufs > 1 then
    mini_confirm(require("mini.bufremove").delete, bufnr, force)
  else
    local buftype = vim.bo[bufnr].buftype
    vim.cmd(("silent! %s %d"):format((force or buftype == "terminal") and "bdelete!" or "confirm bdelete", bufnr))
  end
end
---
---
function M.is_wsl()
  if os.getenv("WSL_DISTRO_NAME") then
    return true
  else
    return false
  end
end

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if opts.warn and not vim.uv.fs_stat(ret) and not require("lazy.core.config").headless() then
    M.warn(
      ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(pkg, path)
    )
  end
  return ret
end

---@param msg string|string[]
---@param opts? LazyNotifyOpts
function M.error(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.ERROR
  M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? LazyNotifyOpts
function M.info(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.INFO
  M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? LazyNotifyOpts
function M.warn(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.WARN
  M.notify(msg, opts)
end

---@param msg string|table
---@param opts? LazyNotifyOpts
function M.debug(msg, opts)
  if not require("lazy.core.config").options.debug then
    return
  end
  opts = opts or {}
  if opts.title then
    opts.title = "lazy.nvim: " .. opts.title
  end
  if type(msg) == "string" then
    M.notify(msg, opts)
  else
    opts.lang = "lua"
    M.notify(vim.inspect(msg), opts)
  end
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

--- 将 Lua table 转换为字符串表示形式
--- @param t table 要转换的 table
--- @param indent? string 可选参数，用于控制缩进（默认为空字符串）
--- @param visited? table 可选参数，用于记录已处理的 table，避免循环引用
--- @return string 返回 table 的字符串表示形式
function M.tableToString(t, indent, visited)
  -- 初始化缩进和已访问表
  indent = indent or ""
  visited = visited or {}
  -- 如果已经访问过这个表，直接返回
  if visited[t] then
    return indent .. "{...}"
  end

  -- 标记当前表为已访问
  visited[t] = true

  -- 开始构建字符串
  local result = indent .. "{\n"
  local newIndent = indent .. "  "

  -- 遍历表中的每个键值对
  for k, v in pairs(t) do
    -- 处理键
    local keyStr
    if type(k) == "string" then
      keyStr = '["' .. k .. '"]'
    else
      keyStr = "[" .. tostring(k) .. "]"
    end

    -- 处理值
    local valueStr
    if type(v) == "table" then
      valueStr = M.tableToString(v, newIndent, visited)
    elseif type(v) == "string" then
      valueStr = '"' .. v .. '"'
    else
      valueStr = tostring(v)
    end

    -- 将键值对添加到结果中
    result = result .. newIndent .. keyStr .. " = " .. valueStr .. ",\n"
  end

  -- 结束构建字符串
  result = result .. indent .. "}"
  return result
end

--- 将 Lua table 转换为字符串表示形式
--- @param t table 要转换的 table
--- @param indent? string 可选参数，用于控制缩进（默认为空字符串）
--- @param visited? table 可选参数，用于记录已处理的 table，避免循环引用
function M.PrintTable(t, indent, visited)
  vim.notify(M.tableToString(t, indent, visited))
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
  end
end

function M.is_remote()
  if vim.env.SSH_TTY ~= nil or (vim.env.WEZTERM_EXECUTABLE ~= nil and vim.env.XDG_RUNTIME_DIR ~= nil) then
    return true
  else
    return false
  end
end

function M.lazygit_args()
  local worktree = M.file_worktree()
  local args = nil
  if worktree then
    args = { "-w", worktree.toplevel, "-g", worktree.gitdir }
  else
    args = { "-w", Utils.root() }
  end
  return args
end

--- @param keys string
--- @param mode string
function M.feedkeys(keys, mode)
  -- 将按键序列转换为 Neovim 内部格式
  local termcodes = vim.api.nvim_replace_termcodes(keys, true, true, true)
  -- Send the converted key sequence to Neovim's input buffer.
  vim.api.nvim_feedkeys(termcodes, mode, false)
end

---@param value any
---@param list any[]
function M.value_in_list(value, list)
  for _, v in ipairs(list) do
    if v == value then
      return true
    end
  end
end

function M.is_port_in_use(port)
  local command
  local os_name = vim.loop.os_uname().sysname

  -- 根据操作系统选择不同的命令
  if os_name == "Linux" then
    -- 只查找 LISTEN 状态的端口，使用更精确的匹配
    command = string.format("ss -tuln state listening | grep ':\\b%d\\b'", port)
  elseif os_name == "Windows_NT" then
    -- 在 Windows 下专门查找 LISTENING 状态的端口
    command = string.format('netstat -an | findstr /R /C:":%d.*LISTENING"', port)
  else
    print("Unsupported operating system")
    return false
  end

  -- 执行命令并获取输出
  local handle = io.popen(command)
  if not handle then
    print("Failed to execute command")
    return false
  end

  local result = handle:read("*a")
  local success, _ = handle:close()

  if not success then
    print("Failed to close handle")
    return false
  end

  -- 判断输出是否包含端口信息
  return result and result:match("%S") ~= nil
end

-- 创建一个函数来关闭指定端口的进程
function M.win_close_port(port)
  -- 获取占用端口的进程信息
  local handle = io.popen(string.format("netstat -ano | findstr :%d", port))
  local result = ""
  if handle ~= nil then
    result = handle:read("*a")
    handle:close()
  end

  -- 如果没有找到进程
  if result == "" then
    print("No process found using port " .. port)
    return
  end

  -- 从结果中提取 PID
  -- netstat 输出格式类似：TCP    0.0.0.0:9928    0.0.0.0:0    LISTENING    1234
  local pid = result:match("%d+%s*$"):gsub("%s+", "")

  if pid then
    -- 使用 taskkill 命令关闭进程
    local cmd = string.format("taskkill /PID %s /F", pid)
    local kill_handle = io.popen(cmd)
    if kill_handle ~= nil then
      local kill_result = kill_handle:read("*a"):gsub("%s+$", "")
      kill_handle:close()
      Utils.info(kill_result)
    end
  else
    print("Could not find PID for port " .. port)
  end
end

function M.get_wsl_router_ip()
  return string.gsub(vim.fn.system("ip route | awk '/default/ { print $3 }' "), "^%s*(.-)%s*$", "%1")
end

function M.get_visual_selection()
  -- 检查是否在可视模式
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    return nil
  end

  -- 获取开始和结束位置
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")

  -- 行和列是从1开始计数的
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]

  -- 确保开始位置在结束位置之前
  if start_line > end_line then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end

  return {
    start_line = start_line,
    start_col = start_col,
    end_line = end_line,
    end_col = end_col,
    mode = mode, -- 添加模式信息
  }
end

function M.GetVisualSelection()
  vim.api.nvim_input("<Esc>")
  local pos = M.get_visual_selection()

  if pos == nil then
    return
  end

  -- 获取选中的行
  local start_line = pos.start_line
  local end_line = pos.end_line
  local lines = {}

  if pos.mode == "V" then
    -- 行可视模式：直接获取整行
    for line_num = start_line, end_line do
      local line = vim.fn.getline(line_num)
      table.insert(lines, line)
    end
  else
    -- 字符可视模式和块可视模式
    for line_num = start_line, end_line do
      local line = vim.fn.getline(line_num)

      -- 计算开始和结束的列位置
      local start_col = line_num == start_line and pos.start_col or 1
      local end_col = line_num == end_line and pos.end_col or #line

      -- 将列位置转换为字节索引
      local start_byte = vim.fn.byteidx(line, start_col - 1) + 1
      local end_byte = vim.fn.byteidx(line, end_col)

      -- 如果end_byte为nil（发生在行尾），使用字符串长度
      end_byte = end_byte or #line

      -- 提取这一行选中的部分
      local selected_text = string.sub(line, start_byte, end_byte)
      table.insert(lines, selected_text)
    end
  end

  -- 将所有行组合成一个字符串
  return table.concat(lines, "\n")
end

-- Determine if the character is a Chinese character
function M.detect_language(str)
  local chinese_count = 0
  local english_count = 0

  local i = 1
  while i <= #str do
    local byte = string.byte(str, i)
    if byte == nil then
      break
    end

    if byte >= 0xE0 and byte <= 0xEF then
      -- 中文字符（UTF-8 编码占3字节）
      chinese_count = chinese_count + 1
      i = i + 3
    elseif byte >= 0x20 and byte <= 0x7E then
      -- ASCII 可显示字符（英文、数字、符号等）
      english_count = english_count + 1
      i = i + 1
    else
      -- 其他字符
      i = i + 1
    end
  end

  return chinese_count > english_count and "Chinese" or "English"
end

return M
