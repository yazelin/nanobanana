#
# Nanobanana MCP Installer for Windows
# Claude Code 圖片生成工具 - 一鍵安裝
#
# 使用方式：
#   .\install.ps1            安裝
#   .\install.ps1 -Help      顯示說明
#   .\install.ps1 -Uninstall 解除安裝
#

param(
    [switch]$Help,
    [switch]$Uninstall
)

# Ensure UTF-8 output
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

# ============================================================
# Helper Functions
# ============================================================

function Write-Info { param([string]$Message) Write-Host "[INFO] " -ForegroundColor Blue -NoNewline; Write-Host $Message }
function Write-Success { param([string]$Message) Write-Host "[OK] " -ForegroundColor Green -NoNewline; Write-Host $Message }
function Write-Warn { param([string]$Message) Write-Host "[WARN] " -ForegroundColor Yellow -NoNewline; Write-Host $Message }
function Write-Error2 { param([string]$Message) Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host $Message }

function Show-Header {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host "                                                                " -ForegroundColor Green
    Write-Host "     Nanobanana MCP Installer                                   " -ForegroundColor Green
    Write-Host "     Claude Code 圖片生成工具                                   " -ForegroundColor Green
    Write-Host "                                                                " -ForegroundColor Green
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host ""
}

# ============================================================
# Show Help
# ============================================================
function Show-Help {
    Show-Header
    Write-Host "使用方式："
    Write-Host "  .\install.ps1              執行安裝"
    Write-Host "  .\install.ps1 -Help        顯示此說明"
    Write-Host "  .\install.ps1 -Uninstall   解除安裝"
    Write-Host ""
    Write-Host "前置需求："
    Write-Host "  1. Node.js >= 18"
    Write-Host "  2. npm"
    Write-Host "  3. Claude Code CLI"
    Write-Host "  4. Gemini API Key（需付費使用圖片生成功能）"
    Write-Host ""
    Write-Host "更多資訊：https://github.com/yazelin/nanobanana"
    Write-Host ""
    exit 0
}

# ============================================================
# Uninstall
# ============================================================
function Do-Uninstall {
    Show-Header
    Write-Info "開始解除安裝 Nanobanana..."
    Write-Host ""

    # Remove MCP server
    $claudeExists = Get-Command claude -ErrorAction SilentlyContinue
    if ($claudeExists) {
        Write-Info "移除 MCP Server..."
        try {
            claude mcp remove nanobanana 2>$null
            Write-Success "MCP Server 已移除"
        } catch {
            Write-Warn "MCP Server 不存在或已移除"
        }
    }

    # Remove commands
    Write-Info "移除 Commands..."
    $commandsDir = Join-Path $env:USERPROFILE ".claude\commands\nanobanana"
    if (Test-Path $commandsDir) {
        Remove-Item $commandsDir -Recurse -Force
    }
    Write-Success "Commands 已移除"

    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host "                     解除安裝完成！                             " -ForegroundColor Green
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "注意：環境變數需手動移除（如果有設定的話）："
    Write-Host "  1. 開啟「系統內容」>「進階」>「環境變數」"
    Write-Host "  2. 在「使用者變數」中刪除："
    Write-Host "     - NANOBANANA_GEMINI_API_KEY"
    Write-Host "     - NANOBANANA_MODEL"
    Write-Host ""
    exit 0
}

# ============================================================
# Node.js Install Guide
# ============================================================
function Show-NodejsInstallGuide {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host "                    Node.js 未安裝                              " -ForegroundColor Red
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Nanobanana 需要 Node.js 18 或更新版本才能運作。"
    Write-Host ""
    Write-Host "請選擇以下其中一種方式安裝 Node.js：" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "【方法 1】從官網下載（推薦）" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. 前往 https://nodejs.org/"
    Write-Host "  2. 下載 LTS 版本（建議 22.x）"
    Write-Host "  3. 執行安裝程式，按照指示完成安裝"
    Write-Host "  4. 重新開啟 PowerShell"
    Write-Host ""
    Write-Host "【方法 2】使用 winget（Windows 套件管理器）" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  winget install OpenJS.NodeJS.LTS"
    Write-Host ""
    Write-Host "【方法 3】使用 Chocolatey" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  choco install nodejs-lts"
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "安裝完成後，請重新開啟 PowerShell 並執行："
    Write-Host "  .\install.ps1"
    Write-Host ""
    exit 1
}

