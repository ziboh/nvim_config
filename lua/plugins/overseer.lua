return {
  "stevearc/overseer.nvim",
  lazy = true,
  config = function(_)
    local overseer = require "overseer"
    overseer.setup {
      templates = { "builtin","user.run_current_python","user.run_rye_script" },
      task_list = {
        direction = "right",
        bindings = {
          ["K"] = "ScrollOutputUp",
          ["J"] = "ScrollOutputDown",
        },
      },
    }
    overseer.register_template {
      name = "Live Server",
      builder = function()
        local path = vim.fn.expand "%:p:h"
        return {
          cmd = { "live-server" },
          args = { "--port=5555", path },
        }
      end,
      condition = {},
    }
  end,
}
