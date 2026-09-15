import 'package:flutter_test/flutter_test.dart';
import 'package:zelvora/zelvora_shell.dart';

void main() {
  testWidgets('ZelvoraApp launches successfully smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZelvoraApp());
    expect(find.byType(ZelvoraApp), findsOneWidget);
  });
}