# ============================================================
# Node.js Upgrade Guide
# ============================================================
function Show-NodejsUpgradeGuide {
    param([string]$CurrentVersion)

    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host "                 Node.js 版本過低                               " -ForegroundColor Red
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "目前版本：$CurrentVersion"
    Write-Host "需要版本：>= 18"
    Write-Host ""
    Write-Host "請升級 Node.js：" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. 前往 https://nodejs.org/"
    Write-Host "  2. 下載最新 LTS 版本"
    Write-Host "  3. 執行安裝程式（會自動覆蓋舊版本）"
    Write-Host "  4. 重新開啟 PowerShell"
    Write-Host ""
    Write-Host "或使用 winget 升級：" -ForegroundColor Cyan
    Write-Host "  winget upgrade OpenJS.NodeJS.LTS"
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "升級完成後，請重新執行："
    Write-Host "  .\install.ps1"
    Write-Host ""
    exit 1
}

# ============================================================
# Claude CLI Install Guide
# ============================================================
function Show-ClaudeCliInstallGuide {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host "                 Claude Code CLI 未安裝                         " -ForegroundColor Red
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Nanobanana 是 Claude Code 的擴充工具，需要先安裝 Claude Code CLI。"
    Write-Host ""
    Write-Host "安裝步驟：" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "步驟 1：" -ForegroundColor Cyan -NoNewline
    Write-Host " 使用 npm 全域安裝 Claude Code"
    Write-Host ""
    Write-Host "  npm install -g @anthropic-ai/claude-code"
    Write-Host ""
    Write-Host "步驟 2：" -ForegroundColor Cyan -NoNewline
    Write-Host " 驗證安裝成功"
    Write-Host ""
    Write-Host "  claude --version"
    Write-Host ""
    Write-Host "步驟 3：" -ForegroundColor Cyan -NoNewline
    Write-Host " 首次執行 Claude Code（需登入）"
    Write-Host ""
    Write-Host "  claude"
    Write-Host ""
    Write-Host "  首次執行會引導你登入 Anthropic 帳號或設定 API Key。"
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "常見問題：" -ForegroundColor Blue
    Write-Host ""
    Write-Host "  Q: 什麼是 Claude Code？"
    Write-Host "  A: Claude Code 是 Anthropic 推出的 AI 程式設計助手，"
    Write-Host "     可以在終端機中直接與 Claude 對話、操作檔案、執行指令。"
    Write-Host "     官網：https://claude.ai/claude-code"
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "安裝完成後，請重新執行："
    Write-Host "  .\install.ps1"
    Write-Host ""
    exit 1
}

