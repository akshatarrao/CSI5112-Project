import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/customer_home.dart';
import 'package:csi5112_frontend/page/discussion_forum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('discussion forum ...', (tester) async {
    // TODO: Implement test
    User user = User(name: "admin@gmail.com", password: "admin", userType: "buyer", id: 0);
    
    Widget testWidget = MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(home: MyHomePage(redirected: DiscussionForum(isCustomer: true, unitTest: true, currentUser:user), currentUser:user))
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();
    
    expect(find.text('Items List'), findsOneWidget); // This should be present as the navigation - seen in Widget Inspector

    expect(find.text('Question 0 Title'), findsWidgets);


    // Testing that the add question form appears and dissapears as expected
    expect(find.text('New Question'), findsNothing);
    await tester.tap(find.byType(ElevatedButton)); // clicking on the new button
    await tester.pumpAndSettle();
    expect(find.text('New Question'), findsOneWidget);
    await tester.tap(find.byKey(const Key('CloseForm'))); // close the form without submitting
    await tester.pumpAndSettle();
    expect(find.text('New Question'), findsNothing);

  });
}