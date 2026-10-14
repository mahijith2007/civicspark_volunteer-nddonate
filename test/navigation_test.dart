import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:civicspark_demo/main.dart';
import 'package:civicspark_demo/screens/splash_screen.dart';
import 'package:civicspark_demo/main_shell.dart';

void main() {
  testWidgets('Push/pop navigation: tabs navigate back to previous selected page, and home pops to splashscreen', (tester) async {
    await tester.pumpWidget(const CivicSparkApp());

    // 1. Initial screen is SplashScreen
    expect(find.byType(SplashScreen), findsOneWidget);

    // Run splash sequence into MainShell
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump(const Duration(milliseconds: 600)); // PageRouteBuilder transition

    // 2. We are now on HomeScreen (index 0) in MainShell
    expect(find.byType(MainShell), findsOneWidget);
    final indexedStackFinder = find.byType(IndexedStack);
    expect(indexedStackFinder, findsOneWidget);
    IndexedStack indexedStack = tester.widget<IndexedStack>(indexedStackFinder);
    expect(indexedStack.index, 0);

    // 3. Switch to Organizations tab (index 2) via bottom nav icon
    await tester.tap(find.byIcon(Icons.business_outlined));
    await tester.pump(const Duration(milliseconds: 300));

    indexedStack = tester.widget<IndexedStack>(indexedStackFinder);
    expect(indexedStack.index, 2); // OrganizationsScreen

    // 4. Go back while in Organizations -> moves to previous selected page (Home, index 0)
    final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
    await widgetsAppState.didPopRoute();
    await tester.pump(const Duration(milliseconds: 300));

    indexedStack = tester.widget<IndexedStack>(indexedStackFinder);
    expect(indexedStack.index, 0); // HomeScreen

    // 5. Go back while on Home -> pops MainShell and loads SplashScreen
    await widgetsAppState.didPopRoute();
    await tester.pump(const Duration(milliseconds: 600)); // Pop transition

    // Verify SplashScreen is loaded
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Igniting Community Action'), findsOneWidget);

    // Complete splash sequence timers so fakeAsync has no pending timers
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump(const Duration(milliseconds: 600));
  });

  testWidgets('Multi-tab history navigation preserves push/pop order', (tester) async {
    await tester.pumpWidget(const CivicSparkApp());

    // Advance splash sequence into MainShell
    await tester.pump(const Duration(milliseconds: 3100));
    await tester.pump(const Duration(milliseconds: 600));

    final indexedStackFinder = find.byType(IndexedStack);
    IndexedStack indexedStack = tester.widget<IndexedStack>(indexedStackFinder);
    expect(indexedStack.index, 0); // Home

    // Navigate: Home (0) -> Campaigns (1) -> Orgs (2) -> Issues (3)
    await tester.tap(find.byIcon(Icons.campaign_outlined));
    await tester.pump(const Duration(milliseconds: 300));
    indexedStack = tester.widget<IndexedStack>(indexedStackFinder);
    expect(indexedStack.index, 1); // Campaigns

    await tester.tap(find.byIcon(Icons.business_outlined));
    await tester.pump(const Duration(milliseconds: 300));
    indexedStack = tester.widget<IndexedStack>(indexedStackFinder);
    expect(indexedStack.index, 2); // Orgs

    await tester.tap(find.byIcon(Icons.report_problem_outlined));
    await tester.pump(const Duration(milliseconds: 300));
    indexedStack = tester.widget<IndexedStack>(indexedStackFinder);
    expect(indexedStack.index, 3); // Issues

    final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));

    // Pop from Issues -> should go to Orgs (2)
    await widgetsAppState.didPopRoute();
    await tester.pump(const Duration(milliseconds: 300));
    indexedStack = tester.widget<IndexedStack>(indexedStackFinder);
    expect(indexedStack.index, 2); // Orgs

    // Pop from Orgs -> should go to Campaigns (1)
    await widgetsAppState.didPopRoute();
    await tester.pump(const Duration(milliseconds: 300));
    indexedStack = tester.widget<IndexedStack>(indexedStackFinder);
    expect(indexedStack.index, 1); // Campaigns

    // Pop from Campaigns -> should go to Home (0)
    await widgetsAppState.didPopRoute();
    await tester.pump(const Duration(milliseconds: 300));
    indexedStack = tester.widget<IndexedStack>(indexedStackFinder);
    expect(indexedStack.index, 0); // Home

    // Pop from Home -> should go to Splash
    await widgetsAppState.didPopRoute();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(SplashScreen), findsOneWidget);

    // Complete splash sequence timers
    await tester.pump(const Duration(milliseconds: 3100));
    await tester.pump(const Duration(milliseconds: 600));
  });
}