# ============================================================
# API Key Guide
# ============================================================
function Show-ApiKeyGuide {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host "                    如何取得 Gemini API Key                      " -ForegroundColor Yellow
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "步驟 1：" -ForegroundColor Cyan -NoNewline
    Write-Host " 開啟 Google AI Studio"
    Write-Host "         前往 https://aistudio.google.com/apikey"
    Write-Host ""
    Write-Host "步驟 2：" -ForegroundColor Cyan -NoNewline
    Write-Host " 登入 Google 帳號"
    Write-Host "         使用你的 Google 帳號登入（如果尚未登入）"
    Write-Host ""
    Write-Host "步驟 3：" -ForegroundColor Cyan -NoNewline
    Write-Host " 建立 API Key"
    Write-Host "         點擊「Create API Key」或「建立 API 金鑰」按鈕"
    Write-Host "         選擇一個 Google Cloud 專案（或建立新專案）"
    Write-Host ""
    Write-Host "步驟 4：" -ForegroundColor Cyan -NoNewline
    Write-Host " 設定帳單（圖片生成必須）"
    Write-Host "         前往 https://ai.google.dev/gemini-api/docs/billing"
    Write-Host "         依照指示設定 Google Cloud 帳單"
    Write-Host ""
    Write-Host "步驟 5：" -ForegroundColor Cyan -NoNewline
    Write-Host " 複製 API Key"
    Write-Host "         API Key 會顯示在畫面上，格式類似："
    Write-Host "         " -NoNewline
    Write-Host "AIzaSy...（約 39 個字元）" -ForegroundColor Green
    Write-Host "         點擊複製按鈕或手動選取複製"
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "重要提醒：" -ForegroundColor Red
    Write-Host "  * 圖片生成功能需要付費（約 `$0.02-0.04 美元/張）"
    Write-Host "  * 必須設定 Google Cloud 帳單才能使用圖片生成"
    Write-Host "  * 請妥善保管你的 API Key，不要分享給他人"
    Write-Host "  * 如果 Key 外洩，可以到 AI Studio 刪除並重新建立"
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host ""
}

# ============================================================
# API Key Missing Guide
# ============================================================
function Show-ApiKeyMissingGuide {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host "                       API Key 未設定                            " -ForegroundColor Red
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "安裝無法繼續，因為 Nanobanana 需要 Gemini API Key 才能運作。"
    Write-Host ""
    Write-Host "您可以透過以下方式重新執行安裝：" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  方法 1：直接重新執行此安裝腳本"
    Write-Host "          .\install.ps1"
    Write-Host ""
    Write-Host "  方法 2：先設定環境變數再執行安裝"
    Write-Host "          `$env:NANOBANANA_GEMINI_API_KEY = `"你的API金鑰`""
    Write-Host "          .\install.ps1"
    Write-Host ""
    Write-Host "  環境變數名稱：" -NoNewline
    Write-Host "NANOBANANA_GEMINI_API_KEY" -ForegroundColor Green
    Write-Host ""
    Write-Host "取得 API Key：" -ForegroundColor Blue -NoNewline
    Write-Host " https://aistudio.google.com/apikey"
    Write-Host ""
    Write-Host "常見問題：" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Q: 為什麼需要 API Key？"
    Write-Host "  A: Nanobanana 使用 Google Gemini 的圖片生成功能，需要 API Key 驗證。"
    Write-Host ""
    Write-Host "  Q: API Key 要收費嗎？"
    Write-Host "  A: 圖片生成功能需要付費（約 `$0.02-0.04 美元/張）。"
    Write-Host "     必須在 Google Cloud 設定帳單才能使用。"
    Write-Host "     詳見：https://ai.google.dev/gemini-api/docs/pricing"
    Write-Host ""
    Write-Host "  Q: 我找不到建立 API Key 的按鈕？"
    Write-Host "  A: 請確認已登入 Google 帳號，並同意 Google AI Studio 的服務條款。"
    Write-Host ""
    exit 1
}

# ============================================================
# MCP Setup Failed Guide
# ============================================================
function Show-McpSetupFailedGuide {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host "                    MCP Server 設定失敗                          " -ForegroundColor Red
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "自動設定 MCP Server 時發生錯誤。"
    Write-Host ""
    Write-Host "請嘗試手動設定：" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  步驟 1：確認 Claude CLI 正常運作"
    Write-Host "  claude --version"
    Write-Host ""
    Write-Host "  步驟 2：手動加入 MCP Server"
    Write-Host "  claude mcp add nanobanana ``"
    Write-Host "    -e NANOBANANA_GEMINI_API_KEY=`"你的API金鑰`" ``"
    Write-Host "    -e NANOBANANA_MODEL=`"gemini-3-pro-image-preview`" ``"
    Write-Host "    -- npx -y @willh/nano-banana-mcp"
    Write-Host ""
    exit 1
}

