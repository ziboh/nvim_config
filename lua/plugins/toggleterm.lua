return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    opts = { --[[ things you want to change go here]]
      shell = (vim.uv.os_uname().sysname == "Windows_NT" and vim.fn.executable("pwsh")) and "pwsh --Nologo"
        or vim.o.shell,
      on_create = function(t)
        vim.opt_local.foldcolumn = "0"
        vim.opt_local.signcolumn = "no"
        if t.hidden then
          local toggle = function()
            t:toggle()
          end
          vim.keymap.set({ "n", "t", "i" }, "<C-t>", toggle, { desc = "Toggle terminal", buffer = t.bufnr })
          vim.keymap.set({ "n", "t", "i" }, "<F7>", toggle, { desc = "Toggle terminal", buffer = t.bufnr })
        end
      end,
      highlights = {
        Normal = { link = "Normal" },
        NormalNC = { link = "NormalNC" },
        NormalFloat = { link = "NormalFloat" },
        FloatBorder = { link = "FloatBorder" },
        StatusLine = { link = "StatusLine" },
        StatusLineNC = { link = "StatusLineNC" },
        WinBar = { link = "WinBar" },
        WinBarNC = { link = "WinBarNC" },
      },
    },
    size = 10,
    shading_factor = 2,
    float_opts = { border = "rounded" },
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },
}
