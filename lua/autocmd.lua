-- LazyFile
-- 创建一个新的用户事件
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("lazy_file", { clear = true }),
  callback = function()
    -- 确保只触发一次
    vim.api.nvim_del_augroup_by_name("lazy_file")
    -- 触发 User LazyFile 事件
    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile" })
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

-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = function()
--     local ignore_bufs = { "TelescopePrompt", "TelescopeResults", "TelescopePreview", "NvimTree","xxd" }
--     if vim.tbl_contains(ignore_bufs, vim.bo.filetype) then
--       return
--     end
--     vim.wo.foldmethod = "expr"
--     vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--   end,
-- })
