import 'package:csi5112_frontend/dataModel/user.dart';

class Question {
  int id;
  String title;
  String description;
  User user;
  DateTime date;
  int replies;

  Question(this.id, this.title, this.description, this.user, this.date,
      this.replies);

  factory Question.fromJson(Map<String, dynamic> json) {
    User user = User.fromJson(json['user']);
    return Question(
      json['id'],
      json['title'],
      json['description'],
      user,
      DateTime.parse(json['time'].toString()),
      json['replies']
    );
  }

  static List<Question> fromListJson(List<dynamic> json) {
    List<Question> result = <Question>[];
    for(Map<String, dynamic> d in json) {
      result.add(Question.fromJson(d));
    }
    return result;
  }

  static getFakeQuestionData() {
    User user = User(name: "fake", password: "fake", userType: "buyer", id: -1);
    return [
      Question(
          0,
          "Question 0 Title",
          "Description 0. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text.",
          user,
          DateTime(2002, 2, 1),
          1),
      Question(
          1, "Question 1 Title", "Description 1", user, DateTime(2002, 2, 1), 3),
      Question(2, "Question 2 Title", "Description 2", user,
          DateTime(2002, 2, 3), 3),
      Question(3, "Question 3 Title", "Description 3", user,
          DateTime(2002, 2, 10), 0),
    ];
  }
}
