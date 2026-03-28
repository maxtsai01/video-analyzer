# 🦞 AI 影片分析器 — Video Analyzer

> 丟一個連結，自動下載 → 轉文字 → 摘要分析

---

## 這是什麼？

一鍵把任何影片變成文字。競品分析、內容再創作、學習筆記，全自動。

## 🎯 功能

- ✅ 支援 YouTube、B 站、TikTok、IG Reels、Twitter/X
- ✅ 中文、英文、日文語音辨識
- ✅ 本地運行，影片不上傳到雲端
- ✅ 一鍵搞定：下載 → 轉文字 → 輸出

## ⚠️ 重要：平台登入需求

| 平台 | 需要登入？ | Cookie 需求 |
|------|-----------|------------|
| YouTube | ❌ 不需要 | 直接下載 |
| TikTok | ❌ 不需要 | 直接下載 |
| Twitter/X | ❌ 不需要 | 直接下載 |
| IG Reels | 🔶 部分需要 | 私人帳號需 Cookie |
| **B 站** | **✅ 需要登入** | **必須提供 Cookie** |

### B 站為什麼需要登入？

B 站限制未登入用戶只能看低畫質，且部分影片完全無法存取。**你必須先在瀏覽器登入 B 站，再匯出 Cookie 給工具使用。**

### B 站 Cookie 匯出方法

**方法 A：從 Chrome/Edge/Firefox 自動抓**
```bash
# 如果你的 Chrome 已登入 B 站
./analyze.sh https://www.bilibili.com/video/BVxxx zh --browser chrome
```

**方法 B：手動匯出 Cookie 檔案**
1. 在已登入 B 站的瀏覽器安裝「Get cookies.txt」擴充套件
2. 進入 bilibili.com → 點擊擴充套件 → 匯出為 `cookies.txt`
3. 把 `cookies.txt` 放在腳本同目錄
4. 腳本會自動偵測並使用

**方法 C：透過 CDP 從 Comet/AdsPower 提取（進階）**
```bash
# 如果你用 Comet 瀏覽器（CDP port 9333）已登入 B 站
./export-cookies.sh 9333 bilibili
# 自動從瀏覽器提取 Cookie 並存成 cookies.txt
```

## 🚀 快速開始

```bash
# 1. 安裝依賴
brew install yt-dlp ffmpeg
pip install mlx-whisper  # Mac (Apple Silicon)
# 或
pip install openai-whisper  # Windows/Linux/Intel Mac

# 2. 執行（YouTube/TikTok 直接跑）
chmod +x analyze.sh
./analyze.sh https://www.youtube.com/watch?v=xxx zh

# 3. B 站需要先準備 Cookie（見上方說明）
./analyze.sh https://www.bilibili.com/video/BVxxx zh
```

## 📋 用法

```bash
./analyze.sh <影片連結> [語言] [輸出目錄]
```

| 參數 | 說明 | 預設 |
|------|------|------|
| 影片連結 | YouTube/B站/TikTok 等 | 必填 |
| 語言 | zh/en/ja | zh |
| 輸出目錄 | 檔案存放位置 | ./output |

## 📊 輸出

```
output/
├── 影片標題.mp4    ← 原始影片
├── 影片標題.wav    ← 音頻
└── 影片標題.txt    ← 完整字幕文字
```

## 💡 使用場景

| 場景 | 怎麼用 |
|------|--------|
| **競品分析** | 下載對手的教學影片 → 轉文字 → 分析他們講了什麼 |
| **內容再創作** | 把別人的影片轉成文字 → 改寫成自己的文章/貼文 |
| **學習筆記** | 教學影片自動做成文字版 → 快速複習 |
| **市場研究** | 批量分析某個頻道的所有影片 → 找出熱門主題 |
| **SEO 內容** | 影片內容轉成部落格文章 → 搜尋引擎優化 |

## 🔧 進階：批量分析

```bash
# 批量分析一個頻道的所有影片
while read url; do
  ./analyze.sh "$url" zh ./output
done < urls.txt
```

## ⚠️ 注意事項

- B 站影片可能需要登入 Cookie（放在 `cookies.txt`）
- Apple Silicon Mac 用 `mlx-whisper` 速度最快
- 影片越長，轉文字越久（1 分鐘影片 ≈ 10-30 秒處理）
- 本工具僅供學習研究用途

## 🔧 進階工具

### Cookie 自動提取（B 站必備）

從已登入的 CDP 瀏覽器（Comet/Chrome）自動提取 Cookie：

```bash
# 從 Comet 瀏覽器提取 B 站 Cookie（CDP port 9333）
./export-cookies.sh 9333 bilibili

# 從 AdsPower 提取（CDP port 50325）
./export-cookies.sh 50325 bilibili
```

提取後會自動存成 `cookies.txt`，之後 `analyze.sh` 會自動偵測使用。

### 批量頻道分析

一次分析整個頻道或多個影片：

```bash
# 分析 YouTube 頻道最新 20 支影片
./batch-analyze.sh --channel https://www.youtube.com/@channel --limit 20

# 從檔案讀取多個 URL
./batch-analyze.sh --list urls.txt --lang zh

# 自動產出摘要報告 → output/_summary.md
```

## 📁 完整檔案結構

```
video-analyzer/
├── README.md              ← 說明文件
├── analyze.sh             ← 單支影片分析
├── batch-analyze.sh       ← 批量頻道分析
├── export-cookies.sh      ← CDP Cookie 提取
├── cookies.txt            ← (自動產生) B站登入Cookie
└── output/                ← 分析結果
    ├── 影片標題.mp4       ← 原始影片
    ├── 影片標題.wav       ← 音頻
    ├── 影片標題.txt       ← 完整字幕
    └── _summary.md        ← 批量分析摘要報告
```

---

*Built with 🦞 OpenClaw + 🗣️ Whisper + 📹 yt-dlp*
