local utils = require("utils")

return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "python", "codelldb" },
    },
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
  {
    "mfussenegger/nvim-dap-python",
  -- stylua: ignore
  keys = {
    { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
    { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
  },
    config = function()
      if Utils.is_win() then
        require("dap-python").setup(utils.get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe"))
      else
        require("dap-python").setup(utils.get_pkg_path("debugpy", "/venv/bin/python"))
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("nvim-dap-virtual-text").setup({
        commented = true,
      })
      vim.fn.sign_define("DapBreakpoint", { text = Utils.icons.dap.Breakpoint, texthl = "DiagnosticInfo" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = Utils.icons.dap.BreakpointCondition, texthl = "DiagnosticInfo" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = Utils.icons.dap.BreakpointRejected[1], texthl = Utils.icons.dap.BreakpointRejected[2] }
      )
      vim.fn.sign_define("DapLogPoint", { text = Utils.icons.dap.LogPoint, texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = Utils.icons.dap.Stopped[1], texthl = "DiagnosticWarn" })
      require("dapui").setup()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
    end,
  },
}
