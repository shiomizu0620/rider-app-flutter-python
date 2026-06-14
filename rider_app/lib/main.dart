import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: VentScreen());
  }
}

class VentScreen extends StatefulWidget {
  const VentScreen({super.key});

  @override
  State<VentScreen> createState() => _VentScreenState();
}

class _VentScreenState extends State<VentScreen> {
  String status = "待機中";
  WebSocketChannel? channel;
  final _appLinks = AppLinks();

  final String pcIP = "172.20.10.3"; // PCのIP（テザリング時）

  @override
  void initState() {
    super.initState();
    connectToPC();
    listenForNFC();
  }

  void connectToPC() {
    try {
      channel = WebSocketChannel.connect(Uri.parse("ws://$pcIP:8080"));
    } catch (e) {
      setState(() => status = "接続エラー: $e");
    }
  }

  void listenForNFC() {
    // アプリ起動中にURLが来た場合
    _appLinks.uriLinkStream.listen((uri) {
      handleUri(uri);
    });
    // スリープ/終了から起動された場合
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) handleUri(uri);
    });
  }

  void handleUri(Uri uri) {
    final action = uri.host.toUpperCase(); // advent → ADVENT
    setState(() => status = "発動: $action");
    channel?.sink.add(action);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(status,
            style: TextStyle(color: Colors.amber, fontSize: 28)),
      ),
    );
  }
}