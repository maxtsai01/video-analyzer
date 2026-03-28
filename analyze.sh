#!/bin/bash
# 🦞 AI 影片分析器 — 丟連結自動轉文字+摘要
# 用法: ./analyze.sh <影片連結> [語言]
# 範例: ./analyze.sh https://www.bilibili.com/video/BV1uCBSBDEL9 zh
# 支援: YouTube, B站, TikTok, IG Reels, Twitter/X

set -e

URL="$1"
LANG="${2:-zh}"
OUTPUT_DIR="${3:-./output}"

if [ -z "$URL" ]; then
  echo "🦞 AI 影片分析器"
  echo "用法: ./analyze.sh <影片連結> [語言] [輸出目錄]"
  echo ""
  echo "支援語言: zh(中文) en(英文) ja(日文)"
  echo "支援平台: YouTube, B站, TikTok, IG, Twitter/X"
  echo ""
  echo "範例:"
  echo "  ./analyze.sh https://www.youtube.com/watch?v=xxx"
  echo "  ./analyze.sh https://www.bilibili.com/video/BVxxx zh"
  exit 1
fi

# 檢查依賴
echo "🔍 檢查工具..."
command -v yt-dlp >/dev/null 2>&1 || { echo "❌ 需要 yt-dlp: brew install yt-dlp"; exit 1; }
command -v ffmpeg >/dev/null 2>&1 || { echo "❌ 需要 ffmpeg: brew install ffmpeg"; exit 1; }

# 檢查 whisper
WHISPER_CMD=""
if command -v mlx_whisper >/dev/null 2>&1; then
  WHISPER_CMD="mlx_whisper"
elif command -v whisper >/dev/null 2>&1; then
  WHISPER_CMD="whisper"
else
  echo "❌ 需要 Whisper: pip install mlx-whisper 或 pip install openai-whisper"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

# 偵測 Cookie
COOKIE_OPTS=""
if [ -f "./cookies.txt" ]; then
  COOKIE_OPTS="--cookies ./cookies.txt"
  echo "🍪 偵測到 cookies.txt，使用登入狀態下載"
elif [ -f "$OUTPUT_DIR/cookies.txt" ]; then
  COOKIE_OPTS="--cookies $OUTPUT_DIR/cookies.txt"
  echo "🍪 偵測到 cookies.txt，使用登入狀態下載"
fi

# B 站提醒
if echo "$URL" | grep -q "bilibili"; then
  if [ -z "$COOKIE_OPTS" ]; then
    echo ""
    echo "⚠️  B 站需要登入才能下載！"
    echo "   請先在瀏覽器登入 bilibili.com，然後："
    echo "   方法 A: 安裝「Get cookies.txt」擴充套件匯出 Cookie"
    echo "   方法 B: 把 cookies.txt 放在腳本同目錄"
    echo "   方法 C: 用 --browser chrome（如果 Chrome 已登入）"
    echo ""
    read -p "   已準備好 Cookie？(y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "   請先準備 Cookie 再執行"
      exit 1
    fi
  fi
fi

# Step 1: 下載影片
echo ""
echo "📥 Step 1: 下載影片..."
TITLE=$(yt-dlp $COOKIE_OPTS --get-title "$URL" 2>/dev/null | head -1)
SAFE_TITLE=$(echo "$TITLE" | tr '/' '_' | tr ' ' '_' | cut -c1-50)
VIDEO_FILE="$OUTPUT_DIR/${SAFE_TITLE}.mp4"

if [ -f "$VIDEO_FILE" ]; then
  echo "   ✅ 已存在，跳過下載"
else
  yt-dlp $COOKIE_OPTS -o "$VIDEO_FILE" "$URL" 2>&1 | grep -E "Destination|Merging|100%"
  echo "   ✅ 下載完成: $VIDEO_FILE"
fi

# Step 2: 提取音頻
echo ""
echo "🎵 Step 2: 提取音頻..."
AUDIO_FILE="$OUTPUT_DIR/${SAFE_TITLE}.wav"
if [ -f "$AUDIO_FILE" ]; then
  echo "   ✅ 已存在，跳過"
else
  ffmpeg -i "$VIDEO_FILE" -vn -acodec pcm_s16le -ar 16000 -ac 1 "$AUDIO_FILE" -y 2>/dev/null
  echo "   ✅ 音頻提取完成"
fi

# Step 3: Whisper 語音轉文字
echo ""
echo "🗣️ Step 3: 語音轉文字 (Whisper)..."
TXT_FILE="$OUTPUT_DIR/${SAFE_TITLE}.txt"

if [ -f "$TXT_FILE" ]; then
  echo "   ✅ 已存在，跳過"
else
  if [ "$WHISPER_CMD" = "mlx_whisper" ]; then
    mlx_whisper --model mlx-community/whisper-large-v3-turbo --language "$LANG" \
      --output-format txt --output-dir "$OUTPUT_DIR" "$AUDIO_FILE" 2>/dev/null
    # mlx_whisper 輸出檔名可能不同，重命名
    MLX_OUT="$OUTPUT_DIR/${SAFE_TITLE}.txt"
    if [ ! -f "$MLX_OUT" ]; then
      # 找最新的 txt
      mv "$(ls -t $OUTPUT_DIR/*.txt 2>/dev/null | head -1)" "$TXT_FILE" 2>/dev/null || true
    fi
  else
    whisper "$AUDIO_FILE" --language "$LANG" --model large-v3 \
      --output_format txt --output_dir "$OUTPUT_DIR" 2>/dev/null
  fi
  echo "   ✅ 轉文字完成"
fi

# Step 4: 輸出結果
echo ""
echo "═══════════════════════════════════════"
echo "📊 分析結果"
echo "═══════════════════════════════════════"
echo ""
echo "📹 標題: $TITLE"
echo "🔗 來源: $URL"
echo "📝 字幕檔: $TXT_FILE"
echo ""

if [ -f "$TXT_FILE" ]; then
  WORD_COUNT=$(wc -c < "$TXT_FILE" | tr -d ' ')
  LINE_COUNT=$(wc -l < "$TXT_FILE" | tr -d ' ')
  echo "📊 字數: ${WORD_COUNT} 字元 / ${LINE_COUNT} 行"
  echo ""
  echo "─── 完整內容 ───"
  echo ""
  cat "$TXT_FILE"
  echo ""
  echo "─── 結束 ───"
fi

echo ""
echo "✅ 全部完成！檔案在: $OUTPUT_DIR/"
echo ""
echo "💡 下一步: 把文字內容丟給 AI 做摘要、翻譯、或內容再創作"
