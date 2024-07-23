return {
  "stevearc/overseer.nvim",
  lazy = true,
  config = function(_)
    local overseer = require "overseer"
    overseer.setup {
      task_list = {
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
