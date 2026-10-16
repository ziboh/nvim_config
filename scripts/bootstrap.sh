#!/usr/bin/env bash
# nvim_config 一键部署脚本（WSL / Linux）
#
#   bash scripts/bootstrap.sh [--proxy http://127.0.0.1:7890] [--no-plugins]
#
# 幂等：已安装的步骤会自动跳过。可重复执行。
set -euo pipefail

REPO_URL="${NVIM_CONFIG_REPO:-https://github.com/ziboh/nvim_config.git}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
BOB_VERSION="latest"
PROXY=""
SKIP_PLUGINS=0

while [ $# -gt 0 ]; do
  case "$1" in
    --proxy) PROXY="${2:-}"; shift 2 ;;
    --repo) REPO_URL="${2:-}"; shift 2 ;;
    --config-dir) CONFIG_DIR="${2:-}"; shift 2 ;;
    --no-plugins) SKIP_PLUGINS=1; shift ;;
    -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
    *) echo "未知参数: $1" >&2; exit 1 ;;
  esac
done

if [ -n "$PROXY" ]; then
  export http_proxy="$PROXY" https_proxy="$PROXY"
  export no_proxy="127.0.0.1,localhost"
  echo "== 使用代理: $PROXY"
fi

say() { printf '\n\033[1;36m== %s\033[0m\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# ---------------------------------------------------------------- 1. 系统依赖
say "1/4 系统依赖"
if have apt-get; then
  MISSING=()
  have git   || MISSING+=(git)
  have rg    || MISSING+=(ripgrep)
  have unzip || MISSING+=(unzip)
  have cc    || MISSING+=(build-essential)
  have make  || MISSING+=(build-essential)
  # Mason 建 venv 需要 ensurepip
  python3 -c 'import ensurepip' >/dev/null 2>&1 || MISSING+=(python3-venv)
  # WSL/Wayland 剪贴板（有 wl-copy 或 xclip 就够）
  if ! have wl-copy && ! have xclip; then MISSING+=(wl-clipboard); fi

  if [ ${#MISSING[@]} -eq 0 ]; then
    echo "依赖齐全，跳过"
  else
    # shellcheck disable=SC2207
    MISSING=($(printf '%s\n' "${MISSING[@]}" | sort -u))
    echo "需要安装: ${MISSING[*]}"
    if [ "$(id -u)" -eq 0 ]; then
      apt-get update -qq && apt-get install -y "${MISSING[@]}"
    elif have sudo; then
      sudo apt-get update -qq && sudo apt-get install -y "${MISSING[@]}"
    else
      echo "!! 没有 root/sudo，请手动安装后重跑: apt install ${MISSING[*]}" >&2
    fi
  fi
else
  echo "非 apt 系统，请自行确认已安装: git ripgrep unzip gcc make python3-venv 剪贴板工具"
fi

# ------------------------------------------------------------------- 2. bob
say "2/4 bob（Neovim 版本管理）"
BOB_BIN="$HOME/.local/bin/bob"
if [ -x "$BOB_BIN" ]; then
  echo "已安装: $("$BOB_BIN" --version 2>/dev/null || echo bob)"
else
  mkdir -p "$HOME/.local/bin"
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64|amd64) ASSET="bob-linux-x86_64.zip" ;;
    aarch64|arm64) ASSET="bob-linux-arm64.zip" ;;
    *) echo "!! 不支持的架构: $ARCH，请手动安装 bob" >&2; ASSET="" ;;
  esac
  if [ -n "$ASSET" ]; then
    URL="https://ghfast.top/https://github.com/MordechaiHadad/bob/releases/latest/download/$ASSET"
    TMP="$(mktemp -d)"
    echo "下载 $ASSET ..."
    if have curl; then curl -fsSL "$URL" -o "$TMP/bob.zip"; else wget -qO "$TMP/bob.zip" "$URL"; fi
    python3 -m zipfile -e "$TMP/bob.zip" "$TMP/out"
    install -m 755 "$(find "$TMP/out" -name bob -type f | head -1)" "$BOB_BIN"
    rm -rf "$TMP"
    echo "已安装到 $BOB_BIN"
  fi
fi

export PATH="$HOME/.local/share/bob/nvim-bin:$HOME/.local/bin:$PATH"
if [ -x "$BOB_BIN" ]; then
  "$BOB_BIN" install stable
  "$BOB_BIN" use stable
fi
if ! have nvim; then
  echo "!! PATH 里找不到 nvim。请确认 shell 配置包含：" >&2
  echo '   export PATH="$HOME/.local/share/bob/nvim-bin:$HOME/.local/bin:$PATH"' >&2
  echo "   （bash: ~/.bashrc / nushell: ~/.config/nushell/env.nu）" >&2
fi

# ------------------------------------------------------------- 3. 配置仓库
say "3/4 配置仓库 → $CONFIG_DIR"
if [ -d "$CONFIG_DIR/.git" ]; then
  echo "已存在 git 仓库，执行 pull"
  git -C "$CONFIG_DIR" pull --ff-only || echo "!! pull 失败（本地有改动？），请手动处理"
elif [ -e "$CONFIG_DIR" ]; then
  BAK="$CONFIG_DIR.bak.$(date +%Y%m%d%H%M%S)"
  echo "目标已存在且不是 git 仓库，备份到 $BAK"
  mv "$CONFIG_DIR" "$BAK"
  git clone "$REPO_URL" "$CONFIG_DIR"
else
  git clone "$REPO_URL" "$CONFIG_DIR"
fi

# ------------------------------------------------------------------ 4. 插件
say "4/4 预装插件（Lazy sync）"
if [ "$SKIP_PLUGINS" -eq 1 ]; then
  echo "已跳过（--no-plugins）"
elif have nvim; then
  nvim --headless "+Lazy! sync" +qa && echo "插件同步完成"
else
  echo "跳过（未找到 nvim），首次启动 nvim 会自动安装"
fi

say "完成"
cat <<EOF
配置目录: $CONFIG_DIR
Neovim  : $(nvim --version 2>/dev/null | head -1 || echo "未就绪")

后续常用操作：
  nvim                启动
  :Lazy sync          同步插件（配置有插件增减时）
  :Mason              查看/补装 LSP、DAP、格式化工具
  :checkhealth        环境自检

排错见仓库 README 第 5 节。
EOF
