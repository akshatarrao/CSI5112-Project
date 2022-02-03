class OrderHistoryInfo {
  DateTime orderDate;
  String merchant;
  String ispaid;
  int amount;
  int itemsCount;

  OrderHistoryInfo(
      this.orderDate, this.ispaid, this.merchant, this.amount, this.itemsCount);
}
