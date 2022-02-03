import 'dataModel/order_history_info.dart';

List<OrderHistoryInfo> orders = [
  OrderHistoryInfo(DateTime.now().add(Duration(hours: 1)), "Paid",
      "XYZ Enterprises", 240, 123),
  OrderHistoryInfo(DateTime.now().add(Duration(hours: 1)), "Paid",
      "ABC Enterprises", 240, 5),
  OrderHistoryInfo(DateTime.now().add(Duration(hours: 1)), "Paid",
      "ABC Enterprises", 250, 20),
  OrderHistoryInfo(DateTime.now().add(Duration(hours: 1)), "Paid",
      "ABC Enterprises", 360, 12),
  OrderHistoryInfo(DateTime.now().add(Duration(hours: 1)), "Paid",
      "ABC Enterprises", 700, 34)
];
