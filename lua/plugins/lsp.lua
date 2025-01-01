local lazy = false
if vim.fn.expand("%") == "" then
  lazy = true
end
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
    config = function()
      require("plugins.config.lsp")()
    end,
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
    config = function()
      require("inc_rename").setup({ save_in_cmdline_history = false })
    end,
  },
  {
    "ziboh/vim-illuminate",
    event = "BufReadPre",
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
    event = "VeryLazy",
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
