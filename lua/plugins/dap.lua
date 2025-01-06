local get_icon = require("utils").get_icon
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
      vim.fn.sign_define("DapBreakpoint", { text = get_icon("DapBreakpoint"), texthl = "DiagnosticInfo" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = get_icon("DapBreakpointCondition"), texthl = "DiagnosticInfo" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = get_icon("DapBreakpointRejected"), texthl = "DiagnosticError" }
      )
      vim.fn.sign_define("DapLogPoint", { text = get_icon("DapLogPoint"), texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = get_icon("DapStopped"), texthl = "DiagnosticWarn" })
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
