import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:csi5112_frontend/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    // Combine everything into one test to avoid some kinda of unknown failures
    testWidgets('all tests',
        (WidgetTester tester) async {
       app.main();
  await tester.pumpAndSettle();
  // We cannot test Login screen due to multiple issues:
  // https://github.com/flutter/flutter/issues/31066
  // https://github.com/NearHuscarl/flutter_login/issues/240
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();

      // Default landing test
      expect(find.text('Items List'), findsWidgets);
      await tester.tap(find.byType(AnimatedIcon));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Log out"));
      await tester.pumpAndSettle();
      expect(find.text('LOGIN'), findsWidgets);
        await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();

      // Side bar test
      await tester.tap(find.byType(AnimatedIcon));
      await tester.pumpAndSettle();
     expect(find.text('Discussion forum'), findsWidgets);
     expect(find.text('Order History'), findsWidgets);

      // Nav to Discussion forum test
      await tester.tap(find.text("Discussion forum"));
      await tester.pumpAndSettle();
      expect(find.text('New'), findsOneWidget);

        // Nav to Order History test
        await tester.tap(find.byType(AnimatedIcon));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Order History"));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      expect(find.text('Search'), findsWidgets);
      expect(find.text('Order History'), findsWidgets);
    });

  });
}
