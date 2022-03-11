import 'dart:math';

import 'package:csi5112_frontend/dataModel/item.dart';

class OrderHistory {
  late DateTime orderDate;
  late int orderId;
  late String isPaid;
  late double amount;
  late int itemsCount;
  var rng = Random();
  // Historical items list stored as a snapshot
  late Map<Item, int> itemsSnapshot;

  OrderHistory(this.orderDate, this.isPaid, this.orderId, this.amount,
      this.itemsCount, this.itemsSnapshot);

  OrderHistory.fromJson(Map<String, dynamic> json) {
    orderDate = DateTime.parse(json['time']);
    orderId = json['id'];
    isPaid = json['isPaid'] == true ? "Paid" : "Unpaid";
    amount = json['amount'];
    itemsCount = json['items'].split(',').length;
    itemsSnapshot = parseItem(json['items']);
    OrderHistory(orderDate, isPaid, orderId, amount, itemsCount, itemsSnapshot);
  }
  Map<Item, int> parseItem(String snapshot) {
    String editedSnapshot = snapshot.substring(1, snapshot.length - 1);
    final Map<Item, int> midSnapshot = <Item, int>{};
    List<String> itemsTotal = editedSnapshot.split(',');
    for (var i = 0; i < itemsTotal.length; i++) {
      print(itemsTotal.length);
      String itemsCountSplit =
          itemsTotal[i].substring(0, itemsTotal[i].length - 1);

      int qty = int.parse(itemsTotal[i].substring(itemsTotal[i].length - 1));
      List<String> itemSplit = itemsCountSplit.split(';');
      Item feedItem = Item(
        category: itemSplit[1],
        name: itemSplit[0].substring(1),
        description: itemSplit[2],
        price: double.parse(itemSplit[5].substring(0, itemSplit.length - 2)),
        imageUrl: itemSplit[3],
        id: rng.nextInt(20) + 40,
      );

      midSnapshot[feedItem] = qty;
    }
    return midSnapshot;
  }
}
