return {
  "ojroques/nvim-osc52",
  config = function()
    local function text_copy()
      local is_ok, osc52 = pcall(require, "osc52")
      if not is_ok then return end
      if vim.v.event.operator == "y" and vim.v.event.regname == "+" then osc52.copy_register "+" end
    end

    vim.api.nvim_create_autocmd("TextYankPost", { callback = text_copy })

    local function copy(lines, _) require("osc52").copy(table.concat(lines, "\n")) end

    local function paste() return { vim.fn.split(vim.fn.getreg "", "\n"), vim.fn.getregtype "" } end

    vim.g.clipboard = {
      name = "osc52",
      copy = { ["+"] = copy, ["*"] = copy },
      paste = { ["+"] = paste, ["*"] = paste },
    }
    require("osc52").setup {
      max_length = 0, -- Maximum length of selection (0 for no limit)
      silent = true, -- Disable message on successful copy
      trim = false, -- Trim surrounding whitespaces before copy
      tmux_passthrough = false, -- Use tmux passthrough (requires tmux: set -g allow-passthrough on)
    }
  end,
}
