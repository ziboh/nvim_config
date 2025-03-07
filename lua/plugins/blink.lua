vim.g.blink_main = false
---@type LazyPluginSpec[]
return {
  {
    "saghen/blink.cmp",
    version = not vim.g.blink_main and "*",
    build = vim.g.blink_main and "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = {
        preset = "luasnip",
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
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon" },
              { "source_name" },
            },
            components = {
              source_name = {
                text = function(ctx)
                  return "[" .. ctx.source_name .. "]"
                end,
              },
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
      cmdline = {
        enabled = false,
      },
      sources = {
        compat = {},
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            transform_items = function(_, items)
              -- the default transformer will do this
              for _, item in ipairs(items) do
                if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
                  item.score_offset = item.score_offset - 3
                end
                local client = vim.lsp.get_client_by_id(item.client_id)
                if client.name == "rime_ls" then
                  item.score_offset = item.score_offset - 3
                end

                item.source_name = client.name
              end

              return items
            end,
          },
        },
      },

      keymap = {
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-y>"] = { "select_and_accept" },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        -- nerd_font_variant = "mono",
        kind_icons = {
          Text = "󰉿",
          Method = "󰊕",
          Function = "󰊕",
          Constructor = "󰒓",

          Field = "󰜢",
          Variable = "󰆦",
          Property = "󰖷",

          Class = "󱡠",
          Interface = "󱡠",
          Struct = "󱡠",
          Module = "󰅩",

          Unit = "󰪚",
          Value = "󰦨",
          Enum = "󰦨",
          EnumMember = "󰦨",

          Keyword = "󰻾",
          Constant = "󰏿",

          Snippet = "󱄽",
          Color = "󰏘",
          File = "󰈔",
          Reference = "󰬲",
          Foler = "󰉋",
          Event = "󱐋",
          Operator = "󰪚",
          TypeParameter = "󰬛",
        },
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

      -- When there is only one rime item after inputting a number, select it directly
      require("blink.cmp.completion.list").show_emitter:on(function(event)
        if not vim.g.rime_enabled then
          return
        end
        local col = vim.fn.col(".") - 1
        if event.context.line:sub(col, col):match("%d") == nil then
          return
        end

        local rime_item_index = Utils.rime.get_n_rime_item_index(2, event.items)

        if #rime_item_index ~= 1 then
          return
        end

        vim.schedule(function()
          require("blink.cmp").accept({ index = rime_item_index[1] })
        end)
      end)

      vim.api.nvim_set_hl(0, "BlinkCmpLabelDetail", { fg = "#9993a7", bg = "None" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "Normal", default = true })
      vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "Normal", default = true })
      vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#636da6" })
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
        ["compose.yaml"] = { glyph = "󰡨", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
        yaml = { glyph = "", hl = "MiniIconsPurple" },
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
}
