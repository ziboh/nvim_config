return {
  "ahmedkhalf/project.nvim",
  cmd = "FzfProjects",
  config = function()
    require("project_nvim").setup({
      -- Manual mode doesn't automatically change your root directory, so you have
      -- the option to manually do so using `:ProjectRoot` command.
      manual_mode = false,

      -- Methods of detecting the root directory. **"lsp"** uses the native neovim
      -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
      -- order matters: if one is not detected, the other is used as fallback. You
      -- can also delete or rearangne the detection methods.
      detection_methods = { "lsp", "pattern" },

      -- All the patterns used to detect root dir, when **"pattern"** is in
      -- detection_methods
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

      -- Table of lsp clients to ignore by name
      -- eg: { "efm", ... }
      ignore_lsp = {},

      -- Don't calculate root dir on specific directories
      -- Ex: { "~/.cargo/*", ... }
      exclude_dirs = {},

      -- Show hidden files in telescope
      show_hidden = false,

      -- When set to false, you will get a message when project.nvim changes your
      -- directory.
      silent_chdir = true,

      -- What scope to change the directory, valid options are
      -- * global (default)
      -- * tab
      -- * win
      scope_chdir = "global",

      -- Path where project.nvim will store the project history for use in
      -- telescope
      datapath = vim.fn.stdpath("data"),
    })
    local fzf_lua = require("fzf-lua")
    local fzf_lua = require("fzf-lua")
    local builtin = require("fzf-lua.previewer.builtin")

    -- Inherit from "base" instead of "buffer_or_file"
    local MyPreviewer = builtin.base:extend()

    function MyPreviewer:new(o, opts, fzf_win)
      MyPreviewer.super.new(self, o, opts, fzf_win)
      setmetatable(self, MyPreviewer)
      return self
    end

    function MyPreviewer:populate_preview_buf(entry_str)
      local tmpbuf = self:get_tmp_buffer()
      -- "fdfind --color=never --hidden --type=file --exclude=.git --base-directory  {}",
      local result =
        vim.fn.system("fdfind --color=never --hidden --type=file --exclude=.git --base-directory " .. entry_str)
      local output = vim.split(result, "\n")
      table.remove(output)
      vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, output)
      self:set_preview_buf(tmpbuf)
      self.win:update_scrollbar()
    end

    -- Disable line numbering and word wrap
    function MyPreviewer:gen_winopts()
      local new_winopts = {
        wrap = false,
        number = true,
      }
      return vim.tbl_extend("force", self.winopts, new_winopts)
    end
    -- 创建一个命令
    vim.api.nvim_create_user_command("FzfProjects", function()
      local history = require("project_nvim.utils.history")
      fzf_lua.fzf_exec(function(cb)
        local results = history.get_recent_projects()
        for _, e in ipairs(results) do
          cb(e)
        end
        cb()
      end, {
        previewer = MyPreviewer,
        actions = {
          ["default"] = {
            function(selected)
              fzf_lua.files({
                cwd = selected[1],
              })
            end,
          },
          ["ctrl-d"] = {
            function(selected)
              local choice = vim.fn.confirm("Delete '" .. selected[1] .. "' from project list?", "&Yes\n&No", 2)
              if choice == 1 then
                history.delete_project({ value = selected[1] })
              end
            end,
            fzf_lua.actions.resume,
          },
        },
      })
    end, { bang = true })
    vim.keymap.set("n", "<leader>fp", "<cmd>FzfProjects<cr>", { noremap = true, silent = true, desc = "Open project history" })
  end,
  keys = { { "<leader>fp" }, desc = "Open project history" },
}
