/*TODO: add test if once the requirements are finalized */

import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/customer_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('merchant_home_test', (WidgetTester tester) async {
    final now = DateTime.now();

    User user = User(
        name: "merchant@gmail.com",
        password: "merchant",
        userType: "merchant",
        id: 0);
    await tester.pumpWidget(MyHomePage(currentUser: user));
    var scaffold = find.byType(SafeArea);
    expect(scaffold, findsNWidgets(2));
  });
}
