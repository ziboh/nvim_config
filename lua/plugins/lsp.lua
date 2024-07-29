local lazy = false
if vim.fn.expand "%" == "" then lazy = true end
return {
  "b0o/schemastore.nvim",
  "folke/neoconf.nvim",
  "stevearc/conform.nvim",
  "zapling/mason-conform.nvim",
  {
    "williamboman/mason.nvim",
    lazy = lazy,
    event = "VeryLazy",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function() require "plugins.config.lsp"() end,
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
      require("crates").setup {
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
      }
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function(opts)
      require("clangd_extensions").setup {
        inlay_hints = {
          inline = vim.fn.has "nvim-0.10" == 1,
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
      }
    end,
  },
}
