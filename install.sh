#!/bin/bash
#
# Nanobanana MCP Installer
# Claude Code 圖片生成工具 - 一鍵安裝
#
# 使用方式：
#   ./install.sh          安裝
#   ./install.sh --help   顯示說明
#   ./install.sh --uninstall  解除安裝
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Print functions
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error_msg() { echo -e "${RED}[ERROR]${NC} $1"; }

# Show header
show_header() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                                ║${NC}"
    echo -e "${GREEN}║     ${BOLD}Nanobanana MCP Installer${NC}${GREEN}                                  ║${NC}"
    echo -e "${GREEN}║     Claude Code 圖片生成工具                                   ║${NC}"
    echo -e "${GREEN}║                                                                ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Show help
show_help() {
    show_header
    echo "使用方式："
    echo "  ./install.sh              執行安裝"
    echo "  ./install.sh --help       顯示此說明"
    echo "  ./install.sh --uninstall  解除安裝"
    echo ""
    echo "前置需求："
    echo "  1. Node.js >= 18"
    echo "  2. npm"
    echo "  3. Claude Code CLI"
    echo "  4. Gemini API Key（需付費使用圖片生成功能）"
    echo ""
    echo "更多資訊：https://github.com/yazelin/nanobanana"
    echo ""
    exit 0
}

# Show uninstall
do_uninstall() {
    show_header
    info "開始解除安裝 Nanobanana..."
    echo ""

    # Remove MCP server
    if command -v claude &> /dev/null; then
        info "移除 MCP Server..."
        claude mcp remove nanobanana 2>/dev/null && success "MCP Server 已移除" || warn "MCP Server 不存在或已移除"
    fi

    # Remove commands
    info "移除 Commands..."
    COMMANDS_DIR="$HOME/.claude/commands"
    COMMANDS=("nanobanana" "generate" "edit" "restore" "icon" "pattern" "story" "diagram")
    for cmd in "${COMMANDS[@]}"; do
        rm -f "$COMMANDS_DIR/$cmd.md" 2>/dev/null
    done
    success "Commands 已移除"

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                     解除安裝完成！                             ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "注意：環境變數需手動從 ~/.bashrc 或 ~/.zshrc 移除："
    echo "  - NANOBANANA_GEMINI_API_KEY"
    echo "  - NANOBANANA_MODEL"
    echo ""
    exit 0
}

# ============================================================
# Node.js 安裝引導
# ============================================================
show_nodejs_install_guide() {
    echo ""
    echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}                    Node.js 未安裝                              ${NC}"
    echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Nanobanana 需要 Node.js 18 或更新版本才能運作。"
    echo ""
    echo -e "${YELLOW}請選擇以下其中一種方式安裝 Node.js：${NC}"
    echo ""
    echo -e "${CYAN}【方法 1】使用 nvm（推薦，最簡單）${NC}"
    echo ""
    echo "  步驟 1：安裝 nvm"
    echo "  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash"
    echo ""
    echo "  步驟 2：重新開啟終端機，或執行："
    echo "  source ~/.bashrc"
    echo ""
    echo "  步驟 3：安裝 Node.js 22（LTS）"
    echo "  nvm install 22"
    echo ""
    echo -e "${CYAN}【方法 2】使用系統套件管理器${NC}"
    echo ""
    echo "  Ubuntu/Debian："
    echo "  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -"
    echo "  sudo apt-get install -y nodejs"
    echo ""
    echo "  macOS（使用 Homebrew）："
    echo "  brew install node"
    echo ""
    echo -e "${CYAN}【方法 3】從官網下載${NC}"
    echo ""
    echo "  前往 https://nodejs.org/"
    echo "  下載 LTS 版本並依照指示安裝"
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "安裝完成後，請重新執行此安裝腳本："
    echo "  ./install.sh"
    echo ""
    exit 1
}

