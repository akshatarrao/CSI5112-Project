class OrderHistory {
  DateTime orderDate;
  int orderId;
  String isPaid;
  int amount;
  int itemsCount;

  // Historical items list stored as a snapshot
  String itemsSnapshot;

  OrderHistory(this.orderDate, this.isPaid, this.orderId, this.amount,
      this.itemsCount, this.itemsSnapshot);

  static getFakeOrderHistoryData() {
    return [
      OrderHistory(DateTime.now().add(const Duration(hours: 1)), "Paid",
          123456789, 240, 123, ''),
      OrderHistory(DateTime.now().add(const Duration(hours: 1)), "Paid",
          123451232, 240, 5, ''),
      OrderHistory(DateTime.now().add(const Duration(hours: 1)), "Paid",
          123452131, 250, 20, ''),
      OrderHistory(DateTime.now().add(const Duration(hours: 1)), "Paid",
          987654321, 360, 12, ''),
      OrderHistory(DateTime.now().add(const Duration(hours: 1)), "Paid",
          142357809, 700, 34, '')
    ];
  }
}
