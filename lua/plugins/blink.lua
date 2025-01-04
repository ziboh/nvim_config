return {
  {
    "saghen/blink.cmp",
    version = not vim.g.lazyvim_blink_main and "*",
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
      "supermaven-inc/supermaven-nvim",
      {
        "saghen/blink.compat",
        opts = {},
        version = not vim.g.lazyvim_blink_main and "*",
      },
    },
    event = "InsertEnter",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          border = "single",
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon" }, { "kind" } },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                text = function(ctx)
                  return "<" .. ctx.kind .. ">"
                end,
              },
            },
            treesitter = { "lsp" },
          },
        },
        documentation = {
          window = { border = "single" },
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      },

      sources = {
        compat = { "supermaven", "codeium" },
        default = { "lazydev", "lsp", "path", "luasnip", "buffer" },
        cmdline = {},
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          supermaven = {
            kind = "Supermaven",
            score_offset = 100,
            async = true,
          },
          codeium = {
            kind = "Codeium",
            score_offset = 100,
            async = true,
          },
          -- fittencode = {
          --   name = "fittencode",
          --   module = "fittencode.sources.blink",
          --   score_offset = 100,
          --   async = true,
          --   kind = "Fitten",
          -- },
        },
      },

      keymap = {
        preset = "enter",
        ["<C-b>"] = { "scroll_documentation_down" },
        ["<C-h>"] = { "scroll_documentation_up" },
      },
    },
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end
      require("cmp")
      -- add ai_accept to <Tab> key
      if not opts.keymap["<Tab>"] then
        if opts.keymap.preset == "super-tab" then -- super-tab
          opts.keymap["<Tab>"] = {
            require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
            Utils.cmp.map({ "snippet_forward", "ai_accept" }),
            "fallback",
          }
        else -- other presets
          opts.keymap["<Tab>"] = {
            Utils.cmp.map({ "snippet_forward", "ai_accept" }),
            "fallback",
          }
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
            end
            return items
          end

          provider.kind = nil
        end
      end

      require("blink.cmp").setup(opts)

      vim.api.nvim_set_hl(0, "BlinkCmpLabelDetail", { fg = "#9993a7", bg = "None" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "Normal", default = true })
      vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "Normal", default = true })
      vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { link = "Comment", default = true })
      vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "NONE", fg = "#6587CE" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "NONE", fg = "#6587CE" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#26343f", fg = "NONE" })
    end,
  },
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
      lsp = {
        supermaven = { glyph = "", hl = "MiniIconsYellow" },
        fitten = { glyph = "", hl = "MiniIconsYellow" },
        copilot = { glyph = "", hl = "MiniIconsYellow" },
        codeium = { glyph = "", hl = "MiniIconsBlue" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function(_, opts)
      local luasnip_ok, luasnip = pcall(require, "luasnip")
      if not luasnip_ok then
        return
      end
      if opts then
        luasnip.config.setup(opts)
      end
      vim.tbl_map(function(type)
        require("luasnip.loaders.from_" .. type).lazy_load()
      end, { "vscode", "snipmate", "lua" })
      -- friendly-snippets - enable standardized comments snippets
      luasnip.filetype_extend("typescript", { "tsdoc" })
      luasnip.filetype_extend("javascript", { "jsdoc" })
      luasnip.filetype_extend("lua", { "luadoc" })
      luasnip.filetype_extend("python", { "pydoc" })
      luasnip.filetype_extend("rust", { "rustdoc" })
      luasnip.filetype_extend("cs", { "csharpdoc" })
      luasnip.filetype_extend("c", { "cdoc" })
      luasnip.filetype_extend("cpp", { "cppdoc" })
      luasnip.filetype_extend("sh", { "shelldoc" })
      require("snip")
    end,
  },
  {
    "Exafunction/codeium.nvim",
    cmd = "Codeium",
    event = "InsertEnter",
    enabled = false,
    build = ":Codeium Auth",
    opts = {
      enable_cmp_source = vim.g.ai_cmp,
      virtual_text = {
        enabled = not vim.g.ai_cmp,
        key_bindings = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
    },
  },
  {
    "luozhiya/fittencode.nvim",
    enabled = false,
    event = "InsertEnter",
    config = function()
      require("fittencode").setup({
        completion_mode = "source",
        source_completion = {
          enable = true,
          engine = "blink", -- "cmp" | "blink"
          trigger_chars = {},
        },
      })
    end,
    lazy = true,
  },
  {
    "supermaven-inc/supermaven-nvim",
    enabled = false,
    event = "InsertEnter",
    cmd = {
      "SupermavenUseFree",
      "SupermavenUsePro",
    },
    opts = {
      keymaps = {
        accept_suggestion = nil, -- handled by nvim-cmp / blink.cmp
      },
      disable_inline_completion = vim.g.ai_cmp,
      ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
    },
  },
}
