/*TODO: add test if once the requirements are finalized */

import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/discussion_forum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('discussion_form_test', (WidgetTester tester) async {
    User user = User(
        name: "admin@gmail.com", password: "admin", userType: "buyer", id: 0);
    await tester.pumpWidget(DiscussionForum(
      currentUser: user,
      isCustomer: true,
    ));
    var scaffold = find.byType(Scaffold);
    expect(scaffold, findsOneWidget);
  });
}