# ============================================================
# Node.js 版本過低引導
# ============================================================
show_nodejs_upgrade_guide() {
    local current_version=$1
    echo ""
    echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}                 Node.js 版本過低                               ${NC}"
    echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "目前版本：$current_version"
    echo "需要版本：>= 18"
    echo ""
    echo -e "${YELLOW}請升級 Node.js：${NC}"
    echo ""
    echo -e "${CYAN}如果使用 nvm：${NC}"
    echo "  nvm install 22"
    echo "  nvm use 22"
    echo "  nvm alias default 22"
    echo ""
    echo -e "${CYAN}如果使用系統套件：${NC}"
    echo "  請參考上方 Node.js 安裝方法重新安裝較新版本"
    echo ""
    echo -e "${CYAN}如果從官網安裝：${NC}"
    echo "  前往 https://nodejs.org/ 下載最新 LTS 版本"
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "升級完成後，請重新執行此安裝腳本："
    echo "  ./install.sh"
    echo ""
    exit 1
}

# ============================================================
# Claude CLI 安裝引導
# ============================================================
show_claude_cli_install_guide() {
    echo ""
    echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}                 Claude Code CLI 未安裝                         ${NC}"
    echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Nanobanana 是 Claude Code 的擴充工具，需要先安裝 Claude Code CLI。"
    echo ""
    echo -e "${YELLOW}安裝步驟：${NC}"
    echo ""
    echo -e "${CYAN}步驟 1：${NC}使用 npm 全域安裝 Claude Code"
    echo ""
    echo "  npm install -g @anthropic-ai/claude-code"
    echo ""
    echo -e "${CYAN}步驟 2：${NC}驗證安裝成功"
    echo ""
    echo "  claude --version"
    echo ""
    echo -e "${CYAN}步驟 3：${NC}首次執行 Claude Code（需登入）"
    echo ""
    echo "  claude"
    echo ""
    echo "  首次執行會引導你登入 Anthropic 帳號或設定 API Key。"
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${BLUE}常見問題：${NC}"
    echo ""
    echo "  Q: 出現權限錯誤 (EACCES)？"
    echo "  A: 使用以下指令修復 npm 權限："
    echo "     mkdir -p ~/.npm-global"
    echo "     npm config set prefix '~/.npm-global'"
    echo "     echo 'export PATH=~/.npm-global/bin:\$PATH' >> ~/.bashrc"
    echo "     source ~/.bashrc"
    echo "     然後重新執行 npm install -g @anthropic-ai/claude-code"
    echo ""
    echo "  Q: 什麼是 Claude Code？"
    echo "  A: Claude Code 是 Anthropic 推出的 AI 程式設計助手，"
    echo "     可以在終端機中直接與 Claude 對話、操作檔案、執行指令。"
    echo "     官網：https://claude.ai/claude-code"
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "安裝完成後，請重新執行此安裝腳本："
    echo "  ./install.sh"
    echo ""
    exit 1
}

