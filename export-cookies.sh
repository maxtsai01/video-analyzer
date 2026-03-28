#!/bin/bash
# 🍪 從 CDP 瀏覽器提取 Cookie
# 用法: ./export-cookies.sh [CDP_PORT] [DOMAIN]
# 範例: ./export-cookies.sh 9333 bilibili

CDP_PORT="${1:-9333}"
DOMAIN="${2:-bilibili}"
OUTPUT="./cookies.txt"

echo "🍪 從 CDP port $CDP_PORT 提取 $DOMAIN Cookie..."

python3 << PYEOF
import json, asyncio, websockets, sys

async def export_cookies():
    try:
        # 取得 tab 列表
        import urllib.request
        tabs = json.loads(urllib.request.urlopen(f'http://127.0.0.1:${CDP_PORT}/json').read())
        ws_url = tabs[0]['webSocketDebuggerUrl']
        
        async with websockets.connect(ws_url) as ws:
            await ws.send(json.dumps({"id":1, "method":"Network.getAllCookies"}))
            resp = json.loads(await ws.recv())
            cookies = resp.get('result',{}).get('cookies',[])
            
            domain = "${DOMAIN}"
            matched = [c for c in cookies if domain in c.get('domain','')]
            
            if not matched:
                print(f"❌ 找不到 {domain} 的 Cookie，請先在瀏覽器登入")
                sys.exit(1)
            
            with open("${OUTPUT}", 'w') as f:
                f.write("# Netscape HTTP Cookie File\\n")
                for c in matched:
                    d = c.get('domain','')
                    if not d.startswith('.'):
                        d = '.' + d
                    secure = 'TRUE' if c.get('secure') else 'FALSE'
                    expires = str(int(c.get('expires', 0)))
                    if expires == '-1' or expires == '0':
                        expires = '1893456000'
                    f.write(f"{d}\\tTRUE\\t{c.get('path','/')}\\t{secure}\\t{expires}\\t{c['name']}\\t{c['value']}\\n")
            
            print(f"✅ 匯出 {len(matched)} 個 {domain} Cookie → ${OUTPUT}")
    
    except ConnectionRefusedError:
        print(f"❌ 無法連線 CDP port ${CDP_PORT}，請確認瀏覽器已開啟")
        sys.exit(1)
    except Exception as e:
        print(f"❌ 錯誤: {e}")
        sys.exit(1)

asyncio.run(export_cookies())
PYEOF
