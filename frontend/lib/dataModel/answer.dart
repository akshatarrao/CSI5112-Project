class Answer {
  int id;
  String answer;
  String user;
  DateTime date;
  int questionID;

  Answer(this.id, this.answer, this.user, this.date, this.questionID);

  static getFakeAnswerData() {
    return [
      Answer(
          0,
          "Answer 0 explanation. Some More Text. Even more text so it goes across more than one line.",
          "UserW",
          DateTime(2002, 2, 2),
          1),
      Answer(
          1,
          "Answer 1 explanation. Some More Text. Even more text so it goes across more than one line.",
          "UserX",
          DateTime(2002, 2, 3),
          1),
      Answer(
          2,
          "Answer 2 explanation. Some More Text. Even more text so it goes across more than one line.",
          "UserY",
          DateTime(2002, 2, 5),
          1),
      Answer(
          3,
          "Answer 3 explanation. Some More Text. Even more text so it goes across more than one line.",
          "UserX",
          DateTime(2002, 2, 4),
          2),
      Answer(
          4,
          "Answer 4 explanation. Some More Text. Even more text so it goes across more than one line.",
          "UserZ",
          DateTime(2002, 2, 7),
          2),
      Answer(
          5,
          "Answer 5 explanation. Some More Text. Even more text so it goes across more than one line.",
          "UserZ",
          DateTime(2002, 2, 7),
          2),
      Answer(
          6,
          "Answer 6 explanation. Some More Text. Even more text so it goes across more than one line.",
          "UserW",
          DateTime(2002, 2, 9),
          0),
    ];
  }
}