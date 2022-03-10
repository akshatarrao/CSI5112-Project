import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/customer_home.dart';
import 'package:csi5112_frontend/page/discussion_forum.dart';
import 'package:csi5112_frontend/page/merchant_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  // *********************************************************
  // First Testing the Discussion Forum on the Buyer Side
  // *********************************************************
  testWidgets('discussion forum - buyer side', (tester) async { 
  
    User user = User(name: "fake", password: "fake", userType: "buyer", id: -1);

    Widget testWidget = MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(home: MyHomePage(redirected: DiscussionForum(isCustomer: true, unitTest: true, currentUser:user), currentUser:user))
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();
    
    // Testing that Buyer Side Navigation Elements are there
    expect(find.text('Items List'), findsOneWidget); // This should be present as the navigation - seen in Widget Inspector
    expect(find.text('Order History'), findsOneWidget); 
    expect(find.text('Discussion forum'), findsNWidgets(2)); // One as page title and one as navigation 

    // Testing that reached the Discussion Forum Page
    expect(find.text('Question 0 Title'), findsWidgets);

    // Testing that the add question form appears and dissapears as expected
    expect(find.text('New Question'), findsNothing);
    await tester.tap(find.byType(ElevatedButton)); // clicking on the new button
    await tester.pumpAndSettle();
    expect(find.text('New Question'), findsOneWidget);
    await tester.tap(find.byKey(const Key('CloseForm'))); // close the form without submitting
    await tester.pumpAndSettle();
    expect(find.text('New Question'), findsNothing);

    // Testing clicking on a question to get to a Answer Page and then coming back to Question Page
    await tester.tap(find.ancestor(of: find.text('Question 2 Title'), matching: find.byKey(const Key('QuestionCard')))); // clicking on one of the questions
    await tester.pumpAndSettle();
    // Only one Question should be displayed at top of Answer Page
    expect(find.text('Question 0 Title'), findsNothing);
    expect(find.text('Question 2 Title'), findsOneWidget); 
    // Multiple Answers can be displayed
    expect(find.text('Reply By: UserX'), findsWidgets);
    expect(find.text('Reply By: UserZ'), findsWidgets);
    // Going back to Question Page
    await tester.pageBack();
    await tester.pumpAndSettle();
    // Now multiple Questions are Present
    expect(find.text('Question 0 Title'), findsWidgets);
    expect(find.text('Question 2 Title'), findsWidgets);
    // No Answers should now be displayed
    expect(find.text('Reply By: UserX'), findsNothing);
    expect(find.text('Reply By: UserZ'), findsNothing);

  });


  // *********************************************************
  //  Second Testing the Discussion Forum on the Merchant Side
  // *********************************************************
  testWidgets('discussion forum - merchant side', (tester) async { 
  
    User user = User(name: "fake", password: "fake", userType: "merchant", id: -1);

    Widget testWidget = MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(home: MerchantPage(redirected: DiscussionForum(isCustomer: true, unitTest: true, currentUser:user), currentUser:user))
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    // Testing that Buyer Side Navigation Elements are there
    expect(find.text('Item Setup'), findsOneWidget); // This should be present as the navigation - seen in Widget Inspector
    expect(find.text('Order History'), findsOneWidget); 
    expect(find.text('Discussion forum'), findsNWidgets(2)); // One as page title and one as navigation 

    // Testing that reached the Discussion Forum Page
    expect(find.text('Question 0 Title'), findsWidgets);

    // Testing that the add question form appears and dissapears as expected
    expect(find.text('New Question'), findsNothing);
    await tester.tap(find.byType(ElevatedButton)); // clicking on the new button
    await tester.pumpAndSettle();
    expect(find.text('New Question'), findsOneWidget);
    await tester.tap(find.byKey(const Key('CloseForm'))); // close the form without submitting
    await tester.pumpAndSettle();
    expect(find.text('New Question'), findsNothing);

    // Testing clicking on a question to get to a Answer Page and then coming back to Question Page
    await tester.tap(find.ancestor(of: find.text('Question 2 Title'), matching: find.byKey(const Key('QuestionCard')))); // clicking on one of the questions
    await tester.pumpAndSettle();
    // Only one Question should be displayed at top of Answer Page
    expect(find.text('Question 0 Title'), findsNothing);
    expect(find.text('Question 2 Title'), findsOneWidget); 
    // Multiple Answers can be displayed
    expect(find.text('Reply By: UserX'), findsWidgets);
    expect(find.text('Reply By: UserZ'), findsWidgets);
    // Going back to Question Page
    await tester.pageBack();
    await tester.pumpAndSettle();
    // Now multiple Questions are Present
    expect(find.text('Question 0 Title'), findsWidgets);
    expect(find.text('Question 2 Title'), findsWidgets);
    // No Answers should now be displayed
    expect(find.text('Reply By: UserX'), findsNothing);
    expect(find.text('Reply By: UserZ'), findsNothing);

  });

  // *********************************************************
  // Additional Notes
  // *********************************************************

  // Cannot test Search or Add Question as that requires the 
  // service side.

}