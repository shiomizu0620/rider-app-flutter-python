import asyncio
import websockets

async def handler(websocket):
    print("📱 スマホ接続！")
    async for message in websocket:
        print(f"受信: {message}")
        vent発動(message)

def vent発動(id):
    if id == "ADVENT":
        advent()
    elif id == "SWORD_VENT":
        sword_vent()
    else:
        print(f"未知のカード: {id}")

def advent():
    print("=" * 30)
    print("🪞 アドベント！ミラーモンスター召喚！")
    print("=" * 30)

def sword_vent():
    print("⚔️ ソードベント！")

async def main():
    async with websockets.serve(handler, "0.0.0.0", 8080):
        print("🖥️ PC待機中... ポート8080")
        await asyncio.Future()

asyncio.run(main())