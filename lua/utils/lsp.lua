---@class lazyvim.util.lsp
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

function M.on_attach(client, bufnr)
  vim.keymap.set("n", "<leader>fd", function()
    require("fzf-lua").diagnostics_document()
  end, { noremap = true, silent = true, buffer = bufnr, desc = "Lists All Diagnostics " })
  if vim.lsp.inlay_hint and client.supports_method("textDocument/inlayHint") then
    vim.keymap.set("n", "<leader>uH", function()
      if vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }) then
        vim.lsp.inlay_hint.enable(false, { bufnr = 0 })
      else
        vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
      end
    end, { noremap = true, silent = true, buffer = bufnr, desc = "Toggle Lsp inlay hints(buffer)" })

    vim.keymap.set("n", "<leader>uh", function()
      if vim.lsp.inlay_hint.is_enabled({}) then
        vim.lsp.inlay_hint.enable(false)
      else
        vim.lsp.inlay_hint.enable(true)
      end
    end, { noremap = true, silent = true, buffer = bufnr, desc = "Toggle Lsp inlay hints(global)" })
  end

  if client.supports_method("textDocument/declaration") then
    vim.keymap.set(
      "n",
      "gD",
      vim.lsp.buf.declaration,
      { noremap = true, silent = true, buffer = bufnr, desc = "Lsp declaration" }
    )
  end

  if client.supports_method("textDocument/definition") then
    vim.keymap.set(
      "n",
      "gd",
      vim.lsp.buf.definition,
      { noremap = true, silent = true, buffer = bufnr, desc = "Go to Definition" }
    )
  end

  if client.supports_method("textDocument/typeDefinition") then
    vim.keymap.set(
      "n",
      "<leader>D",
      vim.lsp.buf.type_definition,
      { noremap = true, silent = true, buffer = bufnr, desc = "Type definition" }
    )
  end

  if client.supports_method("textDocument/hover") then
    vim.keymap.set(
      "n",
      "<leader>h",
      vim.lsp.buf.hover,
      { noremap = true, silent = true, buffer = bufnr, desc = "Hover" }
    )
    vim.keymap.set(
      "n",
      "<leader>lh",
      vim.lsp.buf.hover,
      { noremap = true, silent = true, buffer = bufnr, desc = "Hover" }
    )
  end

  if client.supports_method("textDocument/implementation") then
    vim.keymap.set(
      "n",
      "gi",
      vim.lsp.buf.implementation,
      { noremap = true, silent = true, buffer = bufnr, desc = "lsp implementation" }
    )
  end

  if client.supports_method("textDocument/signature_help") then
    vim.keymap.set(
      "n",
      "<leader>lh",
      vim.lsp.buf.signature_help,
      { noremap = true, silent = true, buffer = bufnr, desc = "Signature help" }
    )
  end

  if client.supports_method("textDocument/rename") then
    vim.keymap.set("n", "<leader>lr", ":IncRename ", { noremap = true, silent = true, buffer = bufnr, desc = "Rename" })
  end
  if client.supports_method("testDocument/codeAction") then
    vim.keymap.set(
      "n",
      "<leader>la",
      vim.lsp.buf.code_action,
      { noremap = true, silent = true, buffer = bufnr, desc = "Code Action" }
    )
  end

  if client.supports_method("textDocument/references") then
    vim.keymap.set(
      "n",
      "<leader>lR",
      vim.lsp.buf.references,
      { noremap = true, silent = true, buffer = bufnr, desc = "References" }
    )
  end
end

function M.rust_on_attach(client, bufnr)
  M.on_attach(client, bufnr)

  if client.server_capabilities.code_lens or client.server_capabilities.codeLensProvider then
    local group = vim.api.nvim_create_augroup("LSPRefreshLens", { clear = true })

    -- Code Lens
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
      desc = "Auto show code lenses",
      buffer = bufnr,
      callback = function()
        vim.lsp.codelens.refresh({ bufnr = 0 })
      end,
      group = group,
    })
  end
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
return M
