return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config'), confirm = { 'tcd_cwd', 'jump' } })",
            },
            {
              icon = " ",
              key = "p",
              desc = "Projects",
              action = ":lua Snacks.picker.projects()",
            },
            { icon = " ", key = "l", desc = "Leet", action = "<cmd>Leet<cr>" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = {},
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    init = function()
      vim.opt.termguicolors = true
    end,
    opts = {
      -- 设置样式：storm, night, day, moon
      style = "moon",
      -- 启用终端颜色
      terminal_colors = false,
      -- 使终端背景透明
      transparent = false, -- 如果想要透明背景，设置为 true
    },
  },
  {
    "echasnovski/mini.hipatterns",
    version = false,
    event = "User LazyFile",
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
      { "<c-a-F10>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<C-]>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    },
    opts = {
      options = {
      -- stylua: ignore
      close_command = function(n) Snacks.bufdelete(n) end,
        always_show_bufferline = false,
      -- stylua: ignore
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = Utils.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "snacks_layout_box",
          },
        },
        ---@param opts bufferline.IconFetcherOpts
        get_element_icon = function(opts)
          return Snacks.util.icon(opts.filetype, "filetype")
        end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      vim.keymap.set("n", "L", "$", { noremap = true, silent = true, desc = "Move to end of line" })
      vim.keymap.set("n", "H", "^", { noremap = true, silent = true, desc = "Move to first non-blank character" })
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
}
