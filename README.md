# nvim_config

一套 **跨平台统一** 的 Neovim 配置：Windows / WSL / Linux / macOS 共用同一份代码，通过 GitHub 同步。

- 插件管理：lazy.nvim
- LSP / DAP / 格式化和 lint：Mason + nvim-lspconfig + nvim-dap
- 语法解析：nvim-treesitter（legacy `master` 分支，见下）
- 版本管理：推荐 [bob](https://github.com/MordechaiHadad/bob) 管理 Neovim 本体（各平台同一套命令）

---

## 1. 快速部署

### Windows

```powershell
# 1) 用 bob 安装/切换 Neovim
winget install MordechaiHadad.Bob    # 或从 GitHub Releases 下载 bob
bob install stable
bob use stable

# 2) 配置仓库放到 %LOCALAPPDATA%\nvim
git clone git@github.com:ziboh/nvim_config.git "$env:LOCALAPPDATA\nvim"

# 3) 首次启动，等 Lazy 装完插件
nvim
```

### WSL / Linux

一条命令（脚本幂等，已装的会自动跳过）：

```bash
git clone https://github.com/ziboh/nvim_config.git ~/nvim_config
bash ~/nvim_config/scripts/bootstrap.sh
# 如果用代理（中国大陆直连 GitHub 不稳）：
# bash ~/nvim_config/scripts/bootstrap.sh --proxy http://127.0.0.1:7890
```

脚本做的事：

1. `apt` 安装运行依赖：`git`、`ripgrep`、`build-essential`（编译 treesitter parser）、`unzip` + `python3-venv`（Mason 装包）、`wl-clipboard`（WSLg 剪贴板）
2. 安装 [bob](https://github.com/MordechaiHadad/bob) 到 `~/.local/bin/bob`，`bob install stable && bob use stable`
3. 把配置仓库放到 `~/.config/nvim`（若已存在会先备份为 `nvim.bak.<时间戳>`）
4. 执行 `nvim --headless "+Lazy! sync" +qa` 预装全部插件

### macOS

```bash
brew install neovim ripgrep        # 可选: brew install --cask font-jetbrains-mono-nerd-font
git clone git@github.com:ziboh/nvim_config.git ~/.config/nvim
nvim
```

---

## 2. 日常同步流程

配置仓库是唯一事实来源，任何平台的改动都走同一条路径：

```bash
# 拉取其他机器的改动
cd ~/.config/nvim && git pull
nvim "+Lazy sync"          # 同步插件（有插件增减时执行）

# 本机改了配置 → 提交回仓库
git add -A && git commit -m "feat: xxx" && git push
```

Windows 侧配置目录是 `%LOCALAPPDATA%\nvim`，WSL/Linux/macOS 是 `~/.config/nvim`，都是**同一个 git 仓库**。

---

## 3. 跨平台约定（保证「一套代码」能跑通）

| 约定 | 说明 |
| --- | --- |
| 平台判断 | 统一走 `Utils.is_win()` / `Utils.is_linux()`（`lua/utils/init.lua:507-512`）以及 `vim.fn.has("win32")`，禁止硬编码绝对路径 |
| 插件版本 | `lazy-lock.json` **不入库**（各机器独立浮动）。因此**关键插件必须在 spec 里显式钉住分支/版本**，否则新机器 clone 会拿到不兼容的新版 |
| treesitter | 两个插件都钉 `branch = "master"`（`lua/plugins/treesitter.lua:3-4` 与 `:63-64`）。新 `main` 是重写版，删除了 `nvim-treesitter.configs` API，本配置用的是 legacy API |
| 网络加速 | `lua/lazy-setup.lua` 内置 [ghfast.top](https://ghfast.top) 镜像（lazy 自身 bootstrap + `git.url_format`）；Mason 下载模板见 `lua/plugins/lsp/init.lua`。需要直连代理时再设 `http_proxy` / `https_proxy` 环境变量 |
| 剪贴板 | `opt.clipboard = "unnamedplus"`（`lua/options.lua:93`）：Linux 需要 `wl-clipboard`（Wayland/WSLg），远程场景可用 `lua/plugins/osc52.lua` |
| 依赖隔离 | 平台独有插件用 `enabled = Utils.is_win()/is_linux()` 开关（如 `lua/plugins/lang/autohotkey.lua` 仅 Windows，`lua/plugins/sudo.lua` 仅 Linux） |

---

## 4. 系统依赖速查

| 用途 | Windows | Linux / WSL |
| --- | --- | --- |
| 编辑器本体 | bob（`bob install stable`） | bob（脚本自动装） |
| 全局搜索 (`grepprg = "rg --vimgrep"`) | `winget install BurntSushi.ripgrep.MSVC` | `apt install ripgrep` |
| treesitter 编译 parser | MSVC / clang（bob 环境自带） | `apt install build-essential` |
| Mason 解压安装包 | 自带 | `apt install unzip` |
| Mason 建 venv（debugpy） | 自带 | `apt install python3-venv` |
| 剪贴板 | 原生 | `apt install wl-clipboard`（WSL 走 WSLg） |
| rime_ls（中文输入法 LSP） | 内置依赖检查 | 需 `clang` + `librime-dev`，缺失时仅告警不影响启动 |

---

## 5. 排错记录

真实踩过的坑，按报错原文检索：

**`module 'nvim-treesitter.configs' not found`**
克隆/更新后 treesitter 被拉到新版 `main` 分支（重写版已删除该模块）。本配置已钉 `branch = "master"`；若仍出现，检查 `lua/plugins/treesitter.lua` 的 `branch` 是否还在，或执行
`git -C ~/.local/share/nvim/lazy/nvim-treesitter log --oneline -1` 确认停留在 master 血统。

**treesitter 一个 parser 都没编译出来**
缺 C 编译器。装 `build-essential`（Linux/WSL）后重跑
`nvim --headless -c "lua require('lazy').load({plugins={'nvim-treesitter'}})" -c "TSInstallSync <lang...>" -c "qa!"`。
注意：treesitter 是 `VeryLazy` 懒加载，裸 headless 直接用 `TSInstall*` 会报 `E492: Not an editor command`，必须先 `lazy.load`。

**Mason 装包报 `Failed to spawn process. cmd="unzip", err="ENOENT"`**
缺 `unzip`，`apt install unzip` 即可（selene / stylua / codelldb 都走 unzip）。

**Mason 装 debugpy 报 `ensurepip is not available`**
缺 `python3-venv`，`apt install python3-venv`。

**Mason 装 codelldb 报 `Installation was aborted.` 或 `".../mason/bin/codelldb" is already linked.`**
上一次被中断的安装留下残留（`mason/bin/<pkg>` 软链、`mason/opt/lldb` 半成品目录），mason 在最后的 link 阶段冲突并整体回滚。清理后重装：

```bash
rm -rf ~/.local/share/nvim/mason/packages/codelldb ~/.local/share/nvim/mason/opt/lldb
rm -f  ~/.local/share/nvim/mason/bin/codelldb
# 再执行 :MasonInstall codelldb
```

**安装过程中 `Neovim is exiting while packages are still installing`**
安装没结束就退出编辑器（或杀掉 headless 进程）会中止并回滚。等 `:Mason` 面板里的进度跑完再退出。

**`vim.treesitter.language.add("rust")` 返回 nil**
正常现象：不指定路径时它只在 Neovim 自带的 parser 目录里找（自带 `c/lua/markdown/query/vim/vimdoc`）。实际编辑文件时走 `vim.treesitter.get_parser(buf)`，会正确加载 `lazy/nvim-treesitter/parser/*.so`。验证方式：

```bash
nvim --headless some.rs -c "lua print(pcall(vim.treesitter.get_parser, 0))" -c "qa!"
```

---

## 6. 目录结构

```
init.lua                 入口：options / lazy-setup / utils / folding / keymaps / autocmd / colorscheme
lua/lazy-setup.lua       lazy.nvim 引导（含 ghfast.top 镜像）
lua/options.lua          编辑器选项
lua/keymaps.lua          全局键位
lua/utils/               平台判断、LSP、lualine、root 等工具函数
lua/plugins/             插件 spec（按功能分文件，lang/ 下按语言分）
after/                   ftplugin / 语法等后置配置
scripts/bootstrap.sh     WSL / Linux 一键部署
```
