return {
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      Utils.mini.pairs(opts)
    end,
  },
  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
      })
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Move to left split",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Move to below split",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Move to above split",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Move to right split",
      },
      {
        "<C-Up>",
        function()
          require("smart-splits").resize_up()
        end,
        desc = "Resize split up",
      },
      {
        "<C-Down>",
        function()
          require("smart-splits").resize_down()
        end,
        desc = "Resize split down",
      },
      {
        "<C-Left>",
        function()
          require("smart-splits").resize_left()
        end,
        desc = "Resize split left",
      },
      {
        "<C-Right>",
        function()
          require("smart-splits").resize_right()
        end,
        desc = "Resize split right",
      },
    },
  },
  {
    "echasnovski/mini.splitjoin",
    version = "*",
    -- No need to copy this inside `setup()`. Will be used automatically.
    opts = {
      mappings = { toggle = "gS", split = "", join = "" },
    },
    keys = { "gS", desc = "Split join" },
  },
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    opts = {
      keymaps = {
        ["<C-k>"] = "actions.select_vsplit",
        ["<C-s>"] = false,
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "mistweaverco/kulala.nvim",
    init = function()
      vim.filetype.add({
        extension = {
          ["http"] = "http",
        },
      })
    end,
    ft = { "http" },
    config = function()
      -- Setup is required, even if you don't pass any options
      require("kulala").setup({
        -- default_view, body or headers
        default_view = "body",
        -- dev, test, prod, can be anything
        -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
        default_env = "dev",
        -- enable/disable debug mode
        debug = false,
        -- default formatters for different content types
        formatters = {
          json = { "jq", "." },
          xml = { "xmllint", "--format", "-" },
          html = { "xmllint", "--format", "--html", "-" },
        },
        -- default icons
        icons = {
          inlay = {
            loading = "⏳",
            done = "✅",
            error = "❌",
          },
          lualine = "🐼",
        },
        -- additional cURL options
        -- see: https://curl.se/docs/manpage.html
        additional_curl_options = {},
      })
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "User LazyFile",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = Utils.mini.ai_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      Utils.on_load("which-key.nvim", function()
        vim.schedule(function()
          Utils.mini.ai_whichkey(opts)
        end)
      end)
    end,
  },
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local opts = Utils.opts("mini.surround")
      local mappings = {
        { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete Surrounding" },
        { opts.mappings.find, desc = "Find Right Surrounding" },
        { opts.mappings.find_left, desc = "Find Left Surrounding" },
        { opts.mappings.highlight, desc = "Highlight Surrounding" },
        { opts.mappings.replace, desc = "Replace Surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "cs", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
}
