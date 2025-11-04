local prompts = require("plugins.llm.prompts")
local tools = require("llm.tools")
return {
  handler = tools.flexi_handler,
  prompt = prompts.CommitMsg,
  opts = {
    url = os.getenv("ONEAPI_URL") .. "/v1/chat/completions",
    fetch_key = function()
      return vim.env.ONEAPI_KEY
    end,
    model = "gemini-2.5-flash",
    api_type = "openai",
    enter_flexible_window = true,
    apply_visual_selection = false,
    win_opts = {
      relative = "editor",
      position = "50%",
      zindex = 70,
    },
    accept = {
      mapping = {
        mode = "n",
        keys = "<cr>",
      },
      action = function()
        local contents = vim.api.nvim_buf_get_lines(0, 0, -1, true)

        local cmd = string.format('!git commit -m "%s"', table.concat(contents, '" -m "'))
        cmd = (cmd:gsub(".", {
          ["#"] = "\\#",
        }))
        vim.api.nvim_command(cmd)

        -- just for lazygit
        vim.schedule(function()
          Snacks.lazygit({ args = Utils.lazygit_args() })
        end)
      end,
    },
  },
}