# ============================================================
# Commands Download Failed Guide
# ============================================================
function Show-CommandsDownloadFailedGuide {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host "              部分 Commands 下載失敗                             " -ForegroundColor Yellow
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "可能是網路問題，您可以稍後手動下載："
    Write-Host ""
    Write-Host "  步驟 1：複製 commands 資料夾"
    Write-Host "  git clone https://github.com/yazelin/nanobanana.git C:\temp\nanobanana"
    Write-Host "  Copy-Item -Recurse C:\temp\nanobanana\commands\nanobanana `$env:USERPROFILE\.claude\commands\"
    Write-Host "  Remove-Item -Recurse C:\temp\nanobanana"
    Write-Host ""
    Write-Host "  或直接從 GitHub 下載："
    Write-Host "  https://github.com/yazelin/nanobanana/tree/main/commands/nanobanana"
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Yellow
    Write-Host ""
}

# ============================================================
# Main Installation
# ============================================================

# Handle parameters
if ($Help) { Show-Help }
if ($Uninstall) { Do-Uninstall }

# Show header
Show-Header

# ============================================================
# Prerequisites Check
# ============================================================
Write-Host "前置需求檢查" -ForegroundColor White
Write-Host "----------------------------------------------------------------"
Write-Host ""

# Check Node.js
Write-Info "檢查 Node.js..."
$nodeExists = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeExists) {
    Show-NodejsInstallGuide
}

$nodeVersion = (node -v) -replace 'v', '' -replace '\..*', ''
if ([int]$nodeVersion -lt 18) {
    Show-NodejsUpgradeGuide (node -v)
}
Write-Success "Node.js $(node -v)"

# Check npm
Write-Info "檢查 npm..."
$npmExists = Get-Command npm -ErrorAction SilentlyContinue
if (-not $npmExists) {
    Write-Error2 "npm 未安裝"
    Write-Host ""
    Write-Host "npm 通常會隨 Node.js 一起安裝。"
    Write-Host "請重新安裝 Node.js：https://nodejs.org/"
    Write-Host ""
    exit 1
}
Write-Success "npm $(npm -v)"

# Check Claude CLI
Write-Info "檢查 Claude Code CLI..."
$claudeExists = Get-Command claude -ErrorAction SilentlyContinue
if (-not $claudeExists) {
    Show-ClaudeCliInstallGuide
}
Write-Success "Claude Code CLI"

Write-Host ""
Write-Success "所有前置需求已滿足！"
Write-Host ""

# ============================================================
# Gemini API Key Setup
# ============================================================
Write-Host "設定 Gemini API Key" -ForegroundColor White
Write-Host "----------------------------------------------------------------"
Write-Host ""

$apiKey = $env:NANOBANANA_GEMINI_API_KEY

if ($apiKey) {
    $maskedKey = $apiKey.Substring(0, [Math]::Min(10, $apiKey.Length)) + "..."
    Write-Host "偵測到現有的 API Key: " -NoNewline
    Write-Host $maskedKey -ForegroundColor Yellow
    $useExisting = Read-Host "使用現有的 API Key? [Y/n]"
    if ($useExisting -match '^[Nn]') {
        Show-ApiKeyGuide
        $apiKey = Read-Host "請輸入新的 Gemini API Key"
    }
} else {
    Write-Host "尚未設定 Gemini API Key。"
    Write-Host ""
    $showGuide = Read-Host "是否需要查看取得 API Key 的詳細說明？[Y/n]"
    if ($showGuide -notmatch '^[Nn]') {
        Show-ApiKeyGuide
    } else {
        Write-Host ""
        Write-Host "請前往 https://aistudio.google.com/apikey 取得 API Key"
        Write-Host ""
    }
    $apiKey = Read-Host "請輸入 Gemini API Key"
}

