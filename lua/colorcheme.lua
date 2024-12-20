local colorscheme = "astrodark"

local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

-- 设置垂直分割线的显示字符和颜色
vim.opt.fillchars:append {
  vert = "│", -- 使用 Unicode 字符来显示垂直分割线
  horiz = "─", -- 水平分割线
  vertleft = "│",
  vertright = "│",
  horizup = "─",
  horizdown = "─",
}

-- 创建一个更显眼的分割线高亮
vim.cmd [[
  highlight WinSeparator guibg=NONE guifg=#504945
  highlight VertSplit guibg=NONE guifg=#504945
]]
