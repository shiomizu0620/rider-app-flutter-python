// VentScreen の基本的なウィジェットテスト。

import 'package:flutter_test/flutter_test.dart';

import 'package:rider_app/main.dart';

void main() {
  testWidgets('起動時に「待機中」が表示される', (WidgetTester tester) async {
    // アプリをビルドして1フレーム描画する。
    await tester.pumpWidget(const MyApp());

    // 初期状態のステータスが表示されていることを確認する。
    expect(find.text('待機中'), findsOneWidget);
  });
}
