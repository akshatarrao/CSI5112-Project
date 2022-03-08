/*TODO: add test if once the requirements are finalized */

import 'package:csi5112_frontend/dataModel/item.dart';
import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('item_list_test', (WidgetTester tester) async {
    final now = DateTime.now();
    double total = 500;

    Item item = Item(
      category: "category",
      name: "nullFlagHackItem",
      description: "description",
      price: 0,
      imageUrl: "imageUrl",
      id: 0,
    );
    List<Item> items = <Item>[
      Item(
        category: "category",
        name: "nullFlagHackItem",
        description: "description",
        price: 0,
        imageUrl: "imageUrl",
        id: 0,
      )
    ];
    Map<Item, int> selectedItem = {item: 2};

    User user = User(
        name: "admin@gmail.com", password: "admin", userType: "buyer", id: 0);
    ItemList il = ItemList(
      isInvoice: false,
      user: user,
      selectedItems: selectedItem,
      orderId: "123",
      invoiceTime: now,
      total: total,
    );

    await tester.pumpWidget(ItemList(
      isInvoice: false,
      user: user,
      selectedItems: selectedItem,
      orderId: "123",
      invoiceTime: now,
      total: total,
    ));
    var container = find.byType(Container);

    // var text = find.byType(CenteredText);
    // var card = find.descendant(of: container, matching: find.byType(Container));
    debugPrint(find.text('Details').description);

    expect(container, findsOneWidget);

    // final enterButton = tester.widget<ElevatedButton>(find.text('Details'));
    // var print_invoice = find.byType(Container);
    // var icon = find.byIcon(Icons.add_circle);

    // await tester.tap(find.byIcon(Icons.add_circle));

    //  await tester.tap(find.text('Details'));
    //await tester.pump();
    //expect(icon, findsOneWidget);
  });
}