# ============================================================
# API Key 取得引導
# ============================================================
show_api_key_guide() {
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}                    如何取得 Gemini API Key                      ${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}步驟 1：${NC} 開啟 Google AI Studio"
    echo "         前往 https://aistudio.google.com/apikey"
    echo ""
    echo -e "${CYAN}步驟 2：${NC} 登入 Google 帳號"
    echo "         使用你的 Google 帳號登入（如果尚未登入）"
    echo ""
    echo -e "${CYAN}步驟 3：${NC} 建立 API Key"
    echo "         點擊「Create API Key」或「建立 API 金鑰」按鈕"
    echo "         選擇一個 Google Cloud 專案（或建立新專案）"
    echo ""
    echo -e "${CYAN}步驟 4：${NC} 設定帳單（圖片生成必須）"
    echo "         前往 https://ai.google.dev/gemini-api/docs/billing"
    echo "         依照指示設定 Google Cloud 帳單"
    echo ""
    echo -e "${CYAN}步驟 5：${NC} 複製 API Key"
    echo "         API Key 會顯示在畫面上，格式類似："
    echo -e "         ${GREEN}AIzaSy...（約 39 個字元）${NC}"
    echo "         點擊複製按鈕或手動選取複製"
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${RED}重要提醒：${NC}"
    echo "  • 圖片生成功能${BOLD}需要付費${NC}（約 \$0.02-0.04 美元/張）"
    echo "  • 必須設定 Google Cloud 帳單才能使用圖片生成"
    echo "  • 請妥善保管你的 API Key，不要分享給他人"
    echo "  • 如果 Key 外洩，可以到 AI Studio 刪除並重新建立"
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ============================================================
# API Key 未設定引導
# ============================================================
show_api_key_missing_guide() {
    echo ""
    echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}                       API Key 未設定                            ${NC}"
    echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "安裝無法繼續，因為 Nanobanana 需要 Gemini API Key 才能運作。"
    echo ""
    echo -e "${YELLOW}您可以透過以下方式重新執行安裝：${NC}"
    echo ""
    echo "  方法 1：直接重新執行此安裝腳本"
    echo "          ./install.sh"
    echo ""
    echo "  方法 2：先設定環境變數再執行安裝"
    echo -e "          export ${GREEN}NANOBANANA_GEMINI_API_KEY${NC}=\"你的API金鑰\""
    echo "          ./install.sh"
    echo ""
    echo -e "  環境變數名稱：${GREEN}NANOBANANA_GEMINI_API_KEY${NC}"
    echo ""
    echo -e "${BLUE}取得 API Key：${NC} https://aistudio.google.com/apikey"
    echo ""
    echo -e "${YELLOW}常見問題：${NC}"
    echo ""
    echo "  Q: 為什麼需要 API Key？"
    echo "  A: Nanobanana 使用 Google Gemini 的圖片生成功能，需要 API Key 驗證。"
    echo ""
    echo "  Q: API Key 要收費嗎？"
    echo "  A: 圖片生成功能需要付費（約 \$0.02-0.04 美元/張）。"
    echo "     必須在 Google Cloud 設定帳單才能使用。"
    echo "     詳見：https://ai.google.dev/gemini-api/docs/pricing"
    echo ""
    echo "  Q: 我找不到建立 API Key 的按鈕？"
    echo "  A: 請確認已登入 Google 帳號，並同意 Google AI Studio 的服務條款。"
    echo ""
    echo "  Q: 我已經建立了 API Key 但還是無法生圖？"
    echo "  A: 請確認已設定 Google Cloud 帳單。圖片生成功能不在免費額度內。"
    echo ""
    exit 1
}

# ============================================================
# MCP 設定失敗引導
# ============================================================
show_mcp_setup_failed_guide() {
    echo ""
    echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}                    MCP Server 設定失敗                          ${NC}"
    echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "自動設定 MCP Server 時發生錯誤。"
    echo ""
    echo -e "${YELLOW}請嘗試手動設定：${NC}"
    echo ""
    echo "  步驟 1：確認 Claude CLI 正常運作"
    echo "  claude --version"
    echo ""
    echo "  步驟 2：手動加入 MCP Server"
    echo "  claude mcp add nanobanana \\"
    echo "    -e NANOBANANA_GEMINI_API_KEY=\"你的API金鑰\" \\"
    echo "    -e NANOBANANA_MODEL=\"gemini-3-pro-image-preview\" \\"
    echo "    -- npx -y @willh/nano-banana-mcp"
    echo ""
    echo -e "${YELLOW}常見問題：${NC}"
    echo ""
    echo "  Q: 出現 'claude: command not found'？"
    echo "  A: Claude CLI 未正確安裝，請執行："
    echo "     npm install -g @anthropic-ai/claude-code"
    echo ""
    echo "  Q: 出現權限錯誤？"
    echo "  A: 請確認你有足夠的權限存取 ~/.claude/ 目錄"
    echo ""
    exit 1
}

# ============================================================
# Commands 下載失敗引導
# ============================================================
show_commands_download_failed_guide() {
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}              部分 Commands 下載失敗                             ${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "可能是網路問題，您可以稍後手動下載："
    echo ""
    echo "  步驟 1：複製 commands 資料夾"
    echo "  git clone https://github.com/yazelin/nanobanana.git /tmp/nanobanana"
    echo "  cp -r /tmp/nanobanana/commands/* ~/.claude/commands/"
    echo "  rm -rf /tmp/nanobanana"
    echo ""
    echo "  或直接從 GitHub 下載："
    echo "  https://github.com/yazelin/nanobanana/tree/main/commands"
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ============================================================
# Main Installation
# ============================================================

# Parse arguments
case "${1:-}" in
    --help|-h)
        show_help
        ;;
    --uninstall)
        do_uninstall
        ;;
esac

# Show header
show_header

# ============================================================
# 前置需求檢查
# ============================================================
echo -e "${BOLD}前置需求檢查${NC}"
echo "────────────────────────────────────────────────────────────────"
echo ""

