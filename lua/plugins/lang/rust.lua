vim.g.lazyvim_rust_diagnostics = "bacon-ls"
local diagnostics = vim.g.lazyvim_rust_diagnostics or "rust-analyzer"

return {
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup({
        lsp = {
          enabled = true,
          on_attach = function(client, bufnr)
            -- the same on_attach function as for your other lsp's
          end,
          actions = true,
          completion = true,
          hover = true,
        },
      })
      Utils.lsp.on_attach(function(client, bufnr)
        local function show_documentation()
          local filetype = vim.bo.filetype
          if filetype == "vim" or filetype == "help" then
            vim.cmd("h " .. vim.fn.expand("<cword>"))
          elseif filetype == "man" then
            vim.cmd("Man " .. vim.fn.expand("<cword>"))
          elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
            require("crates").show_popup()
          else
            vim.lsp.buf.hover()
          end
        end

        vim.keymap.set("n", "<leader>h", show_documentation, { bufnr = bufnr, silent = true, desc = "Hover" })
        vim.keymap.set("n", "K", show_documentation, { bufnr = bufnr, silent = true, desc = "Hover" })
      end, "crates.nvim")
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = vim.fn.has("nvim-0.10.0") == 0 and "^4" or false,
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>la", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })
          vim.keymap.set("n", "K", function()
            vim.cmd.RustLsp({ "hover", "actions" })
          end, { desc = "Rust Hover", buffer = bufnr })
        end,
        offset_encoding = "utf-8",
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust if using rust-analyzer
            checkOnSave = diagnostics == "rust-analyzer",
            -- Enable diagnostics if using rust-analyzer
            diagnostics = {
              enable = diagnostics == "rust-analyzer",
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            files = {
              excludeDirs = {
                ".direnv",
                ".git",
                ".github",
                ".gitlab",
                "bin",
                "node_modules",
                "target",
                "venv",
                ".venv",
              },
            },
          },
        },
      },
      status_notify_level = false,
    },
    config = function(_, opts)
      local capabilities = require("rustaceanvim.config.server").create_client_capabilities()
      capabilities.general.positionEncodings = { "utf-8", "utf-16" }
      opts.server.capabilities = capabilities
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
      if vim.fn.executable("rust-analyzer") == 0 then
        Utils.error(
          "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
          { title = "rustaceanvim" }
        )
      end
    end,
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "codelldb" })
      if diagnostics == "bacon-ls" then
        vim.list_extend(opts.ensure_installed, { "bacon" })
      end
    end,
  },

  -- Correctly setup lspconfig for Rust 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bacon_ls = {
          init_options = {
            updateOnSave = true,
            updateOnSaveWaitMillis = 1000,
          },
        },
        rust_analyzer = { enabled = false },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "rust",
      },
    },
  },
}
