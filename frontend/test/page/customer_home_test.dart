import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/main.dart';
import 'package:csi5112_frontend/page/customer_home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('customer home ...', (tester) async {
    // TODO: Implement test

    // I think the problem might be how to load the page for testing

    await tester.pumpWidget(const MyApp());
    await tester.pumpWidget(MyHomePage(currentUser: User(name: "fake", password: "fake", userType: "hh",id:-1)));
    
    expect(find.text('Items List'), findsOneWidget); // This should be present as the navigation - seen in Widget Inspector

    expect(find.text('0'), findsWidgets); // This should be present as starting amount for number of products to buy  - seen in Widget Inspector

  });
}