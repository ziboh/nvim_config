return function()
  local config = require("config")
  vim.lsp.inlay_hint.enable(true)
  vim.diagnostic.config(config.diagnostics.diagnostics_config)
  vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#9993A7", bg = "None" })

  local symbols = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
  for name, icon in pairs(symbols) do
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
  end

  local on_attach = function(client, bufnr)
    vim.keymap.set("n", "<leader>fd", function()
      require("telescope.builtin").diagnostics()
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
      vim.keymap.set(
        "n",
        "<leader>lr",
        ":IncRename ",
        { noremap = true, silent = true, buffer = bufnr, desc = "Rename" }
      )
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

  local rust_on_attach = function(client, bufnr)
    on_attach(client, bufnr)

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

  local function get_dap_adapter()
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
  local function get_lspserver()
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

  require("mason").setup()

  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      javascript = { "prettierd" },
      css = { "prettierd" },
      html = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      javescroptreact = { "prettierd" },
      jsonc = { "prettierd" },
      vue = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      rust = { "rustfmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },
    },
  })

  require("mason-conform").setup()
  require("mason-lspconfig").setup({
    -- A list of servers to automatically install if they're not already installed
    ensure_installed = config.lsp.ensure_installed_lspconfig,
  })
  require("mason-nvim-dap").setup({
    -- A list of servers to automatically install if they're not already installed
    ensure_installed = config.lsp.ensurer_installed_dap,
  })

  local rustacean_logfile = vim.fn.tempname() .. "-rustacean.log"

  vim.g.rustaceanvim = {
    tools = {
      hover_actions = {
        replace_builtin_hover = false,
      },
    },
    -- LSP configuration
    server = {
      on_attach = rust_on_attach,
      cmd = function()
        return { get_lspserver(), "--log-file", rustacean_logfile }
      end,

      ---@type string The path to the rust-analyzer log file.
      logfile = rustacean_logfile,
    },
    -- DAP configuration
    dap = { adapter = get_dap_adapter() },
  }

  require("neotest").setup({
    adapters = {
      require("rustaceanvim.neotest"),
    },
  })

  require("neoconf").setup({})

  local capabilities = Utils.has("blink.cmp") and require("blink.cmp").get_lsp_capabilities(config.capabilities)
    or vim.lsp.protocol.make_client_capabilities()
  if Utils.has("nvim-ufo") then
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
  end

  local lspconfig = require("lspconfig")

  for _, lspc in pairs(config.lsp.ensure_installed_lspconfig) do
    local should_continue = false
    for _, ignore_lsp in pairs(config.lsp.ignore_setup_lspconfig) do
      if lspc == ignore_lsp then
        should_continue = true
        break -- 找到匹配项，跳出内部循环
      end
    end
    if not should_continue then -- 如果没有找到匹配项
      lspconfig[lspc].setup(vim.tbl_deep_extend("force", {
        capabilities = capabilities,
        on_attach = on_attach,
      }, config.lsp.servers[lspc] and config.lsp.servers[lspc] or {}))
    end
  end
end
