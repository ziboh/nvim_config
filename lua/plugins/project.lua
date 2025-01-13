
pick = function()
  local fzf_lua = require("fzf-lua")
  local project = require("project_nvim.project")
  local history = require("project_nvim.utils.history")
  local results = history.get_recent_projects()
  local utils = require("fzf-lua.utils")

  local function hl_validate(hl)
    return not utils.is_hl_cleared(hl) and hl or nil
  end

  local function ansi_from_hl(hl, s)
    return utils.ansi_from_hl(hl_validate(hl), s)
  end
  local opts = {
    fzf_opts = {
      ["--preview"] = vim.fn.executable("lla") == 1 and "lla --icons {}" or "ls -l {}",
      ["--preview-window"] = "nohidden,down,50%",
      ["--header"] = string.format(
        ":: <%s> to %s | <%s> to %s | <%s> to %s | <%s> to %s | <%s> to %s",
        ansi_from_hl("FzfLuaHeaderBind", "ctrl-t"),
        ansi_from_hl("FzfLuaHeaderText", "tabedit"),
        ansi_from_hl("FzfLuaHeaderBind", "ctrl-s"),
        ansi_from_hl("FzfLuaHeaderText", "live_grep"),
        ansi_from_hl("FzfLuaHeaderBind", "ctrl-r"),
        ansi_from_hl("FzfLuaHeaderText", "oldfiles"),
        ansi_from_hl("FzfLuaHeaderBind", "ctrl-w"),
        ansi_from_hl("FzfLuaHeaderText", "change_dir"),
        ansi_from_hl("FzfLuaHeaderBind", "ctrl-d"),
        ansi_from_hl("FzfLuaHeaderText", "delete")
      ),
    },
    fzf_colors = true,
    actions = {
      ["default"] = {
        function(selected)
          vim.cmd("quit")
          fzf_lua.files({ cwd = selected[1] })
        end,
      },
      ["ctrl-t"] = {
        function(selected)
          vim.cmd("tabedit")
          fzf_lua.files({ cwd = selected[1] })
        end,
      },
      ["ctrl-s"] = {
        function(selected)
          vim.cmd("quit")
          fzf_lua.live_grep({ cwd = selected[1] })
        end,
      },
      ["ctrl-r"] = {
        function(selected)
          vim.cmd("quit")
          fzf_lua.oldfiles({ cwd = selected[1] })
        end,
      },
      ["ctrl-w"] = {
        function(selected)
          local path = selected[1]
          local ok = project.set_pwd(path)
          if ok then
            vim.api.nvim_win_close(0, false)
            Utils.info("Change project dir to " .. path)
          end
        end,
      },
      ["ctrl-d"] = {
        function(selected)
          local path = selected[1]
          local choice = vim.fn.confirm("Delete '" .. path .. "' project? ", "&Yes\n&No")
          if choice == 1 then
            history.delete_project({ value = path })
          end
          pick()
        end,
      },
    },
  }

  fzf_lua.fzf_exec(results, opts)
end

return {
  {
    "ahmedkhalf/project.nvim",
    cmd = "FzfProjects",
    event = "VeryLazy",
    keys = {
      { "<leader>fp", pick, desc = "Projects" },
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      local history = require("project_nvim.utils.history")
      ---@diagnostic disable-next-line: duplicate-set-field
      history.delete_project = function(project)
        for k, v in pairs(history.recent_projects) do
          if v == project.value then
            history.recent_projects[k] = nil
            return
          end
        end
      end

      vim.api.nvim_create_user_command("FzfProjects", pick, {})
    end,
  },
}
