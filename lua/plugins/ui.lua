local is_windows = vim.uv.os_uname().os_sysname == "Windows_NT"
return {
  {
    "AstroNvim/astrotheme",
    config = function()
      require("astrotheme").setup {
        opts = {
          palette = "astrodark",
          plugins = { ["dashboard-nvim"] = true },
        },
        highlights = {
          global = { -- Add or modify hl groups globally, theme specific hl groups take priority.
            ["LspCodeLens"] = { fg = "#9DA9A0", bg = "NONE" },
            ["BqfPreviewBorder"] = { fg = "#87c05f", bg = "NONE" },
            ["LspInlayHint"] = { fg = "#696c76", bg = "NONE" },
            ["Visual"] = { fg = "NONE", bg = "#45475a" },
            ["@lsp.type.function.rust"] = { link = "Funtion" },
          },
        },
      }
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
  },
  {
    "sainnhe/everforest",
    lazy = true,
    config = function()
      vim.g.everforest_background = "hard"
      vim.cmd.colorscheme "everforest"
      vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#9DA9A0" })
    end,
  },
  {
    "folke/zen-mode.nvim",
    keys = { { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zenmode" } },
  },
  {
    "uga-rosa/ccc.nvim",
    event = "VeryLazy",
    enabled = false;
    cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable", "CccHighlighterToggle" },
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
      },
    },
    config = function(_, opts)
      require("ccc").setup(opts)
      if opts.highlighter and opts.highlighter.auto_enable then vim.cmd.CccHighlighterEnable() end
    end,
  },
  {
    "goolord/alpha-nvim",
    cmd = "Alpha",
    -- setup header and buttonts
    opts = function()
      local dashboard = require "alpha.themes.dashboard"

      -- Header
      -- dashboard.section.header.val = {
      --   "                                                                     ",
      --   "       ████ ██████           █████      ██                     ",
      --   "      ███████████             █████                             ",
      --   "      █████████ ███████████████████ ███   ███████████   ",
      --   "     █████████  ███    █████████████ █████ ██████████████   ",
      --   "    █████████ ██████████ █████████ █████ █████ ████ █████   ",
      --   "  ███████████ ███    ███ █████████ █████ █████ ████ █████  ",
      --   " ██████  █████████████████████ ████ █████ █████ ████ ██████ ",
      -- }
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
      }

      vim.api.nvim_create_user_command(
        "FindProject",
        function() require("telescope").extensions.project.project { display_type = "full" } end,
        {}
      )
      vim.api.nvim_create_user_command("Sessionload", function() require("resession").load() end, {})
      dashboard.section.header.opts.hl = "DashboardHeader"
      vim.cmd "highlight DashboardHeader guifg=#F7778F"
      -- Buttons
      dashboard.section.buttons.val = {
        dashboard.button("n", "📄 New     ", "<cmd>ene<CR>"),
        dashboard.button("e", "🌺 Recent  ", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("l", "🚀 Leet  ", "<cmd>Leet<CR>"),
        dashboard.button("s", "🔎 Sessions", "<cmd>Sessionl<CR>"),
        dashboard.button("p", "💼 Projects", "<cmd>lua require'telescope'.extensions.projects.projects{}<CR>"),
        dashboard.button("", ""),
        dashboard.button("q", "󰈆  Quit", "<cmd>exit<CR>"),
        --  --button("LDR f '", "  Bookmarks  "),
      }

      -- Vertical margins
      dashboard.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.10) } -- Above header
      dashboard.config.layout[3].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.10) } -- Above buttons

      -- Disable autocmd and return
      dashboard.config.opts.noautocmd = true
      return dashboard
    end,
    config = function(_, opts)
      -- Footer
      require("alpha").setup(opts.config)
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        desc = "Add Alpha dashboard footer",
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          stats.real_cputime = not is_windows
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          opts.section.footer.val = {
            " ",
            " ",
            " ",
            "Loaded " .. stats.loaded .. " plugins  in " .. ms .. "ms",
            ".............................",
          }
          opts.section.footer.opts.hl = "DashboardFooter"
          vim.cmd "highlight DashboardFooter guifg=#D29B68"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
