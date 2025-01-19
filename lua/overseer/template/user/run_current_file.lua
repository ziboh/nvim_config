exec_table = {
  autohotkey = {
    bin = "autohotkey.exe",
  },
  python = {
    bin = "python",
  },
}
vim.fn.executable("autohotkey.exe")
return {
  name = "Run current file",
  builder = function(params)
    local filetype = vim.bo.filetype
    local bin = exec_table[filetype].bin
    local current_file = vim.fn.expand("%:p")
    local cwd = vim.fn.getcwd()
    return {
      cmd = { bin },
      args = { current_file },
      cwd = cwd,
    }
  end,
  condition = {
    callback = function(search)
      local opt = exec_table[search.filetype]
      if opt == nil or vim.fn.executable(opt.bin) == 0 then
        return false
      end
      return true
    end,
  },
}
