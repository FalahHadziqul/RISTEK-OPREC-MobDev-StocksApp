import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('smoke test renders Material shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('RiSTOCK'))),
    );

    expect(find.text('RiSTOCK'), findsOneWidget);
  });
}
