return {
  {
    "lewis6991/gitsigns.nvim",
    event = "User LazyGitFile",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "purarue/gitsigns-yadm.nvim",
        enabled = not Utils.is_win(),
        opts = {
          shell_timeout_ms = 1000,
        },
      },
    },
    opts = {
      _on_attach_pre = function(_, callback)
        if Utils.is_win() then
          return
        end
        require("gitsigns-yadm").yadm_signs(callback)
      end,
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

      -- stylua: ignore start
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Hunk")
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev Hunk")
      map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
      map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
      map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
      map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
      map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
      map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
      map("n", "<leader>ghd", gs.diffthis, "Diff This")
      map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integrations
      -- Only one of these is needed, not both.
    },
    config = true,
    keys = {
      {
        "<leader>gno",
        function()
          require("neogit").open({ cwd = Utils.root() })
        end,
        desc = "Open Neogit Tab Page",
      },
      { "<leader>gnc", "<Cmd>Neogit commit<CR>", desc = "Open Neogit Commit Page" },
      { "<leader>gnd", ":Neogit cwd=", desc = "Open Neogit Override CWD" },
      { "<leader>gnk", ":Neogit kind=", desc = "Open Neogit Override Kind" },
    },
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gdf", "<cmd>DiffviewFileHistory %<CR>", mode = { "n", "v" }, desc = "Show file diff" },
      { "<leader>gdd", "<cmd>DiffviewFileHistory<CR>", mode = { "n", "v" }, desc = "Show diff" },
    },
  },
}