# Check Node.js
info "檢查 Node.js..."
if ! command -v node &> /dev/null; then
    show_nodejs_install_guide
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    show_nodejs_upgrade_guide "$(node -v)"
fi
success "Node.js $(node -v)"

# Check npm
info "檢查 npm..."
if ! command -v npm &> /dev/null; then
    echo ""
    error_msg "npm 未安裝"
    echo ""
    echo "npm 通常會隨 Node.js 一起安裝。"
    echo "請重新安裝 Node.js：https://nodejs.org/"
    echo ""
    exit 1
fi
success "npm $(npm -v)"

# Check Claude CLI
info "檢查 Claude Code CLI..."
if ! command -v claude &> /dev/null; then
    show_claude_cli_install_guide
fi
success "Claude Code CLI $(claude --version 2>/dev/null | head -1 || echo '已安裝')"

echo ""
success "所有前置需求已滿足！"
echo ""

# ============================================================
# Gemini API Key 設定
# ============================================================
echo -e "${BOLD}設定 Gemini API Key${NC}"
echo "────────────────────────────────────────────────────────────────"
echo ""

if [ -n "${NANOBANANA_GEMINI_API_KEY:-}" ]; then
    echo -e "偵測到現有的 API Key: ${YELLOW}${NANOBANANA_GEMINI_API_KEY:0:10}...${NC}"
    read -p "使用現有的 API Key? [Y/n] " use_existing
    if [[ "$use_existing" =~ ^[Nn] ]]; then
        show_api_key_guide
        read -p "請輸入新的 Gemini API Key: " NANOBANANA_GEMINI_API_KEY
    fi
else
    echo "尚未設定 Gemini API Key。"
    echo ""
    read -p "是否需要查看取得 API Key 的詳細說明？[Y/n] " show_guide
    if [[ ! "$show_guide" =~ ^[Nn] ]]; then
        show_api_key_guide
    else
        echo ""
        echo "請前往 https://aistudio.google.com/apikey 取得 API Key"
        echo ""
    fi
    read -p "請輸入 Gemini API Key: " NANOBANANA_GEMINI_API_KEY
fi

# Validate API Key
if [ -z "$NANOBANANA_GEMINI_API_KEY" ]; then
    show_api_key_missing_guide
fi

# Basic format validation
if [[ ! "$NANOBANANA_GEMINI_API_KEY" =~ ^AIza ]]; then
    echo ""
    warn "API Key 格式可能不正確（通常以 'AIza' 開頭）"
    read -p "是否仍要繼續？[y/N] " continue_anyway
    if [[ ! "$continue_anyway" =~ ^[Yy] ]]; then
        echo ""
        echo "請重新執行安裝腳本並輸入正確的 API Key。"
        exit 1
    fi
fi

echo ""

# ============================================================
# 選擇模型
# ============================================================
echo -e "${BOLD}選擇圖片生成模型${NC}"
echo "────────────────────────────────────────────────────────────────"
echo ""
echo "可用模型："
echo -e "  ${GREEN}1)${NC} gemini-3-pro-image-preview ${YELLOW}(Nano Banana Pro，預設，品質較好)${NC}"
echo -e "  ${GREEN}2)${NC} gemini-2.5-flash-image ${YELLOW}(較快速)${NC}"
echo ""
read -p "請選擇 [1-2，按 Enter 使用預設]: " model_choice

case "$model_choice" in
    2) NANOBANANA_MODEL="gemini-2.5-flash-image" ;;
    *) NANOBANANA_MODEL="gemini-3-pro-image-preview" ;;
esac

success "使用模型：$NANOBANANA_MODEL"
echo ""

# ============================================================
# 設定 MCP Server
# ============================================================
echo -e "${BOLD}設定 MCP Server${NC}"
echo "────────────────────────────────────────────────────────────────"
echo ""

info "移除舊的設定（如果存在）..."
claude mcp remove nanobanana 2>/dev/null || true

info "加入 MCP Server..."
MCP_OUTPUT=$(claude mcp add nanobanana \
    -e NANOBANANA_GEMINI_API_KEY="$NANOBANANA_GEMINI_API_KEY" \
    -e NANOBANANA_MODEL="$NANOBANANA_MODEL" \
    -- npx -y @willh/nano-banana-mcp 2>&1)

