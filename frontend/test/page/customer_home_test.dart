import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/customer_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('customer home ...', (tester) async {
    Widget testWidget =MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(home: MyHomePage(currentUser: User(name: "fake", password: "fake", userType: "hh",id:-1),unitTest: true,))
);


    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(find.text('Items List'), findsWidgets); // This should be present as the navigation (both header and sidebar)

    expect(find.text('Buy what you want!'), findsOneWidget);

    expect(find.text('0'), findsWidgets); // This should be present as starting amount for number of products to buy  - seen in Widget Inspector

    // NOTE: More extensive testing done as integration tests

  });
}