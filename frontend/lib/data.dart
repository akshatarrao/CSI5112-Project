import 'dataModel/order_history_info.dart';
import 'dataModel/question.dart';
import 'dataModel/answer.dart';

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


List<Question> questions = [
  Question(0, "Question 0", "Description 0", "A", "Feb2020", 0),
  Question(1, "Question 1", "Description 1", "A", "Feb2020", 3),
  Question(2, "Question 2", "Description 2", "UserB", "Feb2020", 3),
  Question(3, "Question 3", "Description 3", "UserA", "Feb2020", 0),
];

List<Answer> answers = [
  Answer(
      0,
      "Answer 0 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserW",
      "Feb2022",
      1),
  Answer(
      1,
      "Answer 1 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserX",
      "Feb2022",
      1),
  Answer(
      2,
      "Answer 2 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserY",
      "Feb2022",
      1),
  Answer(
      3,
      "Answer 3 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserX",
      "Feb2022",
      2),
  Answer(
      4,
      "Answer 4 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserZ",
      "Feb2022",
      2),
  Answer(
      5,
      "Answer 5 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserZ",
      "Feb2022",
      2),
];
