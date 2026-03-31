#!/bin/bash
# analyze.sh — 下載 FB/IG/YouTube 影片 → 轉文字稿 → 輸出分析
# Usage: bash analyze.sh <video-url> [language]
#   video-url: FB Reel、IG Reel、YouTube 等影片連結
#   language: 語言代碼（預設 zh，可用 en/ja/ko 等）

set -euo pipefail

URL="${1:-}"
LANG="${2:-zh}"
OUTDIR="/tmp/video-analysis"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

if [[ -z "$URL" ]]; then
  echo "❌ Usage: bash analyze.sh <video-url> [language]"
  echo "   支援：FB Reel、IG Reel、YouTube、TikTok 等"
  echo "   language: zh(預設) / en / ja / ko"
  exit 1
fi

mkdir -p "$OUTDIR"

VIDEO_FILE="$OUTDIR/video-${TIMESTAMP}.mp4"
TRANSCRIPT_FILE="$OUTDIR/video-${TIMESTAMP}.txt"

# Step 1: 下載影片
echo "📥 Step 1: 下載影片..."
echo "   URL: $URL"

if yt-dlp -o "$VIDEO_FILE" "$URL" 2>&1 | tail -5; then
  # yt-dlp 可能產生不同副檔名，找到實際檔案
  ACTUAL_FILE=$(ls -t "$OUTDIR"/video-${TIMESTAMP}.* 2>/dev/null | head -1)
  if [[ -z "$ACTUAL_FILE" ]]; then
    echo "❌ 下載失敗：找不到輸出檔案"
    echo "   可能需要登入 cookie，試試："
    echo "   yt-dlp --cookies-from-browser chrome \"$URL\""
    exit 1
  fi
  VIDEO_FILE="$ACTUAL_FILE"
  echo "  ✅ 下載完成: $VIDEO_FILE"
  echo "  📊 檔案大小: $(du -h "$VIDEO_FILE" | cut -f1)"
else
  echo "❌ 下載失敗"
  echo "   可能原因：需要登入、連結無效、地區限制"
  exit 1
fi

# Step 2: 轉文字稿
echo ""
echo "🎙️ Step 2: 語音轉文字（MLX Whisper）..."
echo "   語言: $LANG"
echo "   模型: whisper-large-v3-turbo"

if mlx_whisper "$VIDEO_FILE" --language "$LANG" --model mlx-community/whisper-large-v3-turbo -f txt -o "$OUTDIR" 2>&1 | tail -3; then
  # 找到產出的 txt 檔
  ACTUAL_TXT=$(ls -t "$OUTDIR"/*.txt 2>/dev/null | head -1)
  if [[ -n "$ACTUAL_TXT" ]]; then
    TRANSCRIPT_FILE="$ACTUAL_TXT"
    echo "  ✅ 轉寫完成: $TRANSCRIPT_FILE"
  fi
else
  echo "❌ 轉寫失敗"
  exit 1
fi

# Step 3: 輸出結果
echo ""
echo "═══════════════════════════════════════"
echo "📝 逐字稿內容："
echo "═══════════════════════════════════════"
cat "$TRANSCRIPT_FILE"
echo ""
echo "═══════════════════════════════════════"
echo ""
echo "📊 統計："
WORD_COUNT=$(wc -c < "$TRANSCRIPT_FILE" | tr -d ' ')
LINE_COUNT=$(wc -l < "$TRANSCRIPT_FILE" | tr -d ' ')
echo "  字數: $WORD_COUNT"
echo "  行數: $LINE_COUNT"
echo ""
echo "📁 檔案位置："
echo "  影片: $VIDEO_FILE"
echo "  文稿: $TRANSCRIPT_FILE"
echo ""
echo "✅ 分析完成！"
