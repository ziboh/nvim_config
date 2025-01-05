local utils = require("utils")
local get_icon = utils.get_icon

local diagnostics_config = {
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = get_icon("DiagnosticError"),
      [vim.diagnostic.severity.HINT] = get_icon("DiagnosticHint"),
      [vim.diagnostic.severity.WARN] = get_icon("DiagnosticWarn"),
      [vim.diagnostic.severity.INFO] = get_icon("DiagnosticInfo"),
    },
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  severity = {
    min = vim.diagnostic.severity.ERROR,
    max = vim.diagnostic.severity.HINT,
  },
  float = {
    focused = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
  -- TODOvm: remove check when dropping support for neovim v0.10
  jump = { float = true },
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
  "powershell_es",
  "jsonls",
}
local ensure_installed_dap = { "codelldb", "python" }
local ignore_setup_lspconfig = { "rust_analyzer" }

---@type lspconfig.options
local servers = {
  emma_language_server = {
    ---@type table<string>
    filetypes = {
      "css",
      "eruby",
      "html",
      "javascriptreact",
      "less",
      "sass",
      "scss",
      "pug",
      "typescriptreact",
    },
    -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
    -- **Note:** only the options listed in the table are supported.
    init_options = {
      ---@type table<string, string>
      includeLanguages = {},
      --- @type string[]
      excludeLanguages = {},
      --- @type string[]
      extensionsPath = {},
      --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
      preferences = {},
      --- @type boolean Defaults to `true`
      showAbbreviationSuggestions = true,
      --- @type "always" | "never" Defaults to `"always"`
      showExpandedAbbreviation = "always",
      --- @type boolean Defaults to `false`
      showSuggestionsAsSnippets = false,
      --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
      syntaxProfiles = {},
      --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
      variables = {},
    },
  },
  bashls = {
    filetypes = { "sh", "bash", "zsh" },
  },
  volar = {
    init_options = {
      vue = {
        hybridMode = true,
      },
    },
  },
  vtsls = {
    complete_function_calls = true,
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        schemaStore = {
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },
  jsonls = {
    settings = {
      json = {
        format = {
          enable = true,
        },
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
}

return {
  diagnostics = {
    diagnostics_config = diagnostics_config,
    diagnostics_mode = 2,
  },
  lsp = {
    ensure_installed_lspconfig = ensure_installed_lspconfig,
    ensurer_installed_dap = ensure_installed_dap,
    ignore_setup_lspconfig = ignore_setup_lspconfig,
    servers = servers,
  },
}
