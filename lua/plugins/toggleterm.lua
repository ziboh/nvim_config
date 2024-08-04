return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    opts = { --[[ things you want to change go here]]
      shell = (vim.uv.os_uname().sysname == "Windows_NT" and vim.fn.executable "pwsh") and "pwsh --Nologo"
        or vim.o.shell,
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
    config = function(_, opts)
      require("toggleterm").setup(opts)
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new {
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "double",
        },
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd "startinsert!"
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function(term) vim.cmd "startinsert!" end,
      }

      function lazygit_toggle() lazygit:toggle() end

      vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua lazygit_toggle()<CR>", { noremap = true, silent = true })
    end,
  },
}
