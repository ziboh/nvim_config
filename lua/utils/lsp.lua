---@class utils.lsp
local M = {}
---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: lsp.Client):boolean}

---@param opts? lsp.Client.filter
function M.get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client vim.lsp.Client
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function M.on_attach(on_attach, name)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

function M.get_codelldb()
  local adapter
  local success, package = pcall(function()
    return require("mason-registry").get_package("codelldb")
  end)
  local cfg = require("rustaceanvim.config")
  if success then
    local package_path = package:get_install_path()
    local codelldb_path = package_path .. "/codelldb"
    local liblldb_path = package_path .. "/extension/lldb/lib/liblldb"

    -- the path in windows is different
    ---@diagnostic disable-next-line:undefined-field
    if Utils.is_win() then
      codelldb_path = package_path .. "\\extension\\adapter\\codelldb.exe"
      liblldb_path = package_path .. "\\extension\\lldb\\bin\\liblldb.dll"
    else
      -- the liblldb extension is .so for linux and .dylib for macos
      ---@diagnostic disable-next-line:undefined-field
      liblldb_path = liblldb_path .. (vim.uv.os_uname().sysname == "Linux" and ".so" or ".dylib")
    end
    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
  else
    ---@diagnostic disable-next-line:missing-parameter
    adapter = cfg.get_codelldb_adapter()
  end
  return adapter
end

function M.get_rust_anlayzer()
  local lsp_server = "rust-anlayzer"
  if require("mason-registry").has_package("rust-analyzer") and vim.g.rust_analyzer_mason then
    ---@diagnostic disable-next-line:undefined-field
    if vim.uv.os_uname().sysname:find("Windows") ~= nil then
      lsp_server = vim.fn.stdpath("data") .. "\\mason\\bin\\rust-analyzer.cmd"
      ---@diagnostic disable-next-line:undefined-field
    elseif vim.uv.os_uname().sysname == "Linux" then
      lsp_server = vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer"
    end
  end
  return lsp_server
end

function M.rime_on_attach(client, _)
  local mapped_punc = {
    [","] = "，",
    ["."] = "。",
    [":"] = "：",
    ["?"] = "？",
    ["\\"] = "、",
    -- FIX: can not work now
    [";"] = "；",
  }

  local feedkeys = Utils.feedkeys

  local map_set = Utils.safe_keymap_set
  local map_del = vim.keymap.del

  vim.api.nvim_create_user_command("RimeToggle", function()
    client.request("workspace/executeCommand", { command = "rime-ls.toggle-rime" }, function(_, result, ctx, _)
      if vim.g.rime_enabled then
        for k, _ in pairs(mapped_punc) do
          map_del({ "i" }, k .. "<space>")
        end
      else
        for k, v in pairs(mapped_punc) do
          map_set({ "i" }, k .. "<space>", function()
            if
              Utils.rime.rime_ls_disabled({
                line = vim.api.nvim_get_current_line(),
                cursor = vim.api.nvim_win_get_cursor(0),
              })
            then
              feedkeys(k .. "<space>", "n")
            else
              feedkeys(v, "n")
            end
          end)
        end
      end
      if ctx.client_id == client.id then
        vim.g.rime_enabled = result
        if result then
          Utils.info("Rime Enabled", { title = "Rime", timeout = 3000 })
        else
          Utils.info("Rime Disabled", { title = "Rime", timeout = 3000 })
        end
      end
    end)
  end, { nargs = 0 })

  -- Toggle rime
  -- This will toggle Chinese punctuations too
  map_set({ "n", "i" }, "<c-a-]>", function()
    -- We must check the status before the toggle
    vim.cmd("RimeToggle")
  end)
end

---@type table<string, table<vim.lsp.Client, table<number, boolean>>>
M._supports_method = {}

function M.setup()
  local register_capability = vim.lsp.handlers["client/registerCapability"]
  vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    ---@diagnostic disable-next-line: no-unknown
    local ret = register_capability(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for buffer in pairs(client.attached_buffers) do
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspDynamicCapability",
          data = { client_id = client.id, buffer = buffer },
        })
      end
    end
    return ret
  end
  M.on_attach(M._check_methods)
  M.on_dynamic_capability(M._check_methods)