if [ $? -ne 0 ]; then
    error_msg "MCP Server 設定失敗"
    echo ""
    echo -e "${YELLOW}錯誤訊息：${NC}"
    echo "$MCP_OUTPUT"
    echo ""
    show_mcp_setup_failed_guide
fi

# 驗證 MCP 是否已加入
if ! claude mcp list 2>/dev/null | grep -q "nanobanana"; then
    error_msg "MCP Server 未成功加入"
    echo ""
    show_mcp_setup_failed_guide
fi

success "MCP Server 已設定"
echo ""

# ============================================================
# 安裝 Commands
# ============================================================
echo -e "${BOLD}安裝 Commands${NC}"
echo "────────────────────────────────────────────────────────────────"
echo ""

COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$COMMANDS_DIR"

REPO_URL="https://raw.githubusercontent.com/yazelin/nanobanana/main/commands"
COMMANDS=("nanobanana" "generate" "edit" "restore" "icon" "pattern" "story" "diagram")
DOWNLOAD_FAILED=0

for cmd in "${COMMANDS[@]}"; do
    if curl -fsSL "$REPO_URL/$cmd.md" -o "$COMMANDS_DIR/$cmd.md" 2>/dev/null; then
        success "已安裝 /$cmd"
    else
        warn "無法下載 $cmd.md"
        DOWNLOAD_FAILED=1
    fi
done

if [ "$DOWNLOAD_FAILED" -eq 1 ]; then
    show_commands_download_failed_guide
fi

echo ""

# ============================================================
# 儲存環境變數（可選）
# ============================================================
echo -e "${BOLD}儲存設定（可選）${NC}"
echo "────────────────────────────────────────────────────────────────"
echo ""

# Detect shell
SHELL_NAME=$(basename "$SHELL")
case "$SHELL_NAME" in
    zsh)  SHELL_RC="$HOME/.zshrc" ;;
    bash) SHELL_RC="$HOME/.bashrc" ;;
    *)    SHELL_RC="$HOME/.bashrc" ;;
esac

echo "是否將環境變數加入 $SHELL_RC？"
echo "（這樣未來重新安裝時可以自動偵測 API Key）"
echo ""
read -p "加入環境變數? [y/N] " add_to_shell

if [[ "$add_to_shell" =~ ^[Yy] ]]; then
    if grep -q "NANOBANANA_GEMINI_API_KEY" "$SHELL_RC" 2>/dev/null; then
        warn "環境變數已存在於 $SHELL_RC，跳過..."
    else
        echo "" >> "$SHELL_RC"
        echo "# Nanobanana MCP Configuration" >> "$SHELL_RC"
        echo "export NANOBANANA_GEMINI_API_KEY=\"$NANOBANANA_GEMINI_API_KEY\"" >> "$SHELL_RC"
        echo "export NANOBANANA_MODEL=\"$NANOBANANA_MODEL\"" >> "$SHELL_RC"
        success "已加入到 $SHELL_RC"
    fi
fi

# ============================================================
# 安裝完成
# ============================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                                ║${NC}"
echo -e "${GREEN}║                      安裝完成！                                ║${NC}"
echo -e "${GREEN}║                                                                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}下一步：${NC}"
echo ""
echo "  1. 重啟 Claude Code（或開新終端機執行 ${CYAN}claude${NC}）"
echo ""
echo "  2. 試試看這些指令："
echo -e "     ${CYAN}/generate 一隻可愛的貓咪${NC}"
echo -e "     ${CYAN}/nanobanana 幫我做一張早安圖${NC}"
echo ""
echo -e "${BOLD}可用指令：${NC}"
echo "  /nanobanana  - 自然語言介面"
echo "  /generate    - 生成圖片"
echo "  /edit        - 編輯圖片"
echo "  /restore     - 修復圖片"
echo "  /icon        - 生成圖標"
echo "  /pattern     - 生成圖案"
echo "  /story       - 生成故事序列"
echo "  /diagram     - 生成流程圖"
echo ""
echo -e "${BOLD}更多資訊：${NC}"
echo "  GitHub: https://github.com/yazelin/nanobanana"
echo "  解除安裝: ./install.sh --uninstall"
echo ""
