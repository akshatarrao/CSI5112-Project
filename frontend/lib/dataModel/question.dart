class Question {
  int id;
  String title;
  String description;
  String user;
  DateTime date;
  int replies;

  Question(this.id, this.title, this.description, this.user, this.date,
      this.replies);

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      json['id'],
      json['title'],
      json['description'],
      json['user'],
      json['date'],
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
    return [
      Question(
          0,
          "Question 0 Title",
          "Description 0. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text. Some more text.",
          "A",
          DateTime(2002, 2, 1),
          1),
      Question(
          1, "Question 1 Title", "Description 1", "K", DateTime(2002, 2, 1), 3),
      Question(2, "Question 2 Title", "Description 2", "UserB",
          DateTime(2002, 2, 3), 3),
      Question(3, "Question 3 Title", "Description 3", "UserA",
          DateTime(2002, 2, 10), 0),
    ];
  }
}
