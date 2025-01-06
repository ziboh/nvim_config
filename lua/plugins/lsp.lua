return {
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },
  {
    "folke/neoconf.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    event = "User LazyFile",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      diagnostics_config = {
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = Utils.get_icon("DiagnosticError"),
            [vim.diagnostic.severity.HINT] = Utils.get_icon("DiagnosticHint"),
            [vim.diagnostic.severity.WARN] = Utils.get_icon("DiagnosticWarn"),
            [vim.diagnostic.severity.INFO] = Utils.get_icon("DiagnosticInfo"),
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
      },
      servers = {
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
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            yaml = {
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
            },
          },
        },
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.json.schemas or {},
              require("schemastore").json.schemas()
            )
          end,

          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
      ignore_setup_lspconfig = {
        "rust_analyzer",
      },
      ensure_installed_lspconfig = {
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
      },
    },
    config = function(_, opts)
      vim.lsp.inlay_hint.enable(true)
      vim.diagnostic.config(opts.diagnostics_config)
      require("mason-lspconfig").setup({
        ensure_installed = opts.ensure_installed_lspconfig,
      })

      local symbols = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
      for name, icon in pairs(symbols) do
        local hl = "DiagnosticSign" .. name
        vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
      end
      require("neoconf").setup()
      local capabilities = Utils.has("blink.cmp")
          and require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
        or vim.lsp.protocol.make_client_capabilities()
      if Utils.has("nvim-ufo") then
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }
      end

      local lspconfig = require("lspconfig")

      for _, lspc in pairs(opts.ensure_installed_lspconfig) do
        local should_continue = false
        for _, ignore_lsp in pairs(opts.ignore_setup_lspconfig) do
          if lspc == ignore_lsp then
            should_continue = true
            break -- 找到匹配项，跳出内部循环
          end
        end
        if not should_continue then -- 如果没有找到匹配项
          -- 如果有对应的 server 查看有没有一个 on_new_config 的函数
          if opts.servers[lspc] and opts.servers[lspc].on_new_config then
            opts.servers[lspc].on_new_config(opts.servers[lspc])
            opts.servers[lspc].on_new_config = nil
          end
          lspconfig[lspc].setup(vim.tbl_deep_extend("force", {
            capabilities = capabilities,
            on_attach = Utils.lsp.on_attach,
          }, opts.servers[lspc] and opts.servers[lspc] or {}))
        end
      end
    end,
  },
  {

    "zapling/mason-conform.nvim",
    event = "User LazyFile",
    opts = {},
    dependencies = {
      "stevearc/conform.nvim",
    },
  },
  {
    "stevearc/conform.nvim",
    event = "User LazyFile",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
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
        sh = { "shfmt" },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    keys = { { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {},
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>ls", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {},
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup({
        completion = {
          cmp = {
            enabled = true,
          },
          crates = {
            enabled = true, -- disabled by default
            max_results = 8, -- The maximum number of search results to display
            min_chars = 3, -- The minimum number of charaters to type before completions begin appearing
          },
        },
        null_ls = {
          enabled = false,
          name = "crates.nvim",
        },
      })
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    cofnig = function()
      local rustacean_logfile = vim.fn.tempname() .. "-rustacean.log"
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            replace_builtin_hover = false,
          },
        },
        -- LSP configuration
        server = {
          on_attach = Utils.lsp.rust_on_attach,
          cmd = function()
            return { Utils.lsp.get_rust_anlayzer(), "--log-file", rustacean_logfile }
          end,

          ---@type string The path to the rust-analyzer log file.
          logfile = rustacean_logfile,
        },
        -- DAP configuration
        dap = { adapter = Utils.lsp.get_codelldb() },
      }
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
    event = "Lspattach",
    config = function(_)
      require("clangd_extensions").setup({
        inlay_hints = {
          -- inline = vim.fn.has "nvim-0.10" == 1,
          inline = false,
          only_current_line = false,
          only_current_line_autocmd = { "CursorHold" },
          show_parameter_hints = true,
          parameter_hints_prefix = "<- ",
          other_hints_prefix = "=> ",
          max_len_align = false,
          max_len_align_padding = 1,
          right_align = false,
          right_align_padding = 7,
          highlight = "Comment",
          priority = 100,
        },
        ast = {
          role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
          },

          kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
          },

          highlights = {
            detail = "Comment",
          },
        },
        memory_usage = {
          border = "none",
        },
        symbol_info = {
          border = "none",
        },
      })
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = { "IncRename" },
    keys = {
      { "<leader>lr", ": IncRename", desc = "Rename" },
    },
    config = function()
      require("inc_rename").setup({ save_in_cmdline_history = false })
    end,
  },
  {
    "ziboh/vim-illuminate",
    event = "User LazyFile",
    opts = {
      delay = 200,
      min_count_to_highlight = 2,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
      should_enable = function(bufnr)
        return Utils.is_valid(bufnr) and not vim.b[bufnr].large_buf
      end,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#45475a" })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#45475a" })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#45475a" })
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "User LazyFile",
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "ghost",
        multilines = {
          enabled = true,
          always_show = true,
        },
      })
    end,
  },
  {
    "chrisgrieser/nvim-lsp-endhints",
    event = "LspAttach",
    opts = {
      label = {
        truncateAtChars = 40,
      },
    }, -- required, even if empty
  },
}
