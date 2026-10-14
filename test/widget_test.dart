import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:civicspark_demo/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen loads with CivicSpark sliver and campaigns', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    expect(find.text('CivicSpark'), findsWidgets);
    expect(find.text('Browse by Category'), findsOneWidget);
    expect(find.text('Featured Campaigns'), findsOneWidget);
  });
}