end

---@param client vim.lsp.Client
function M._check_methods(client, buffer)
  -- don't trigger on invalid buffers
  if not vim.api.nvim_buf_is_valid(buffer) then
    return
  end
  -- don't trigger on non-listed buffers
  if not vim.bo[buffer].buflisted then
    return
  end
  -- don't trigger on nofile buffers
  if vim.bo[buffer].buftype == "nofile" then
    return
  end
  for method, clients in pairs(M._supports_method) do
    clients[client] = clients[client] or {}
    if not clients[client][buffer] then
      if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
        clients[client][buffer] = true
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspSupportsMethod",
          data = { client_id = client.id, buffer = buffer, method = method },
        })
      end
    end
  end
end

---@param fn fun(client:vim.lsp.Client, buffer):boolean?
---@param opts? {group?: integer}
function M.on_dynamic_capability(fn, opts)
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspDynamicCapability",
    group = opts and opts.group or nil,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client then
        return fn(client, buffer)
      end
    end,
  })
end

---@param method string
---@param fn fun(client:vim.lsp.Client, buffer)
function M.on_supports_method(method, fn)
  M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspSupportsMethod",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client and method == args.data.method then
        return fn(client, buffer)
      end
    end,
  })
end

---@return _.lspconfig.options
function M.get_config(server)
  local configs = require("lspconfig.configs")
  return rawget(configs, server)
end

---@return {default_config:lspconfig.Config}
function M.get_raw_config(server)
  local ok, ret = pcall(require, "lspconfig.configs." .. server)
  if ok then
    return ret
  end
  return require("lspconfig.server_configurations." .. server)
end

function M.is_enabled(server)
  local c = M.get_config(server)
  return c and c.enabled ~= false
end

---@param server string
---@param cond fun( root_dir, config): boolean
function M.disable(server, cond)
  local util = require("lspconfig.util")
  local def = M.get_config(server)
  ---@diagnostic disable-next-line: undefined-field
  def.document_config.on_new_config = util.add_hook_before(def.document_config.on_new_config, function(config, root_dir)
    if cond(root_dir, config) then
      config.enabled = false
    end
  end)
end

M.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler

---@param opts LspCommand
function M.execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }
  if opts.open then
    require("trouble").open({
      mode = "lsp_command",
      params = params,
    })
  else
    return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
  end
end

function M.install_ahk2_lsp(callback)
  -- 获取数据目录路径
  local install_dir = vim.fn.stdpath("data") .. "/vscode-autohotkey2-lsp"

  -- 创建安装目录
  vim.fn.mkdir(install_dir, "p")

  -- 保存当前目录
  local current_dir = vim.fn.getcwd()
  vim.fn.chdir(install_dir)

  -- 下载安装脚本
  local install_script = install_dir .. "/install.js"
  local download_cmd = {
    "curl.exe",
    "-L",
    "-o",
    install_script,
    "https://raw.githubusercontent.com/thqby/vscode-autohotkey2-lsp/main/tools/install.js",
  }

  -- 异步执行下载
  vim.fn.jobstart(download_cmd, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.schedule(function()
          Utils.error("Failed to download install script")
          vim.fn.chdir(current_dir)
          if callback then
            callback(false)
          end
        end)
        return
      end

      -- 异步执行安装脚本
      vim.fn.chdir(install_dir)
      vim.fn.jobstart({ "node", "install.js" }, {
        on_exit = function(_, install_code)
          vim.schedule(function()
            vim.fn.chdir(current_dir)
            if install_code == 0 then
              Utils.info("AutoHotkey 2 LSP installed successfully!")
              if callback then
                callback(true)
              end
            else
              Utils.error("Failed to run install script")
              if callback then
                callback(false)
              end
            end
          end)
        end,
      })
    end,
  })
end

return M
