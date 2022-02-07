import 'dataModal/order_history_info.dart';

List<OrderHistoryInfo> orders = [
  OrderHistoryInfo(
      DateTime.now().add(const Duration(hours: 1)), "Paid", 123456789, 240, 123),
  OrderHistoryInfo(
      DateTime.now().add(const Duration(hours: 1)), "Paid", 123451232, 240, 5),
  OrderHistoryInfo(
      DateTime.now().add(const Duration(hours: 1)), "Paid", 123452131, 250, 20),
  OrderHistoryInfo(
      DateTime.now().add(const Duration(hours: 1)), "Paid", 987654321, 360, 12),
  OrderHistoryInfo(
      DateTime.now().add(const Duration(hours: 1)), "Paid", 142357809, 700, 34)
];
