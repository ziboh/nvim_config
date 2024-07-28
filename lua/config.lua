local utils = require "utils"
local get_icon = utils.get_icon

local diagnostics_default_config = {
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = get_icon "DiagnosticError",
      [vim.diagnostic.severity.HINT] = get_icon "DiagnosticHint",
      [vim.diagnostic.severity.WARN] = get_icon "DiagnosticWarn",
      [vim.diagnostic.severity.INFO] = get_icon "DiagnosticInfo",
    },
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focused = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
  -- TODOvm: remove check when dropping support for neovim v0.10
  jump = vim.fn.has "nvim-0.11" == 1 and { float = true } or nil,
}

local diagnostics_config = {
  -- diagnostics off
  [0] = vim.tbl_deep_extend(
    "force",
    diagnostics_default_config,
    { underline = false, signs = false, update_in_insert = false }
  ) --[[@as vim.diagnostic.Opts]],
  -- status only
  vim.tbl_deep_extend("force", diagnostics_default_config, { signs = false }),
  -- virtual text off, signs on
  -- vim.tbl_deep_extend("force", diagnostics_default_config, { virtual_text = false }),
  -- all diagnostics on
  diagnostics_default_config,
}

local ensure_installed_lspconfig = {
  "pyright",
  "lua_ls",
  "bashls",
  "taplo",
  "clangd",
  "rust_analyzer",
  "vtsls",
  "volar",
  "eslint",
  "html",
  "cssls",
  "emmet_language_server",
  "svelte",
  "yamlls",
}
local ensure_installed_dap = { "codelldb", "python" }
local ignore_setup_lspconfig =
  { "bashls", "rust_analyzer", "tsserver", "volar", "vtsls", "emmet_language_server", "cssls", "html" }

return {
  diagnostics = {
    diagnostics_config = diagnostics_config,
    diagnostics_mode = 2,
  },
  lsp = {
    ensure_installed_lspconfig = ensure_installed_lspconfig,
    ensurer_installed_dap = ensure_installed_dap,
    ignore_setup_lspconfig = ignore_setup_lspconfig,
  },
}
