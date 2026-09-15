import 'package:flutter_test/flutter_test.dart';
import 'package:zelvora/zelvora_app.dart';

void main() {
  testWidgets('ZelvoraApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZelvoraApp());
    expect(find.text('Zelvora Greenhouse Hub'), findsOneWidget);
  });
}
