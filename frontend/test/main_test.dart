import 'package:csi5112_frontend/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('The application loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    var startButton = find.text('Start');

    expect(startButton, findsOneWidget);
  });
}
