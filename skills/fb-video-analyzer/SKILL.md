---
name: fb-video-analyzer
description: Download and transcribe videos from FB Reels, IG Reels, YouTube, TikTok, and other platforms. Converts video audio to text using MLX Whisper for content analysis. Use when asked to analyze, transcribe, summarize, or understand video content from social media links. Triggers on "看影片在講什麼", "分析這個影片", "影片內容", "轉文字稿", "transcribe video".
---

# FB Video Analyzer

下載社群影片 → 語音轉文字 → 內容分析。

## 支援平台
- Facebook Reels / 影片
- Instagram Reels / 影片
- YouTube / Shorts
- TikTok
- 其他 yt-dlp 支援的平台

## 使用方式

```bash
bash scripts/analyze.sh <video-url> [language]
```

### 參數
- `video-url` — 影片連結（必填）
- `language` — 語言代碼（選填，預設 `zh`）
  - `zh` 中文、`en` 英文、`ja` 日文、`ko` 韓文

### 範例
```bash
# FB Reel
bash scripts/analyze.sh "https://www.facebook.com/reel/3187476971463309"

# YouTube
bash scripts/analyze.sh "https://www.youtube.com/watch?v=xxx"

# 英文影片
bash scripts/analyze.sh "https://www.youtube.com/watch?v=xxx" en
```

## 流程

1. **下載** — yt-dlp 下載影片（支援 1000+ 平台）
2. **轉寫** — MLX Whisper large-v3-turbo 語音轉文字
3. **輸出** — 逐字稿 + 統計資訊

## 分析後續

拿到文字稿後，可以：
- 摘要重點
- 分析商業模式
- 提取 CTA 和行銷策略
- 對比競品內容

## 注意事項

- 部分 FB/IG 影片需要登入才能下載 → 加 `--cookies-from-browser chrome`
- MLX Whisper 需要 Apple Silicon Mac
- 影片越長轉寫越久（1 分鐘影片約 10-20 秒）
- 輸出檔案在 `/tmp/video-analysis/`

## 依賴

- `yt-dlp` — 影片下載
- `mlx_whisper` — 語音轉文字（Apple Silicon）
