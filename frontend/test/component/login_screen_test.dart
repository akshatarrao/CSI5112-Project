/*TODO: add test if once the requirements are finalized */

import 'package:csi5112_frontend/page/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login_screen_test', (WidgetTester tester) async {
    await tester.pumpWidget(const LoginScreen());
    var scaffold = find.byType(Container);
    expect(scaffold, findsOneWidget);
  });
}
