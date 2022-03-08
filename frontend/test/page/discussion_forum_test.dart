import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/main.dart';
import 'package:csi5112_frontend/page/customer_home.dart';
import 'package:csi5112_frontend/page/discussion_forum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('discussion forum ...', (tester) async {
    // TODO: Implement test

    // Here I think the difficulty is to get to the correct page
    
    User user = User(name: "admin@gmail.com", password: "admin", userType: "buyer", id: 0);

    await tester.pumpWidget(const MyApp());
    await tester.pumpWidget(MyHomePage(redirected: DiscussionForum(isCustomer: true ,currentUser:user),currentUser:user));
    
    expect(find.text('Items List'), findsOneWidget); // This should be present as the navigation - seen in Widget Inspector

    expect(find.text('Question 1'), findsWidgets); // This should be present as a question title  - seen in Widget Inspector
  });
}