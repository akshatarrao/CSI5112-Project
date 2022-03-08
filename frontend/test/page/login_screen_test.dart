import 'package:csi5112_frontend/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login screen ...', (tester) async {
    // TODO: Implement test

    // Basically just want to get to the login screen and verify the login button is present
    // However, when looking at the 'Dart DevTools' Wigit inspector is seems like it is 
    // hard to see any widgets displayed on the page.

    await tester.pumpWidget(const MyApp());

    expect(find.text('LOGIN'), findsOneWidget);

  });
}