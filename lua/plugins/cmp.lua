return {
  {
    "onsails/lspkind.nvim",
    config = function()
      require("lspkind").init {
        mode = "symbol_text",
        preset = "codicons",
        symbol_map = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "",
          Field = "󰜢",
          Variable = "󰀫",
          Class = "󰠱",
          Interface = "",
          Module = "",
          Property = "󰜢",
          Unit = "󰑭",
          Enum = "",
          Value = "󰎠",
          Keyword = "󰌋",
          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "",
          Constant = "󰏿",
          Struct = "󰙅",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "",
          FittenCode = "",
        },
      }
      vim.api.nvim_set_hl(0, "CmpItemKindFittenCode", { fg = "#6CC644" })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", --   helsp auto-completion
      "hrsh7th/cmp-buffer", -- buffer auto-completion
      "hrsh7th/cmp-path", -- path auto-completion
      "hrsh7th/cmp-cmdline", -- cmdline auto-completion
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local luasnip_ok, luasnip = pcall(require, "luasnip")
      local cmp_ok, cmp = pcall(require, "cmp")
      local lspkind_ok, lspkind = pcall(require, "lspkind")

      if not luasnip_ok or not cmp_ok or not lspkind_ok then return end
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      vim.api.nvim_set_hl(0, "CmpBorder", { bg = "NONE", fg = "#6587CE" })
      local auto_select = true
      cmp.setup {
        window = {
          documentation = {
            border = "rounded",
            scrollbar = true,
            winhighlight = "FloatBorder:CmpBorder",
          },
          completion = {
            border = "rounded",
            scrollbar = true,
            winhighlight = "FloatBorder:CmpBorder",
          },
        },
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-f>"] = cmp.mapping.scroll_docs(-4),
          ["<C-b>"] = cmp.mapping.scroll_docs(4),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = false },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }), -- i - insert mode; s - select mode
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },

        formatting = {
          format = lspkind.cmp_format {
            mode = "symbol",
            maxwidth = 40,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              --- 创建一个表，让lsp的名称简写
              local lsp_abbreviations = {
                emmet_language_server = "Emmet",
              }
              if entry.source.name == "nvim_lsp" then
                -- Display which LSP servers this item came from.
                local lspserver_name = nil
                pcall(function()
                  lspserver_name = entry.source.source.client.name
                  if lsp_abbreviations[lspserver_name] then lspserver_name = lsp_abbreviations[lspserver_name] end
                  -- 大写开头
                  lspserver_name = string.upper(string.sub(lspserver_name, 1, 1)) .. string.sub(lspserver_name, 2)
                  vim_item.menu = lspserver_name
                end)
              else
                vim_item.menu = ({
                  nvim_lsp = "[Lsp]",
                  luasnip = "[Luasnip]",
                  buffer = "[File]",
                  path = "[Path]",
                  lazydev = "[Lazy]",
                  fittencode = "[Fitten]",
                  crates = "[Crates]",
                })[entry.source.name]
              end
              return vim_item
            end,
          },
        },
        -- Set source precedence
        sources = cmp.config.sources {
          { name = "crates", group_index = 2 }, -- For crates completion
          { name = "fittencode", group_index = 2 },
          { name = "lazydev", group_index = 0 },
          { name = "nvim_lsp", group_index = 2 }, -- For nvim-lsp
          { name = "luasnip", group_index = 2 }, -- For luasnip user
          { name = "buffer", group_index = 2 }, -- For buffer word completion
          { name = "path", group_index = 2 }, -- For path completion
        },
      }

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
  -- Code snippet engine
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = {
      "rafamadriz/friendly-snippets",
      "benfowler/telescope-luasnip.nvim",
    },
    config = function(_, opts)
      local luasnip_ok, luasnip = pcall(require, "luasnip")
      if not luasnip_ok then return end
      if opts then luasnip.config.setup(opts) end
      vim.tbl_map(
        function(type) require("luasnip.loaders.from_" .. type).lazy_load() end,
        { "vscode", "snipmate", "lua" }
      )
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
      require "snip"
    end,
  },
}
