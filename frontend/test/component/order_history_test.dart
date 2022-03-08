/*TODO: add test if once the requirements are finalized */

import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/order_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('order_history_test', (WidgetTester tester) async {
    final now = DateTime.now();

    User user = User(
        name: "admin@gmail.com", password: "admin", userType: "buyer", id: 0);
    await tester
        .pumpWidget(OrderHistoryPage(isCustomer: true, currentUser: user));
    var scaffold = find.byType(Scaffold);
    expect(scaffold, findsOneWidget);
  });
}
