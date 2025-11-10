return {
  "stevearc/overseer.nvim",
  lazy = true,
  tags = "v1.6.0",
  config = function(_)
    local overseer = require("overseer")
    overseer.setup({
      templates = { "builtin", "user.run_rye_script", "user.run_current_file" },
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
      condition = {
        callback = function()
          vim.fn.executable("live-server")
        end,
      },
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
