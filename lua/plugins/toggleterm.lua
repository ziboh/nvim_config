return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    opts = {--[[ things you want to change go here]]
      on_create = function(t)
        vim.opt_local.foldcolumn = "0"
        vim.opt_local.signcolumn = "no"
        if t.hidden then
          local toggle = function() t:toggle() end
          vim.keymap.set({ "n", "t", "i" }, "<C-t>", toggle, { desc = "Toggle terminal", buffer = t.bufnr })
          vim.keymap.set({ "n", "t", "i" }, "<F7>", toggle, { desc = "Toggle terminal", buffer = t.bufnr })
        end
      end,
    },
  },
}
