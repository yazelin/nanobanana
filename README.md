# Nanobanana MCP

簡單易用的 Claude Code 圖片生成工具 - 使用 Google Gemini API 生成、編輯、修復圖片。

> 基於 [nanobanana](https://github.com/doggy8088/nanobanana) by [Will Huang (doggy8088)](https://github.com/doggy8088)

## 重要提醒

> **圖片生成功能需要付費**（約 $0.02-0.04 美元/張）
>
> 使用前需在 Google Cloud 設定帳單。詳見：[Gemini API Pricing](https://ai.google.dev/gemini-api/docs/pricing)

## 特點

- **無需 Plugin** - 直接使用 MCP server + Commands
- **一鍵安裝** - 自動設定 MCP server 和環境變數
- **支援多種操作** - 生成、編輯、修復、圖標、圖案、故事序列、流程圖

## 前置需求

在安裝前，請確認你已具備：

| 需求 | 說明 |
|------|------|
| Node.js >= 18 | [下載](https://nodejs.org/) |
| npm | 隨 Node.js 安裝 |
| Claude Code CLI | `npm install -g @anthropic-ai/claude-code` |
| Gemini API Key | [取得](https://aistudio.google.com/apikey)（需設定帳單） |

## 安裝方式

### macOS / Linux

#### 方式一：一鍵安裝（推薦）

```bash
curl -fsSL https://raw.githubusercontent.com/yazelin/nanobanana/main/install.sh | bash
```

或下載後執行：

```bash
curl -fsSL https://raw.githubusercontent.com/yazelin/nanobanana/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

#### 方式二：手動安裝

```bash
# 1. 設定環境變數（加到 ~/.bashrc 或 ~/.zshrc）
export NANOBANANA_GEMINI_API_KEY=your_api_key_here
export NANOBANANA_MODEL=gemini-3-pro-image-preview

# 2. 加入 MCP Server
claude mcp add nanobanana \
  -e NANOBANANA_GEMINI_API_KEY \
  -e NANOBANANA_MODEL \
  -- npx -y @willh/nano-banana-mcp

# 3. 複製 Commands
git clone https://github.com/yazelin/nanobanana.git
cp -r nanobanana/commands/nanobanana ~/.claude/commands/

# 4. 重啟 Claude Code
claude
```

### Windows

#### 方式一：一鍵安裝（推薦）

在 PowerShell 中執行：

```powershell
irm https://raw.githubusercontent.com/yazelin/nanobanana/main/install.ps1 | iex
```

或下載後執行：

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yazelin/nanobanana/main/install.ps1" -OutFile "install.ps1"
.\install.ps1
```

> **注意**：如果出現執行原則錯誤，請先執行：
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

#### 方式二：手動安裝

```powershell
# 1. 設定環境變數
$env:NANOBANANA_GEMINI_API_KEY = "your_api_key_here"
$env:NANOBANANA_MODEL = "gemini-3-pro-image-preview"

# 永久儲存（可選）
[Environment]::SetEnvironmentVariable("NANOBANANA_GEMINI_API_KEY", "your_api_key_here", "User")
[Environment]::SetEnvironmentVariable("NANOBANANA_MODEL", "gemini-3-pro-image-preview", "User")

# 2. 加入 MCP Server
claude mcp add nanobanana `
  -e NANOBANANA_GEMINI_API_KEY `
  -e NANOBANANA_MODEL `
  -- npx -y @willh/nano-banana-mcp

# 3. 複製 Commands
git clone https://github.com/yazelin/nanobanana.git
Copy-Item -Recurse nanobanana\commands\nanobanana $env:USERPROFILE\.claude\commands\

# 4. 重啟 Claude Code
claude
```

## 使用方式

### 可用指令

| 指令 | 說明 |
|------|------|
| `/nanobanana:nanobanana` | 自然語言介面，自動選擇適當工具 |
| `/nanobanana:generate` | 從文字生成圖片 |
| `/nanobanana:edit` | 編輯現有圖片 |
| `/nanobanana:restore` | 修復或增強圖片 |
| `/nanobanana:icon` | 生成 App 圖標、favicon |
| `/nanobanana:pattern` | 生成無縫圖案、紋理 |
| `/nanobanana:story` | 生成視覺故事序列 |
| `/nanobanana:diagram` | 生成技術流程圖 |

### 使用範例

```bash
# 生成圖片
/nanobanana:generate 一隻可愛的貓咪在玩毛線 --styles=watercolor --resolution=2K

# 生成多張圖片
/nanobanana:generate 山景 --count=4 --variations=lighting,season

# 編輯圖片
/nanobanana:edit photo.jpg "在天空加上彩虹"

# 生成圖標
/nanobanana:icon 簡約風格的音樂 App 圖標 --sizes=64,128,256,512

# 生成圖案
/nanobanana:pattern 幾何三角形 --style=tech --colors=duotone

# 生成故事序列
/nanobanana:story "花從種子到盛開的過程" --steps=6

# 生成流程圖
/nanobanana:diagram "用戶認證流程" --type=flowchart

# 自然語言（自動選擇工具）
/nanobanana:nanobanana 幫我做一個咖啡店的專業 logo
```

### 常用選項

| 選項 | 說明 | 預設值 |
|------|------|--------|
| `--count=N` | 生成數量 (1-8) | 1 |
| `--resolution` | 解析度 (1K/2K/4K) | 2K |
| `--aspect-ratio` | 長寬比 | 1:1 |
| `--styles` | 風格 | - |
| `--variations` | 變化類型 | - |
| `--filename` | 輸出檔名 | - |
| `--preview` | 預覽模式 | - |

## 環境變數

| 變數 | 說明 | 必要 |
|------|------|------|
| `NANOBANANA_GEMINI_API_KEY` | 在 Google AI Studio 建立的 API Key | 是 |
| `NANOBANANA_MODEL` | 使用的模型 | 否 |
| `NANOBANANA_DEBUG` | 啟用除錯輸出 | 否 |

### 可用模型

| 模型 | 說明 |
|------|------|
| `gemini-3-pro-image-preview` | Nano Banana Pro（預設，品質較好） |
| `gemini-2.5-flash-image` | 較快速 |

## 取得 API Key

1. 前往 [Google AI Studio](https://aistudio.google.com/apikey)
2. 登入 Google 帳號
3. 點擊「Create API Key」
4. **設定 Google Cloud 帳單**（圖片生成必須）：[設定帳單](https://ai.google.dev/gemini-api/docs/billing)
5. 複製 API Key

> **重要**：圖片生成功能不在免費額度內，必須設定帳單才能使用。

## 解除安裝

### macOS / Linux

```bash
./install.sh --uninstall
```

或手動：

```bash
# 移除 MCP server
claude mcp remove nanobanana

# 移除 commands
rm -rf ~/.claude/commands/nanobanana

# 移除環境變數（手動從 ~/.bashrc 或 ~/.zshrc 移除）
```

### Windows

```powershell
.\install.ps1 -Uninstall
```

或手動：

```powershell
# 移除 MCP server
claude mcp remove nanobanana

# 移除 commands
Remove-Item -Recurse $env:USERPROFILE\.claude\commands\nanobanana

# 移除環境變數
[Environment]::SetEnvironmentVariable("NANOBANANA_GEMINI_API_KEY", $null, "User")
[Environment]::SetEnvironmentVariable("NANOBANANA_MODEL", $null, "User")
```

## 問題排除

### MCP server 無法啟動

1. 確認 Node.js >= 18：`node --version`
2. 確認環境變數已設定：
   - Linux/macOS: `echo $NANOBANANA_GEMINI_API_KEY`
   - Windows: `echo $env:NANOBANANA_GEMINI_API_KEY`
3. 重啟 Claude Code

### 圖片生成失敗

1. 確認 API Key 有效
2. **確認已設定 Google Cloud 帳單**（最常見原因）
3. 檢查是否超過 API 配額
4. 啟用除錯模式：
   - Linux/macOS: `export NANOBANANA_DEBUG=1`
   - Windows: `$env:NANOBANANA_DEBUG = "1"`

### Windows PowerShell 執行原則錯誤

如果出現「無法載入檔案...，因為這個系統上已停用指令碼執行」：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### npm 權限錯誤 (EACCES)

Linux/macOS：

```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## 授權

Apache-2.0 - 詳見 [LICENSE](LICENSE)

## 致謝

- [nanobanana](https://github.com/doggy8088/nanobanana) by [Will Huang (doggy8088)](https://github.com/doggy8088)
- MCP Server: 使用 Google Gemini API
