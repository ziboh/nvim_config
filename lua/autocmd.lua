-- 创建一个新的用户事件
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("file_user_events", { clear = true }),
  callback = function(args)
    if vim.b[args.buf].lazyfile_checked then
      return
    end
    vim.b[args.buf].lazyfile_checked = true
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end
      local current_file = vim.api.nvim_buf_get_name(args.buf)
      if vim.g.vscode or not (current_file == "" or vim.bo[args.buf].buftype == "nofile") then
        local skip_augroups = {}
        for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = args.event })) do
          if autocmd.group_name then
            skip_augroups[autocmd.group_name] = true
          end
        end
        skip_augroups["filetypedetect"] = false
        Utils.event("File")
        local folder = vim.fn.fnamemodify(current_file, ":p:h")
        if vim.fn.has("win32") == 1 then
          folder = ('"%s"'):format(folder)
        end
        if vim.fn.executable("git") == 1 then
          if Utils.cmd({ "git", "-C", folder, "rev-parse" }, false) or Utils.file_worktree() then
            Utils.event("GitFile")
            pcall(vim.api.nvim_del_augroup_by_name, "file_user_events")
          end
        else
          pcall(vim.api.nvim_del_augroup_by_name, "file_user_events")
        end
        vim.schedule(function()
          if Utils.is_valid(args.buf) then
            for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = args.event })) do
              if autocmd.group_name and not skip_augroups[autocmd.group_name] then
                vim.api.nvim_exec_autocmds(
                  args.event,
                  { group = autocmd.group_name, buffer = args.buf, data = args.data }
                )
                skip_augroups[autocmd.group_name] = true
              end
            end
          end
        end)
      end
    end)
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained" }, {
  pattern = { "*" },
  command = [[call setreg("@", getreg("+"))]],
})

-- sync with system clipboard on focus
vim.api.nvim_create_autocmd({ "FocusLost" }, {
  pattern = { "*" },
  command = [[call setreg("+", getreg("@"))]],
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = { "*" },
  command = [[call setreg("+", getreg("@"))]],
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "AvanteInput" },
  callback = function(env)
    local rime_ls_client = vim.lsp.get_clients({ name = "rime_ls" })
    -- 如果没有启动 `rime-ls` 就手动启动
    if #rime_ls_client == 0 then
      vim.cmd("LspStart rime_ls")
      rime_ls_client = vim.lsp.get_clients({ name = "rime_ls" })
    end
    -- `attach` 到 `buffer`
    if #rime_ls_client > 0 then
      vim.lsp.buf_attach_client(env.buf, rime_ls_client[1].id)
    end
  end,
})

vim.api.nvim_create_autocmd("TermEnter", {
  callback = function(ctx)
    vim.opt.titlestring = "terminal"
  end,
})

vim.api.nvim_create_autocmd("TermLeave", {
  callback = function()
    vim.opt.titlestring = "neovim"
  end,
})

vim.api.nvim_create_autocmd("CmdLineEnter", {
  pattern = "*",
  callback = function()
    vim.opt.titlestring = "command"
  end,
})

vim.api.nvim_create_autocmd("CmdLineLeave", {
  pattern = "*",
  callback = function()
    vim.opt.titlestring = "neovim"
  end,
})