# Validate API Key
if ([string]::IsNullOrWhiteSpace($apiKey)) {
    Show-ApiKeyMissingGuide
}

# Basic format validation
if (-not $apiKey.StartsWith("AIza")) {
    Write-Host ""
    Write-Warn "API Key 格式可能不正確（通常以 'AIza' 開頭）"
    $continueAnyway = Read-Host "是否仍要繼續？[y/N]"
    if ($continueAnyway -notmatch '^[Yy]') {
        Write-Host ""
        Write-Host "請重新執行安裝腳本並輸入正確的 API Key。"
        exit 1
    }
}

Write-Host ""

# ============================================================
# Select Model
# ============================================================
Write-Host "選擇圖片生成模型" -ForegroundColor White
Write-Host "----------------------------------------------------------------"
Write-Host ""
Write-Host "可用模型："
Write-Host "  " -NoNewline
Write-Host "1)" -ForegroundColor Green -NoNewline
Write-Host " gemini-3-pro-image-preview " -NoNewline
Write-Host "(Nano Banana Pro，預設，品質較好)" -ForegroundColor Yellow
Write-Host "  " -NoNewline
Write-Host "2)" -ForegroundColor Green -NoNewline
Write-Host " gemini-2.5-flash-image " -NoNewline
Write-Host "(較快速)" -ForegroundColor Yellow
Write-Host ""
$modelChoice = Read-Host "請選擇 [1-2，按 Enter 使用預設]"

$model = switch ($modelChoice) {
    "2" { "gemini-2.5-flash-image" }
    default { "gemini-3-pro-image-preview" }
}

Write-Success "使用模型：$model"
Write-Host ""

# ============================================================
# Setup MCP Server
# ============================================================
Write-Host "設定 MCP Server" -ForegroundColor White
Write-Host "----------------------------------------------------------------"
Write-Host ""

Write-Info "移除舊的設定（如果存在）..."
$null = claude mcp remove nanobanana 2>&1

Write-Info "加入 MCP Server..."

# 構建並執行命令
$addCmd = "claude mcp add nanobanana -e NANOBANANA_GEMINI_API_KEY=`"$apiKey`" -e NANOBANANA_MODEL=`"$model`" -- npx -y @willh/nano-banana-mcp"
Write-Host "  執行: claude mcp add nanobanana ..." -ForegroundColor Gray

$mcpResult = Invoke-Expression $addCmd 2>&1
$addExitCode = $LASTEXITCODE

if ($addExitCode -ne 0) {
    Write-Error2 "MCP Server 設定失敗 (exit code: $addExitCode)"
    Write-Host ""
    Write-Host "錯誤訊息：" -ForegroundColor Yellow
    Write-Host $mcpResult
    Write-Host ""
    Show-McpSetupFailedGuide
}

# 短暫等待讓設定生效
Start-Sleep -Milliseconds 500

# 驗證 MCP 是否已加入
Write-Host "  驗證設定..." -ForegroundColor Gray
$mcpList = claude mcp list 2>&1
$listExitCode = $LASTEXITCODE

if ($listExitCode -ne 0) {
    Write-Warn "無法執行 claude mcp list (exit code: $listExitCode)"
    Write-Host "  輸出: $mcpList" -ForegroundColor Gray
    Write-Host ""
    Write-Host "請手動驗證是否已加入成功：" -ForegroundColor Yellow
    Write-Host "  claude mcp list"
    Write-Host ""
} elseif ($mcpList -match "nanobanana") {
    Write-Success "MCP Server 已設定並驗證成功"
} else {
    Write-Warn "MCP Server 可能未成功加入"
    Write-Host "  claude mcp list 輸出:" -ForegroundColor Gray
    Write-Host $mcpList
    Write-Host ""
    Write-Host "請手動驗證：" -ForegroundColor Yellow
    Write-Host "  claude mcp list"
    Write-Host ""
    Write-Host "如果沒有看到 nanobanana，請手動執行：" -ForegroundColor Yellow
    Write-Host "  $addCmd"
    Write-Host ""
}

