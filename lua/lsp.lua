local config = require "config"
local lspconfig = require "lspconfig"

-- See `:help vim.lsp.buf.inlay_hint` for documentation on the inlay_hint API
vim.lsp.inlay_hint.enable(true)
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.diagnostic.config(config.diagnostics.diagnostics_config[config.diagnostics.diagnostics_mode])
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  vim.keymap.set(
    "n",
    "<leader>fd",
    function() require("telescope.builtin").diagnostics() end,
    { noremap = true, silent = true, buffer = bufnr, desc = "Lists All Diagnostics " }
  )
  if vim.lsp.inlay_hint and client.supports_method "textDocument/inlayHint" then
    vim.keymap.set("n", "<leader>uH", function()
      if vim.lsp.inlay_hint.is_enabled { bufnr = 0 } then
        vim.lsp.inlay_hint.enable(false, { bufnr = 0 })
      else
        vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
      end
    end, { noremap = true, silent = true, buffer = bufnr, desc = "Toggle Lsp inlay hints(buffer)" })

    vim.keymap.set("n", "<leader>uh", function()
      if vim.lsp.inlay_hint.is_enabled {} then
        vim.lsp.inlay_hint.enable(false)
      else
        vim.lsp.inlay_hint.enable(true)
      end
    end, { noremap = true, silent = true, buffer = bufnr, desc = "Toggle Lsp inlay hints(global)" })
  end

  if client.supports_method "textDocument/declaration" then
    vim.keymap.set(
      "n",
      "gD",
      vim.lsp.buf.declaration,
      { noremap = true, silent = true, buffer = bufnr, desc = "Lsp declaration" }
    )
  end

  if client.supports_method "textDocument/definition" then
    vim.keymap.set(
      "n",
      "gd",
      vim.lsp.buf.definition,
      { noremap = true, silent = true, buffer = bufnr, desc = "Go to Definition" }
    )
  end

  if client.supports_method "textDocument/typeDefinition" then
    vim.keymap.set(
      "n",
      "<leader>D",
      vim.lsp.buf.type_definition,
      { noremap = true, silent = true, buffer = bufnr, desc = "Type definition" }
    )
  end

  if client.supports_method "textDocument/hover" then
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

  if client.supports_method "textDocument/implementation" then
    vim.keymap.set(
      "n",
      "gi",
      vim.lsp.buf.implementation,
      { noremap = true, silent = true, buffer = bufnr, desc = "lsp implementation" }
    )
  end

  if client.supports_method "textDocument/signature_help" then
    vim.keymap.set(
      "n",
      "<leader>lh",
      vim.lsp.buf.signature_help,
      { noremap = true, silent = true, buffer = bufnr, desc = "Signature help" }
    )
  end

  if client.supports_method "textDocument/rename" then
    vim.keymap.set(
      "n",
      "<leader>lr",
      vim.lsp.buf.rename,
      { noremap = true, silent = true, buffer = bufnr, desc = "Rename" }
    )
  end
  if client.supports_method "testDocument/codeAction" then
    vim.keymap.set(
      "n",
      "<leader>la",
      vim.lsp.buf.code_action,
      { noremap = true, silent = true, buffer = bufnr, desc = "Code Action" }
    )
  end

  if client.supports_method "textDocument/references" then
    vim.keymap.set(
      "n",
      "<leader>lR",
      vim.lsp.buf.references,
      { noremap = true, silent = true, buffer = bufnr, desc = "References" }
    )
  end
end

local rust_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  if client.server_capabilities.code_lens or client.server_capabilities.codeLensProvider then
    local group = vim.api.nvim_create_augroup("LSPRefreshLens", { clear = true })

    -- Code Lens
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
      desc = "Auto show code lenses",
      buffer = bufnr,
      callback = function() vim.lsp.codelens.refresh { bufnr = 0 } end,
      group = group,
    })
  end

  vim.keymap.set(
    "n",
    "<leader>lf",
    "<cmd>RustFmt<CR>",
    { noremap = true, silent = true, buffer = bufnr, desc = "Formatting" }
  )
  vim.keymap.set(
    "n",
    "<leader>h",
    "<cmd>RustLsp hover actions<CR>",
    { noremap = true, silent = true, buffer = bufnr, desc = "Hover actions" }
  )
end

local function get_dap_adapter()
  local adapter
  local success, package = pcall(function() return require("mason-registry").get_package "codelldb" end)
  local cfg = require "rustaceanvim.config"
  if success then
    local package_path = package:get_install_path()
    local codelldb_path = package_path .. "/codelldb"
    local liblldb_path = package_path .. "/extension/lldb/lib/liblldb"

    -- the path in windows is different
    if vim.fn.has "win32" then
      codelldb_path = package_path .. "\\extension\\adapter\\codelldb.exe"
      liblldb_path = package_path .. "\\extension\\lldb\\bin\\liblldb.dll"
    else
      -- the liblldb extension is .so for linux and .dylib for macos
      liblldb_path = liblldb_path .. (vim.fn.has "linux" and ".so" or ".dylib")
    end
    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
  else
    ---@diagnostic disable-next-line:missing-parameter
    adapter = cfg.get_codelldb_adapter()
  end
  return adapter
end
local function get_lspserver()
  local lsp_server = "rust-anlayzer"
  if require("mason-registry").has_package "rust-analyzer" then
    if vim.fn.has "win32" then lsp_server = vim.fn.stdpath "data" .. "\\mason\\bin\\rust-analyzer.cmd" end
  elseif vim.fn.has "linux" then
    lsp_server = vim.fn.stdpath "data" .. "/mason/bin/rust-analyzer"
  end
  return lsp_server
end

require("mason").setup()
require("mason-lspconfig").setup {
  -- A list of servers to automatically install if they're not already installed
  ensure_installed = config.lsp.ensure_installed_lspconfig,
}

require("mason-nvim-dap").setup {
  -- A list of servers to automatically install if they're not already installed
  ensure_installed = config.lsp.ensure_installed_dap,
}

local rustacean_logfile = vim.fn.tempname() .. "-rustacean.log"
vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
    test_executor = "toggleterm",
  },
  -- LSP configuration
  server = {
    on_attach = rust_on_attach,
    cmd = function() return { get_lspserver(), "--log-file", rustacean_logfile } end,

    ---@type string The path to the rust-analyzer log file.
    logfile = rustacean_logfile,
    default_settings = {
      -- rust-analyzer language server configuration
      ["rust-analyzer"] = {},
    },
  },
  -- DAP configuration
  dap = { adapter = get_dap_adapter() },
}

local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then return end

local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_ok then return end

local shfmt_config = null_ls.builtins.formatting.shfmt
shfmt_config.filetypes = { "sh", "zsh" }
mason_null_ls.setup {
  ensure_installed = {
    "black",
    "stylua",
    "shfmt",
  },
  automatic_installation = false,
  automatic_setup = true,
  handlers = {
    black = function(_, _) null_ls.register(null_ls.builtins.formatting.black) end,
    stylua = function(_, _) null_ls.register(null_ls.builtins.formatting.stylua) end,
    shfmt = function(_, _) null_ls.register(shfmt_config) end,
  },
}

null_ls.setup()

for _, lspc in pairs(config.lsp.ensure_installed_lspconfig) do
  for _, ignore_lsp in pairs(config.lsp.ignore_setup_lspconfig) do
    if lspc == ignore_lsp then goto continue end
  end
  lspconfig[lspc].setup {
    on_attach = on_attach,
  }
  ::continue::
end

lspconfig.bashls.setup {
  on_attach = on_attach,
  filetypes = { "sh", "zsh" },
}
