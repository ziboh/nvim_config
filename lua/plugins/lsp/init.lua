local biome_support = {
  -- https://biomejs.dev/internals/language-support/
  "astro",
  "css",
  "graphql",
  -- "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  -- "markdown",
  "svelte",
  "typescript",
  "typescriptreact",
  "vue",
  -- "yaml",
}

return {
  { "mason-org/mason-lspconfig.nvim", config = function() end },
  {
    "williamboman/mason.nvim",
    opts_extend = { "ensure_installed" },
    keys = { { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    opts = {
      github = {
        download_url_template = "https://ghfast.top/https://github.com/%s/releases/download/%s/%s",
      },
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "User LazyFile",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        opts = {},
      },
    },
    opts = {
      diagnostics = {
        virtual_text = {
          spacing = 4,
          source = "if_many",
          -- prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          prefix = "icons",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = Utils.icons.diagnostics.Error,
            [vim.diagnostic.severity.HINT] = Utils.icons.diagnostics.Hint,
            [vim.diagnostic.severity.WARN] = Utils.icons.diagnostics.Warn,
            [vim.diagnostic.severity.INFO] = Utils.icons.diagnostics.Info,
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
      inlay_hints = {
        enabled = true,
        exclude = {},
      },
      codelens = {
        enabled = false,
      },
      ---@type lspconfig.options
      servers = {
        -- configuration for all lsp servers
        ["*"] = {
          capabilities = {
            textDocument = {
              completion = {
                completionItem = {
                  commitCharactersSupport = true,
                },
              },
            },
          },
          keys = {
            {
              "<leader>ll",
              function()
                Snacks.picker.lsp_config()
              end,
              desc = "Lsp Info",
            },
            {
              "gd",
              vim.lsp.buf.definition,
              desc = "Goto Definition",
              has = "definition",
            },
            {
              "gr",
              vim.lsp.buf.references,
              desc = "References",
              nowait = true,
            },
            { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
            { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
            { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
            {
              "<leader>h",
              function()
                return vim.lsp.buf.hover()
              end,
              desc = "Hover",
            },
            {
              "K",
              function()
                return vim.lsp.buf.hover()
              end,
              desc = "Hover",
            },
            {
              "<leader>lh",
              function()
                return vim.lsp.buf.signature_help()
              end,
              desc = "Signature Help",
              has = "signatureHelp",
            },
            {
              "<c-k>",
              function()
                return vim.lsp.buf.signature_help()
              end,
              mode = "i",
              desc = "Signature Help",
              has = "signatureHelp",
            },
            {
              "<leader>la",
              vim.lsp.buf.code_action,
              desc = "Code Action",
              mode = { "n", "v" },
              has = "codeAction",
            },
            {
              "<leader>lc",
              vim.lsp.codelens.run,
              desc = "Run Codelens",
              mode = { "n", "v" },
              has = "codeLens",
            },
            {
              "<leader>lC",
              vim.lsp.codelens.refresh,
              desc = "Refresh & Display Codelens",
              mode = { "n" },
              has = "codeLens",
            },
            {
              "<leader>lR",
              function()
                Snacks.rename.rename_file()
              end,
              desc = "Rename File",
              mode = { "n" },
              has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
            },
            {
              "<leader>lr",
              vim.lsp.buf.rename,
              desc = "Rename",
              has = "rename",
            },
            {
              "]]",
              function()
                Snacks.words.jump(vim.v.count1)
              end,
              has = "documentHighlight",
              desc = "Next Reference",
              cond = function()
                return Snacks.words.is_enabled()
              end,
            },
            {
              "[[",
              function()
                Snacks.words.jump(-vim.v.count1)
              end,
              has = "documentHighlight",
              desc = "Prev Reference",
              cond = function()
                return Snacks.words.is_enabled()
              end,
            },
          },
        },
        lua_ls = {
          cmd = { "lua-language-server", "--locale=zh-cn" },
          settings = {
            Lua = {
              diagnostics = {
                disable = {
                  "trailing-space",
                },
              },
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
        bashls = {
          mason = true,
          filetypes = { "sh", "bash" },
        },
        nushell = {},
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = "auto" },
          },
        },
      },
      setup = {},
    },
    config = function(_, opts)
      -- setup keymaps
      for server, server_opts in pairs(opts.servers) do
        if type(server_opts) == "table" and server_opts.keys then
          require("plugins.lsp.keymaps").set({ name = server ~= "*" and server or nil }, server_opts.keys)
        end
      end

      -- inlay hints
      if opts.inlay_hints.enabled then
        Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      -- diagnostics
      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = function(diagnostic)
          local icons = Utils.icons.diagnostics
          for d, icon in pairs(icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
          return "●"
        end
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      if opts.servers["*"] then
        vim.lsp.config("*", opts.servers["*"])
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason = Utils.has("mason-lspconfig.nvim")
      local mason_all = have_mason
          and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
        or {} --[[ @as string[] ]]
      local mason_exclude = {} ---@type string[]

      ---@return boolean? exclude automatic setup
      local function configure(server)
        if server == "*" then
          return false
        end
        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts --[[@as lazyvim.lsp.Config]]

        ---@diagnostic disable-next-line: undefined-field
        if sopts.enabled == false then
          mason_exclude[#mason_exclude + 1] = server
          return
        end

        ---@diagnostic disable-next-line: undefined-field
        local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, sopts) then
          mason_exclude[#mason_exclude + 1] = server
        else
          vim.lsp.config(server, sopts) -- configure the server
          if not use_mason then
            vim.lsp.enable(server)
          end
        end
        return use_mason
      end

      local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
      if have_mason then
        require("mason-lspconfig").setup({
          ensure_installed = vim.list_extend(install, Utils.opts("mason-lspconfig.nvim").ensure_installed or {}),
          automatic_enable = { exclude = mason_exclude },
        })
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "User LazyFile",
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format()
        end,
        desc = "Formatting",
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      formatters_by_ft = {
        nu = { "topiary_nu" },
        lua = { "stylua" },
        python = { "ruff_format" },
        html = { "prettierd" },
        vue = { "prettierd" },
        yaml = { "prettierd" },
        rust = { "rustfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        sh = { "shfmt" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters = {
        topiary_nu = {
          command = "topiary",
          args = { "format", "--language", "nu" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(biome_support) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "biome")
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.biome = {
        require_cwd = true,
      }
    end,
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>ls", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      keymaps = {
        fold_toggle = { "<tab>", "za" },
      },
    },
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
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
    "rachartier/tiny-inline-diagnostic.nvim",
    enabled = false,
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
    enabled = false,
    event = "LspAttach",
    opts = {
      label = {
        truncateAtChars = 40,
      },
    }, -- required, even if empty
  },
}
