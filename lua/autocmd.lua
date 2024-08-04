local autocmd = vim.api.nvim_create_autocmd
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
})

if require("utils").is_available "alpha-nvim" then
  autocmd({ "User", "BufEnter" }, {
    desc = "Disable status and tablines for alpha",
    callback = function(args)
      local is_filetype_alpha = vim.api.nvim_get_option_value("filetype", { buf = 0 }) == "alpha"
      local is_empty_file = vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "nofile"
      if
        ((args.event == "User" and args.file == "AlphaReady") or (args.event == "BufEnter" and is_filetype_alpha))
        and not vim.g.before_alpha
      then
        vim.g.before_alpha = {
          showtabline = vim.opt.showtabline:get(),
          laststatus = vim.opt.laststatus:get(),
        }
        vim.opt.showtabline, vim.opt.laststatus = 0, 0
      elseif vim.g.before_alpha and args.event == "BufEnter" and not is_empty_file then
        vim.opt.laststatus = vim.g.before_alpha.laststatus
        vim.opt.showtabline = vim.g.before_alpha.showtabline
        vim.g.before_alpha = nil
      end
    end,
  })
  autocmd("VimEnter", {
    desc = "Start Alpha only when nvim is opened with no arguments",
    callback = function()
      -- Precalculate conditions.
      local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
      local buf_not_empty = vim.fn.argc() > 0 or #lines > 1 or (#lines == 1 and lines[1]:len() > 0)
      local buflist_not_empty = #vim.tbl_filter(
        function(bufnr) return vim.bo[bufnr].buflisted end,
        vim.api.nvim_list_bufs()
      ) > 1
      local buf_not_modifiable = not vim.o.modifiable

      -- Return instead of opening alpha if any of these conditions occur.
      if buf_not_modifiable or buf_not_empty or buflist_not_empty then return end
      for _, arg in pairs(vim.v.argv) do
        if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then return end
      end

      -- All good? Show alpha.
      require("alpha").start(true, require("alpha").default_config)
      vim.schedule(function() vim.cmd.doautocmd "FileType" end)
    end,
  })
end
-- 创建一个函数来设置键映射
local function set_keymaps()
  -- 设置文件类型为 myfiletype 的键映射
  vim.api.nvim_buf_set_keymap(0, "n", "<C-_>", "<Nop>", { noremap = true, silent = true }) -- 在普通模式下，<leader>w 保存文件
  vim.api.nvim_buf_set_keymap(0, "v", "<C-_>", "<Nop>", { noremap = true, silent = true }) -- 在普通模式下，<leader>q 退出文件
  vim.api.nvim_buf_set_keymap(0, "v", "<leader>/", "<Nop>", { noremap = true, silent = true }) -- 在普通模式下，<leader>q 退出文件
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>/", "<Nop>", { noremap = true, silent = true }) -- 在普通模式下，<leader>q 退出文件
end

-- 在自定义文件类型时调用 set_keymaps 函数
vim.api.nvim_create_autocmd("FileType", {
  pattern = "toggleterm",
  callback = set_keymaps,
})
