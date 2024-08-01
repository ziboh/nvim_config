return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      local is_ok, gitsigns = pcall(require, "gitsigns")
      if not is_ok then return end
      gitsigns.setup {
        current_line_blame = true,
        preview_config = {
          -- Options passed to nvim_open_win
          border = "rounded",
          relative = "cursor",
        },
        on_attach = function(bufnr)
          local gitsigns = require "gitsigns"

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal { "]c", bang = true }
            else
              gitsigns.nav_hunk "next"
            end
          end)

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal { "[c", bang = true }
            else
              gitsigns.nav_hunk "prev"
            end
          end)

          -- Actions
          map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Git Stage hunk" })
          map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Git Reset hunk" })
          map(
            "v",
            "<leader>gs",
            function() gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end,
            { desc = "Git Stage hunk" }
          )
          map(
            "v",
            "<leader>gr",
            function() gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end,
            { desc = "Git Reset hunk" }
          )
          map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Git Stage Buffer" })
          map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Unde Stage hunk" })
          map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
          map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
          map("n", "<leader>gb", function() gitsigns.blame_line { full = true } end, { desc = "Blame Line" })
          map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "Toggle current blame line" })
          map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff this" })
          map("n", "<leader>gD", function() gitsigns.diffthis "~" end, { desc = "Diff ~" })
          map("n", "<leader>gtd", gitsigns.toggle_deleted, { desc = "Toggle deleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      }
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integrations
      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
    keys = {
      { "<leader>gno", "<Cmd>Neogit<CR>", desc = "Open Neogit Tab Page" },
      { "<leader>gnc", "<Cmd>Neogit commit<CR>", desc = "Open Neogit Commit Page" },
      { "<leader>gnd", ":Neogit cwd=", desc = "Open Neogit Override CWD" },
      { "<leader>gnk", ":Neogit kind=", desc = "Open Neogit Override Kind" },
    },
  },
}
