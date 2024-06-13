return {
  {
    "nvim-neotest/nvim-nio",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("nvim-dap-virtual-text").setup {
        commented = true,
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local get_icon = require("utils").get_icon
      require("dapui").setup()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
      vim.fn.sign_define("DapBreakpoint", { text = get_icon "DapBreakpoint", texthl = "DiagnosticInfo" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = get_icon "DapBreakpointCondition", texthl = "DiagnosticInfo" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = get_icon "DapBreakpointRejected", texthl = "DiagnosticError" }
      )
      vim.fn.sign_define("DapLogPoint", { text = get_icon "DapLogPoint", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = get_icon "DapStopped", texthl = "DiagnosticWarn" })
    end,
  },
}
