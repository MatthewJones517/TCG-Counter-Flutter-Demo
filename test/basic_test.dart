/// This is a simple Unit test to make sure counter functionality is working
/// as expected.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tcg_counter/src/app.dart';

void main() {
  testWidgets('Make sure title and menu display', (WidgetTester tester) async {
    // Launch app
    await tester.pumpWidget(App());

    expect(find.text('TCG Counter'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });
}
