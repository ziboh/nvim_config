return {
  "stevearc/overseer.nvim",
  lazy = true,
  config = function(_)
    local overseer = require("overseer")
    overseer.setup({
      templates = { "builtin", "user.run_current_python", "user.run_rye_script" },
      task_list = {
        direction = "right",
        bindings = {
          ["K"] = "ScrollOutputUp",
          ["J"] = "ScrollOutputDown",
        },
      },
    })
    overseer.register_template({
      name = "Live Server",
      builder = function()
        local path = vim.fn.expand("%:p:h")
        return {
          cmd = { "live-server" },
          args = { "--port=5555", path },
        }
      end,
      condition = {},
    })
  end,
  keys = {
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Task list" },
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
    { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Action recent task" },
    { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
    { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Task builder" },
    { "<leader>ow", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
    { "<leader>oc", "<cmd>OverseerClearCache<cr>", desc = "Clear cache" },
  },
}
