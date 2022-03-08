/*TODO: add test if once the requirements are finalized */

import 'package:csi5112_frontend/dataModel/item.dart';
import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('cart_test', (WidgetTester tester) async {
    final now = DateTime.now();
    double total = 500;

    Item item = Item(
        category: "category",
        name: "nullFlagHackItem",
        description: "description",
        price: 0,
        imageUrl: "imageUrl");
    List<Item> items = <Item>[
      Item(
          category: "category",
          name: "nullFlagHackItem",
          description: "description",
          price: 0,
          imageUrl: "imageUrl")
    ];
    Map<Item, int> selectedItem = {item: 2};

    User user = User(
        name: "admin@gmail.com",
        password: "admin",
        userType: "customer",
        id: 2);
    await tester.pumpWidget(ItemList(
      isInvoice: false,
      user: user,
      selectedItems: selectedItem,
      orderId: "123",
      invoiceTime: now,
      total: total,
    ));
    var container = find.byType(Container);
    expect(container, findsOneWidget);
  });
}
