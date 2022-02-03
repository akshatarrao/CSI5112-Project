class OrderHistoryInfo {
  DateTime orderDate;
  int orderId;
  String ispaid;
  int amount;
  int itemsCount;

  OrderHistoryInfo(
      this.orderDate, this.ispaid, this.orderId, this.amount, this.itemsCount);
}
