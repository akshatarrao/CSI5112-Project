class OrderHistory {
  late DateTime orderDate;
  late int orderId;
  late String isPaid;
  late double amount;
  late int itemsCount;

  // Historical items list stored as a snapshot
  late String itemsSnapshot;

  OrderHistory(this.orderDate, this.isPaid, this.orderId, this.amount,
      this.itemsCount, this.itemsSnapshot);

  OrderHistory.fromJson(Map<String, dynamic> json) {
    orderDate = DateTime.parse(json['time']);
    orderId = json['id'];
    isPaid = json['isPaid'] == true ? "Paid" : "Unpaid";
    amount = json['amount'];
    itemsCount = json['items'].split(',').length;
    itemsSnapshot = json['items'];
    OrderHistory(orderDate, isPaid, orderId, amount, itemsCount, itemsSnapshot);
  }

  
}
