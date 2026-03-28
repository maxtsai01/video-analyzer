#!/bin/bash
# 🦞 批量分析 — 一次分析整個頻道或多個影片
# 用法: 
#   ./batch-analyze.sh --channel <頻道URL> [語言] [數量]
#   ./batch-analyze.sh --list <urls.txt> [語言]

set -e

MODE=""
INPUT=""
LANG="zh"
LIMIT=10
OUTPUT_DIR="./output"

while [[ $# -gt 0 ]]; do
  case $1 in
    --channel) MODE="channel"; INPUT="$2"; shift 2 ;;
    --list) MODE="list"; INPUT="$2"; shift 2 ;;
    --lang) LANG="$2"; shift 2 ;;
    --limit) LIMIT="$2"; shift 2 ;;
    --output) OUTPUT_DIR="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$MODE" ] || [ -z "$INPUT" ]; then
  echo "🦞 批量影片分析器"
  echo ""
  echo "用法:"
  echo "  ./batch-analyze.sh --channel <頻道URL> [--lang zh] [--limit 10]"
  echo "  ./batch-analyze.sh --list urls.txt [--lang zh]"
  echo ""
  echo "參數:"
  echo "  --channel  YouTube/B站 頻道 URL"
  echo "  --list     包含影片 URL 的文字檔（一行一個）"
  echo "  --lang     語言 (zh/en/ja)，預設 zh"
  echo "  --limit    頻道模式下最多抓幾支，預設 10"
  echo "  --output   輸出目錄，預設 ./output"
  echo ""
  echo "範例:"
  echo "  ./batch-analyze.sh --channel https://www.youtube.com/@channel --limit 20"
  echo "  ./batch-analyze.sh --list my-videos.txt --lang en"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

# Cookie 偵測
COOKIE_OPTS=""
if [ -f "./cookies.txt" ]; then
  COOKIE_OPTS="--cookies ./cookies.txt"
  echo "🍪 使用 cookies.txt"
fi

# 收集 URL 列表
URLS_FILE=$(mktemp)

if [ "$MODE" = "channel" ]; then
  echo "📺 抓取頻道影片列表（最多 $LIMIT 支）..."
  yt-dlp $COOKIE_OPTS --flat-playlist --print url "$INPUT" 2>/dev/null | head -$LIMIT > "$URLS_FILE"
  TOTAL=$(wc -l < "$URLS_FILE" | tr -d ' ')
  echo "   找到 $TOTAL 支影片"
elif [ "$MODE" = "list" ]; then
  cp "$INPUT" "$URLS_FILE"
  TOTAL=$(wc -l < "$URLS_FILE" | tr -d ' ')
  echo "📋 讀取列表：$TOTAL 支影片"
fi

if [ "$TOTAL" = "0" ]; then
  echo "❌ 沒有找到影片"
  rm "$URLS_FILE"
  exit 1
fi

# 逐一分析
COUNT=0
SUMMARY_FILE="$OUTPUT_DIR/_summary.md"
echo "# 批量分析報告" > "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"
echo "分析時間: $(date '+%Y-%m-%d %H:%M')" >> "$SUMMARY_FILE"
echo "影片數量: $TOTAL" >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"
echo "---" >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"

while IFS= read -r url; do
  COUNT=$((COUNT + 1))
  echo ""
  echo "═══════════════════════════════════════"
  echo "[$COUNT/$TOTAL] $url"
  echo "═══════════════════════════════════════"
  
  # 用 analyze.sh 處理單支影片
  ./analyze.sh "$url" "$LANG" "$OUTPUT_DIR" 2>&1
  
  # 加到摘要
  TITLE=$(yt-dlp $COOKIE_OPTS --get-title "$url" 2>/dev/null | head -1)
  SAFE_TITLE=$(echo "$TITLE" | tr '/' '_' | tr ' ' '_' | cut -c1-50)
  TXT_FILE="$OUTPUT_DIR/${SAFE_TITLE}.txt"
  
  echo "## $COUNT. $TITLE" >> "$SUMMARY_FILE"
  echo "- URL: $url" >> "$SUMMARY_FILE"
  if [ -f "$TXT_FILE" ]; then
    WORDS=$(wc -c < "$TXT_FILE" | tr -d ' ')
    echo "- 字數: ${WORDS} 字元" >> "$SUMMARY_FILE"
    echo "- 前 100 字: $(head -c 100 "$TXT_FILE")" >> "$SUMMARY_FILE"
  fi
  echo "" >> "$SUMMARY_FILE"
  
  # 影片之間等待
  if [ $COUNT -lt $TOTAL ]; then
    echo "⏳ 等待 5 秒..."
    sleep 5
  fi
done < "$URLS_FILE"

rm "$URLS_FILE"

echo ""
echo "═══════════════════════════════════════"
echo "🏁 批量分析完成！"
echo "   共 $TOTAL 支影片"
echo "   輸出目錄: $OUTPUT_DIR/"
echo "   摘要報告: $SUMMARY_FILE"
echo "═══════════════════════════════════════"
