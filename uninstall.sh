#!/bin/bash
#
# Nanobanana MCP Uninstaller
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo ""
echo "Nanobanana MCP Uninstaller"
echo "=========================="
echo ""

# Remove MCP server
info "移除 MCP Server..."
claude mcp remove nanobanana 2>/dev/null && echo "  已移除" || warn "  MCP server 不存在"

# Remove commands
info "移除 Commands..."
COMMANDS=("nanobanana" "generate" "edit" "restore" "icon" "pattern" "story" "diagram")
for cmd in "${COMMANDS[@]}"; do
    rm -f "$HOME/.claude/commands/$cmd.md" 2>/dev/null && echo "  已移除 $cmd.md" || true
done

echo ""
warn "注意：環境變數 (GOOGLE_API_KEY, NANOBANANA_MODEL) 需手動從 ~/.bashrc 移除"
echo ""
info "解除安裝完成！"
echo ""
