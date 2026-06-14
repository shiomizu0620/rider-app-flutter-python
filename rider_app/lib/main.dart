// pubspec.yaml に追加：
//   nfc_manager: ^3.5.0
//   web_socket_channel: ^3.0.0

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: VentScreen());
  }
}

class VentScreen extends StatefulWidget {
  @override
  State<VentScreen> createState() => _VentScreenState();
}

class _VentScreenState extends State<VentScreen> {
  String status = "カードをかざしてください";
  WebSocketChannel? channel;

  // ★ PCのIPアドレスに変える（後述）
  final String pcIP = "192.168.1.10";

  @override
  void initState() {
    super.initState();
    connectToPC();
    startNFC();
  }

  // PCに接続
  void connectToPC() {
    channel = WebSocketChannel.connect(
      Uri.parse("ws://$pcIP:8080"),
    );
  }

  // NFC読み取り開始
  void startNFC() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        // タグからテキストを取り出す
        final ndef = Ndef.from(tag);
        final records = ndef?.cachedMessage?.records;
        if (records != null && records.isNotEmpty) {
          final payload = records.first.payload;
          // 先頭の言語コード分を除いてテキスト化
          final text = String.fromCharCodes(payload.sublist(3));
          
          ventを発動(text);
        }
      },
    );
  }

  // 読んだIDをPCに送る
  void ventを発動(String id) {
    setState(() => status = "発動: $id");
    channel?.sink.add(id);   // ★PCに送信
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          status,
          style: TextStyle(color: Colors.amber, fontSize: 24),
        ),
      ),
    );
  }
}