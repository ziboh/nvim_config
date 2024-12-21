local colorscheme = "tokyonight"

---@diagnostic disable-next-line: param-type-mismatch
local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

vim.api.nvim_set_hl(0, "VertSplit", { fg = "#504945" })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#504945" })

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#82aaff", bold = false })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#82aaff", bold = true })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#82aaff", bold = false })
