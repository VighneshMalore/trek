// This is a basic Flutter widget test for TrailMate app shell.

import 'package:flutter_test/flutter_test.dart';
import 'package:trekplanner/main.dart';

void main() {
  testWidgets('TrailMate app shell smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TrailMateApp());

    // Verify that Home screen is shown by default.
    expect(find.text('Home'), findsWidgets);
  });
}
