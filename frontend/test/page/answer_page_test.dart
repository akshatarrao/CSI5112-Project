import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/answer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('answer page ...', (tester) async {
    // TODO: Implement test
    User user = User(name: "admin@gmail.com", password: "admin", userType: "buyer", id: 0);
    
    Widget testWidget = MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(home: AnswerPage(1, user, unitTest: true))
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();
    
    expect(find.text('Question 1 Title'), findsWidgets);

    expect(find.text('Answer 1 explanation. Some More Text. Even more text so it goes across more than one line.'), findsWidgets);

  });
}