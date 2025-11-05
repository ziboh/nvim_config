# Neovim 配置库

## 项目概述

这是一个高度定制化的 Neovim 配置库，使用现代 Lua 配置方式，提供 IDE 级别的编辑体验。该配置使用 Lazy.nvim 作为插件管理器，并包含丰富的插件生态系统，支持多种编程语言的开发。配置中集成了 AI 功能（FittenCode、SuperMaven）、调试工具、终端集成、LSP 支持、树形视图等高级功能。

## 主要特性

- **插件管理**: 使用 Lazy.nvim 管理插件，支持延迟加载以提高启动速度
- **LSP 集成**: 通过 mason.nvim 自动管理语言服务器
- **AI 增强**: 集成了 FittenCode 和 SuperMaven AI 编程助手
- **调试支持**: 集成了 DAP (Debug Adapter Protocol) 调试功能
- **终端集成**: 内置终端支持，集成 btm 等工具
- **中文支持**: 集成了 Rime 输入法支持，有中文注释和函数
- **主题**: 使用 tokyonight 主题，并有自定义高亮设置
- **状态栏**: 使用 heirline.nvim 创建功能丰富的状态栏
- **文件浏览**: 使用 snacks.nvim 提供的文件浏览功能

## 核心配置文件

- `init.lua` - 主配置文件，导入所有模块
- `lua/options.lua` - Vim 选项和设置
- `lua/lazy-setup.lua` - Lazy 插件管理器配置
- `lua/keymaps.lua` - 键位映射配置
- `lua/autocmd.lua` - 自动命令配置
- `lua/colorcheme.lua` - 颜色主题配置
- `lua/utils/` - 实用工具函数
- `lua/plugins/` - 插件配置文件

## 开发环境

- 使用 Nushell (`nu`) 作为默认 shell
- 对多种编程语言提供完善的语法高亮和代码补全（通过 TreeSitter）
- 集成 Git 操作功能
- 包含现代化的 UI 组件和提示系统

## 插件生态系统

包含大量插件，主要分为：

- **编辑增强**: mini.nvim 套件 (pairs, ai, surround, etc.), flash.nvim
- **代码补全**: blink-cmp, nvim-ts-autotag
- **调试工具**: nvim-dap 套件
- **LSP 增强**: lsp 配置、lspkind、lsp_signature
- **搜索替换**: telescope.nvim, gx.nvim
- **代码格式化**: conform.nvim, lint-nvim
- **代码导航**: treesitter, trouble.nvim
- **UI 组件**: snacks.nvim, noice.nvim, heirline.nvim

## 快捷键约定

- Leader 键设置为空格键 (`<Space>`)
- 大量使用 `<leader>` + 字母的组合
- 集成了功能丰富的按键提示系统 (which-key)

## 构建和运行

启动 Neovim 即可自动加载配置。首次运行时会自动安装 Lazy.nvim 和其他插件。

```bash
nvim
```

要安装/更新插件，可以在 Neovim 中运行：
- `:Lazy` - 打开 Lazy 插件管理器界面
- `:Mason` - 打开 Mason LSP/DAP/格式化工具管理器

## 开发约定

- 使用 Lua 编写配置
- 遵循模块化设计，按功能拆分配置文件
- 包含中文注释，支持中英文混合开发
- 使用现代化的 Neovim API

该配置适合需要现代化开发体验、对 AI 工具和中文支持有需求的开发者使用。

## 依赖

- Neovim 0.9+ 
- Git (用于插件安装)
- 一些插件可能需要特定的外部工具 (如 ripgrep 用于搜索)
