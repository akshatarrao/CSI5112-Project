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
  Question(0, "Question 0 Title", "Description 0. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text.", "A", DateTime(2002,2,1), 1),
  Question(1, "Question 1 Title", "Description 1", "K", DateTime(2002,2,1), 3),
  Question(2, "Question 2 Title", "Description 2", "UserB", DateTime(2002,2,3), 3),
  Question(3, "Question 3 Title", "Description 3", "UserA", DateTime(2002,2,10), 0),
];

List<Answer> answers = [
  Answer(
      0,
      "Answer 0 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserW",
      DateTime(2002,2,2),
      1),
  Answer(
      1,
      "Answer 1 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserX",
      DateTime(2002,2,3),
      1),
  Answer(
      2,
      "Answer 2 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserY",
      DateTime(2002,2,5),
      1),
  Answer(
      3,
      "Answer 3 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserX",
      DateTime(2002,2,4),
      2),
  Answer(
      4,
      "Answer 4 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserZ",
      DateTime(2002,2,7),
      2),
  Answer(
      5,
      "Answer 5 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserZ",
      DateTime(2002,2,7),
      2),
    Answer(
      6,
      "Answer 6 explanation. Some More Text. Even more text so it goes across more than one line.",
      "UserW",
      DateTime(2002,2,9),
      0),
];
