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

## 🚀 快速開始

```bash
# 1. 安裝依賴
brew install yt-dlp ffmpeg
pip install mlx-whisper  # Mac (Apple Silicon)
# 或
pip install openai-whisper  # Windows/Linux/Intel Mac

# 2. 執行
chmod +x analyze.sh
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

## 💰 完整版

Public 版本包含基本功能。

**完整版額外包含：**
- 自動 AI 摘要（重點整理）
- 批量頻道分析腳本
- B 站 Cookie 自動提取
- 多語言翻譯整合

👉 私訊 [@10000allison](https://www.instagram.com/10000allison/) 取得完整版

---

*Built with 🦞 OpenClaw + 🗣️ Whisper + 📹 yt-dlp*
