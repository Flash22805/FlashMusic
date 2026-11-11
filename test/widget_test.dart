import 'package:flutter_test/flutter_test.dart';
import 'package:flash_music/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FlashMusicApp());
    expect(find.text('FlashMusic'), findsOneWidget);
  });
}
