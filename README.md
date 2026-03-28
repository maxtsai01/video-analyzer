# 🦞 AI Video Analyzer — 影片自動轉文字分析工具

### 🔥 一個指令，把任何影片變成可搜尋、可分析的文字

> **「你的競爭對手在 YouTube 上講了什麼？你的同行在 B 站分享了什麼秘密？」**
> 
> 以前你得花好幾個小時一支一支看完。現在，一個指令搞定。

---

## 😤 痛點：你是不是也遇過這些問題？

- 想分析競品的 YouTube 影片，但一支 20 分鐘看不完
- B 站有大量中文教學資源，但沒有字幕、聽不清楚
- TikTok 上看到好的內容，想記下來卻來不及
- 想把影片內容改寫成文章，但手動打字太慢
- 團隊開會討論了半天，結論到底是什麼？

## ✅ 解法：一個指令，全自動搞定

```bash
./analyze.sh https://www.youtube.com/watch?v=xxx
```

**30 秒後，你就有完整的文字版本。**

不需要手動打字。不需要找字幕。不需要反覆重播。

---

## 🎯 誰需要這個工具？

| 你是... | 你可以用來... |
|---------|-------------|
| **行銷人** | 分析競品影片策略，看他們講了什麼、怎麼講的 |
| **自媒體** | 把別人的影片轉成文字 → 改寫成自己的文章/貼文 |
| **跨境電商** | 抓取海外教學影片，學習最新運營策略 |
| **研究人員** | 批量分析一個頻道的所有內容，找出趨勢 |
| **內容創作者** | 把自己的影片轉文字 → 做成部落格 SEO 文章 |
| **學生/學習者** | 自動把教學影片變成筆記 |

---

## 🚀 3 步搞定

### Step 1：安裝（一次就好）
```bash
brew install yt-dlp ffmpeg
pip install mlx-whisper  # Mac Apple Silicon
# 或 pip install openai-whisper  # Windows/Linux
```

### Step 2：分析單支影片
```bash
./analyze.sh https://www.youtube.com/watch?v=xxx zh
```

### Step 3：批量分析整個頻道
```bash
./batch-analyze.sh --channel https://www.youtube.com/@channel --limit 20
```

**就這樣。沒了。**

---

## 💡 支援平台

| 平台 | 需要登入？ | 備註 |
|------|-----------|------|
| ✅ YouTube | 不需要 | 直接跑 |
| ✅ TikTok | 不需要 | 直接跑 |
| ✅ Twitter/X | 不需要 | 直接跑 |
| ✅ IG Reels | 部分需要 | 私人帳號需 Cookie |
| ✅ **B 站** | **需要登入** | 提供 Cookie 即可（見下方教學） |

### B 站 Cookie 設定

B 站限制未登入用戶，所以你需要先登入再匯出 Cookie。

**最簡單的方法：**
```bash
# 如果你用 Comet 瀏覽器（已登入 B 站）
./export-cookies.sh 9333 bilibili
# 自動提取 Cookie，之後 analyze.sh 會自動使用
```

**其他方法：**
- Chrome 已登入 → 安裝「Get cookies.txt」擴充套件匯出
- 把 `cookies.txt` 放在腳本同目錄就好

---

## 📊 實測數據

我們用這個工具分析了 **AdsPower 官方 B 站頻道**：

| 指標 | 數字 |
|------|------|
| 分析影片數 | 12 支 |
| 總下載大小 | 115 MB |
| 下載時間 | 5 分鐘 |
| 轉文字時間 | 5 分鐘 |
| 產出文字量 | 23,408 字元 |

**10 分鐘 = 12 支影片的完整文字內容。** 手動做至少要 3 小時。

---

## 🔧 完整工具包

```
video-analyzer/
├── analyze.sh             ← 單支影片分析（下載→轉文字）
├── batch-analyze.sh       ← 批量頻道分析（自動產摘要報告）
├── export-cookies.sh      ← CDP 瀏覽器 Cookie 自動提取
├── cookies.txt            ← (自動產生) 登入 Cookie
└── output/
    ├── 影片標題.mp4       ← 原始影片
    ├── 影片標題.wav       ← 音頻
    ├── 影片標題.txt       ← 完整字幕文字
    └── _summary.md        ← 批量分析摘要報告
```

---

## 🌟 為什麼選這個工具？

| 比較 | 手動做 | 其他工具 | 🦞 Video Analyzer |
|------|--------|---------|-------------------|
| YouTube | 邊看邊抄 | 有些工具可以 | ✅ 一鍵搞定 |
| B 站 | 沒字幕就沒辦法 | 幾乎沒有工具 | ✅ Whisper 自動轉 |
| TikTok | 截圖記錄 | 少數工具可以 | ✅ 支援 |
| 批量分析 | 不可能 | 不可能 | ✅ 整個頻道一次搞定 |
| 中文支援 | - | 大多只支援英文 | ✅ 中/英/日 |
| 費用 | 免費但花時間 | $10-50/月 | ✅ 完全免費開源 |

---

## 🤔 常見問題

**Q：這合法嗎？**
A：本工具僅供個人學習和研究使用。請遵守各平台的服務條款。

**Q：需要 GPU 嗎？**
A：Mac Apple Silicon 用 `mlx-whisper` 不需要 GPU，速度也很快。Windows/Linux 有 GPU 會更快但不是必要。

**Q：影片很長怎麼辦？**
A：沒問題，Whisper 可以處理任意長度。1 小時影片大約需要 5-10 分鐘轉文字。

**Q：準確度如何？**
A：Whisper large-v3 的中文辨識準確度約 95%+。專有名詞可能會有誤差。

---

## 📢 這個工具是用 OpenClaw（🦞 龍蝦）自動化框架開發的

[OpenClaw](https://openclaw.ai) 是一個開源 AI Agent 框架，可以自動化各種數位工作流程。

這個 Video Analyzer 就是一個實際案例 — **AI 幫你看影片、幫你做筆記、幫你分析競品。**

想知道 OpenClaw 還能做什麼？
- 🐰 [自動社群互動](https://github.com/maxtsai01)
- 🌈 [AI 測驗系統](https://github.com/maxtsai01/rainbow-life)
- 🖼️ [AI 圖片處理](https://github.com/maxtsai01/ai-image-studio)

**更多自動化工具持續開發中 → 追蹤 [@10000allison](https://www.instagram.com/10000allison/)**

---

## ⭐ 覺得有用？

- 給個 Star ⭐ 支持開發
- Fork 改成你自己的版本
- 有問題開 Issue

---

*Built with 🦞 [OpenClaw](https://openclaw.ai) + 🗣️ [Whisper](https://github.com/openai/whisper) + 📹 [yt-dlp](https://github.com/yt-dlp/yt-dlp)*
