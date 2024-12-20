return {
  name = "Run Current Python File",
  builder = function()
    return {
      cmd = { "python3" },
      args = { vim.fn.expand "%:p" },
    }
  end,
  condition = {
    callback = function() return vim.fn.expand "%:e" == "py" end,
  },
  desc = "Run the current Python file",
  priority = 50,
}
