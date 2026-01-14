#!/bin/bash
#
# Nanobanana MCP Installer
# 一鍵安裝 Claude Code 圖片生成工具
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Nanobanana MCP Installer           ║${NC}"
echo -e "${GREEN}║     Claude Code 圖片生成工具           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# Check requirements
info "檢查必要工具..."

if ! command -v node &> /dev/null; then
    error "需要 Node.js >= 18。請先安裝：https://nodejs.org/"
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    error "Node.js 版本需要 >= 18，目前版本：$(node -v)"
fi
success "Node.js $(node -v)"

if ! command -v npm &> /dev/null; then
    error "需要 npm。請先安裝 Node.js。"
fi
success "npm $(npm -v)"

if ! command -v claude &> /dev/null; then
    error "需要 Claude Code CLI。請先安裝：npm install -g @anthropic-ai/claude-code"
fi
success "Claude Code CLI"

echo ""

# Get API Key
info "設定 Gemini API Key..."
echo ""
echo "請前往 https://aistudio.google.com/apikey 取得 API Key"
echo ""

if [ -n "$NANOBANANA_GEMINI_API_KEY" ]; then
    echo -e "偵測到現有的 NANOBANANA_GEMINI_API_KEY: ${YELLOW}${NANOBANANA_GEMINI_API_KEY:0:10}...${NC}"
    read -p "使用現有的 API Key? [Y/n] " use_existing
    if [[ "$use_existing" =~ ^[Nn] ]]; then
        read -p "請輸入新的 Gemini API Key: " NANOBANANA_GEMINI_API_KEY
    fi
else
    read -p "請輸入 Gemini API Key: " NANOBANANA_GEMINI_API_KEY
fi

if [ -z "$NANOBANANA_GEMINI_API_KEY" ]; then
    error "API Key 不能為空"
fi

echo ""

# Select model
info "選擇圖片生成模型..."
echo ""
echo "可用模型："
echo "  1) gemini-3-pro-image-preview (Nano Banana Pro，預設)"
echo "  2) gemini-2.5-flash-image"
echo ""
read -p "請選擇 [1-2，預設 1]: " model_choice

case "$model_choice" in
    2) NANOBANANA_MODEL="gemini-2.5-flash-image" ;;
    *) NANOBANANA_MODEL="gemini-3-pro-image-preview" ;;
esac

success "使用模型：$NANOBANANA_MODEL"
echo ""

# Add MCP server
info "設定 MCP Server..."

# Remove existing if present
claude mcp remove nanobanana 2>/dev/null || true

# Add new MCP server
claude mcp add nanobanana \
    -e NANOBANANA_GEMINI_API_KEY="$NANOBANANA_GEMINI_API_KEY" \
    -e NANOBANANA_MODEL="$NANOBANANA_MODEL" \
    -- npx -y @willh/nano-banana-mcp

success "MCP Server 已設定"
echo ""

# Download and install commands
info "安裝 Commands..."

COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$COMMANDS_DIR"

# Download commands from GitHub
REPO_URL="https://raw.githubusercontent.com/yazelin/nanobanana/main/commands"
COMMANDS=("nanobanana" "generate" "edit" "restore" "icon" "pattern" "story" "diagram")

for cmd in "${COMMANDS[@]}"; do
    curl -fsSL "$REPO_URL/$cmd.md" -o "$COMMANDS_DIR/$cmd.md" 2>/dev/null || {
        warn "無法下載 $cmd.md，將使用本地備份..."
    }
done

success "Commands 已安裝到 $COMMANDS_DIR"
echo ""

# Save to shell profile
info "是否將環境變數加入 shell 設定檔？"
echo ""
read -p "加入到 ~/.bashrc? [y/N] " add_to_bashrc

if [[ "$add_to_bashrc" =~ ^[Yy] ]]; then
    SHELL_RC="$HOME/.bashrc"

    # Check if already exists
    if grep -q "NANOBANANA_GEMINI_API_KEY" "$SHELL_RC" 2>/dev/null; then
        warn "NANOBANANA_GEMINI_API_KEY 已存在於 $SHELL_RC，跳過..."
    else
        echo "" >> "$SHELL_RC"
        echo "# Nanobanana MCP Configuration" >> "$SHELL_RC"
        echo "export NANOBANANA_GEMINI_API_KEY=\"$NANOBANANA_GEMINI_API_KEY\"" >> "$SHELL_RC"
        echo "export NANOBANANA_MODEL=\"$NANOBANANA_MODEL\"" >> "$SHELL_RC"
        success "已加入到 $SHELL_RC"
    fi
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          安裝完成！                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "使用方式："
echo "  1. 重啟 Claude Code (或開新 terminal 執行 claude)"
echo "  2. 使用指令："
echo "     /generate 一隻可愛的貓咪"
echo "     /nanobanana 幫我做一張早安圖"
echo ""
echo "更多資訊：https://github.com/yazelin/nanobanana"
echo ""
