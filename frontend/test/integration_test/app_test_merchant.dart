import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:csi5112_frontend/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    // Combine everything into one test to avoid some kinda of unknown failures
    testWidgets('All tests',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      // We cannot test Login screen due to multiple issues:
      // https://github.com/flutter/flutter/issues/31066
      // https://github.com/NearHuscarl/flutter_login/issues/240
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Item Setup'), findsWidgets);
    });
  });
}