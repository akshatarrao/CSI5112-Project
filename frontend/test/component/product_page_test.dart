/*TODO: add test if once the requirements are finalized */

import 'package:csi5112_frontend/page/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('product_page_test', (WidgetTester tester) async {
    await tester.pumpWidget(ProductPage());
    var scaffold = find.byType(Scaffold);
    expect(scaffold, findsOneWidget);
  });
}