Write-Host ""

# ============================================================
# Install Commands
# ============================================================
Write-Host "安裝 Commands" -ForegroundColor White
Write-Host "----------------------------------------------------------------"
Write-Host ""

$commandsDir = Join-Path $env:USERPROFILE ".claude\commands\nanobanana"
if (-not (Test-Path $commandsDir)) {
    New-Item -ItemType Directory -Path $commandsDir -Force | Out-Null
}

$repoUrl = "https://raw.githubusercontent.com/yazelin/nanobanana/main/commands/nanobanana"
$commands = @("nanobanana", "generate", "edit", "restore", "icon", "pattern", "story", "diagram")
$downloadFailed = $false

foreach ($cmd in $commands) {
    $cmdPath = Join-Path $commandsDir "$cmd.md"
    try {
        Invoke-WebRequest -Uri "$repoUrl/$cmd.md" -OutFile $cmdPath -ErrorAction Stop
        Write-Success "已安裝 /nanobanana:$cmd"
    } catch {
        Write-Warn "無法下載 $cmd.md"
        $downloadFailed = $true
    }
}

if ($downloadFailed) {
    Show-CommandsDownloadFailedGuide
}

Write-Host ""

# ============================================================
# Save Environment Variables (Optional)
# ============================================================
Write-Host "儲存設定（可選）" -ForegroundColor White
Write-Host "----------------------------------------------------------------"
Write-Host ""

Write-Host "是否將環境變數永久儲存？"
Write-Host "（這樣未來重新安裝時可以自動偵測 API Key）"
Write-Host ""
$addToEnv = Read-Host "儲存環境變數? [y/N]"

if ($addToEnv -match '^[Yy]') {
    [Environment]::SetEnvironmentVariable("NANOBANANA_GEMINI_API_KEY", $apiKey, "User")
    [Environment]::SetEnvironmentVariable("NANOBANANA_MODEL", $model, "User")
    Write-Success "環境變數已儲存到使用者設定"
    Write-Host ""
    Write-Host "注意：需要重新開啟 PowerShell 才會生效。"
}

# ============================================================
# Installation Complete
# ============================================================
Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "                                                                " -ForegroundColor Green
Write-Host "                      安裝完成！                                " -ForegroundColor Green
Write-Host "                                                                " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "下一步：" -ForegroundColor White
Write-Host ""
Write-Host "  1. 重啟 Claude Code（或開新 PowerShell 執行 " -NoNewline
Write-Host "claude" -ForegroundColor Cyan -NoNewline
Write-Host "）"
Write-Host ""
Write-Host "  2. 試試看這些指令："
Write-Host "     " -NoNewline
Write-Host "/nanobanana:generate 一隻可愛的貓咪" -ForegroundColor Cyan
Write-Host "     " -NoNewline
Write-Host "/nanobanana:nanobanana 幫我做一張早安圖" -ForegroundColor Cyan
Write-Host ""
Write-Host "可用指令：" -ForegroundColor White
Write-Host "  /nanobanana:nanobanana  - 自然語言介面"
Write-Host "  /nanobanana:generate    - 生成圖片"
Write-Host "  /nanobanana:edit        - 編輯圖片"
Write-Host "  /nanobanana:restore     - 修復圖片"
Write-Host "  /nanobanana:icon        - 生成圖標"
Write-Host "  /nanobanana:pattern     - 生成圖案"
Write-Host "  /nanobanana:story       - 生成故事序列"
Write-Host "  /nanobanana:diagram     - 生成流程圖"
Write-Host ""
Write-Host "更多資訊：" -ForegroundColor White
Write-Host "  GitHub: https://github.com/yazelin/nanobanana"
Write-Host "  解除安裝: .\install.ps1 -Uninstall"
Write-Host ""
