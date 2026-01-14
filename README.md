# Nanobanana MCP

簡單易用的 Claude Code 圖片生成工具 - 使用 Google Gemini API 生成、編輯、修復圖片。

> 基於 [nanobanana](https://github.com/doggy8088/nanobanana) by [Will Huang (doggy8088)](https://github.com/doggy8088)

## 特點

- **無需 Plugin** - 直接使用 MCP server + Commands
- **一鍵安裝** - 自動設定 MCP server 和環境變數
- **支援多種操作** - 生成、編輯、修復、圖標、圖案、故事序列、流程圖

## 安裝方式

### 方式一：一鍵安裝（推薦）

```bash
curl -fsSL https://raw.githubusercontent.com/yazelin/nanobanana/main/install.sh | bash
```

安裝腳本會：
1. 檢查必要工具（node, npm, claude）
2. 提示輸入 Gemini API Key（NANOBANANA_GEMINI_API_KEY）
3. 自動設定 MCP server
4. 複製 commands 到 `~/.claude/commands/`
5. 可選：將環境變數加入 `~/.bashrc`

### 方式二：手動安裝

#### 1. 設定環境變數

```bash
# 加到 ~/.bashrc 或 ~/.zshrc
# NANOBANANA_GEMINI_API_KEY：設定你在 Google AI Studio 建立的 API Key
export NANOBANANA_GEMINI_API_KEY=your_api_key_here

# NANOBANANA_MODEL：設定使用的模型（預設：gemini-2.5-flash-image）
export NANOBANANA_MODEL=gemini-2.5-flash-image

# 重新載入
source ~/.bashrc
```

#### 2. 加入 MCP Server

```bash
claude mcp add nanobanana \
  -e NANOBANANA_GEMINI_API_KEY \
  -e NANOBANANA_MODEL \
  -- npx -y @willh/nano-banana-mcp
```

#### 3. 複製 Commands

```bash
git clone https://github.com/yazelin/nanobanana.git
cp -r nanobanana/commands/* ~/.claude/commands/
```

#### 4. 重啟 Claude Code

```bash
claude
```

## 使用方式

### 可用指令

| 指令 | 說明 |
|------|------|
| `/nanobanana` | 自然語言介面，自動選擇適當工具 |
| `/generate` | 從文字生成圖片 |
| `/edit` | 編輯現有圖片 |
| `/restore` | 修復或增強圖片 |
| `/icon` | 生成 App 圖標、favicon |
| `/pattern` | 生成無縫圖案、紋理 |
| `/story` | 生成視覺故事序列 |
| `/diagram` | 生成技術流程圖 |

### 使用範例

```bash
# 生成圖片
/generate 一隻可愛的貓咪在玩毛線 --styles=watercolor --resolution=2K

# 生成多張圖片
/generate 山景 --count=4 --variations=lighting,season

# 編輯圖片
/edit photo.jpg "在天空加上彩虹"

# 生成圖標
/icon 簡約風格的音樂 App 圖標 --sizes=64,128,256,512

# 生成圖案
/pattern 幾何三角形 --style=tech --colors=duotone

# 生成故事序列
/story "花從種子到盛開的過程" --steps=6

# 生成流程圖
/diagram "用戶認證流程" --type=flowchart

# 自然語言（自動選擇工具）
/nanobanana 幫我做一個咖啡店的專業 logo
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

- `gemini-2.5-flash-image` (預設)
- `gemini-3-pro-image-preview` (Nano Banana Pro)

## 取得 API Key

1. 前往 [Google AI Studio](https://aistudio.google.com/apikey)
2. 點擊「Create API Key」
3. 複製 API Key

## 解除安裝

```bash
# 移除 MCP server
claude mcp remove nanobanana

# 移除 commands
rm -f ~/.claude/commands/{nanobanana,generate,edit,restore,icon,pattern,story,diagram}.md

# 移除環境變數（手動從 ~/.bashrc 移除 NANOBANANA_GEMINI_API_KEY 和 NANOBANANA_MODEL）
```

## 問題排除

### MCP server 無法啟動

1. 確認 Node.js >= 18：`node --version`
2. 確認環境變數已設定：`echo $NANOBANANA_GEMINI_API_KEY`
3. 重啟 Claude Code

### 圖片生成失敗

1. 確認 API Key 有效
2. 檢查是否超過 API 配額
3. 啟用除錯模式：`export NANOBANANA_DEBUG=1`

## 授權

Apache-2.0 - 詳見 [LICENSE](LICENSE)

## 致謝

- [nanobanana](https://github.com/doggy8088/nanobanana) by [Will Huang (doggy8088)](https://github.com/doggy8088)
- MCP Server: 使用 Google Gemini API
