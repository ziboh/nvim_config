return {
  "pocco81/auto-save.nvim",
  opts = {
    enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
    execution_message = {
      message = '',
      dim = 0.18, -- dim the color of `message`
      cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
    },
    trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
    -- function that determines whether to save the current buffer or not
    -- return true: if buffer is ok to be saved
    -- return false: if it's not ok to be saved
    condition = function(buf)
      local ignore_filename = { "Cargo.toml", "" }
      local ignore_ft = { "oil", "telescopetrompt" }
      for _, fn in ipairs(ignore_filename) do
        if fn == vim.fn.expand "%:t" then return false end
      end
      for _, ft in ipairs(ignore_ft) do
        if ft == vim.bo.filetype then return false end
      end
      local fn = vim.fn
      local utils = require "auto-save.utils.data"

      if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
        return true -- met condition(s), can save
      end
      return false -- can't save
    end,
  },
}
