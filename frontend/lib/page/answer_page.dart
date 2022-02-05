import 'package:csi5112_frontend/component/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:csi5112_frontend/dataModal/question.dart';
import 'package:csi5112_frontend/dataModal/answer.dart';

class AnswerPage extends StatefulWidget{
  final int questionID;
  const AnswerPage(this.questionID, {Key? key}) : super(key: key);

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {

  static List<Question> questions = [
    Question(0, "Question 0", "Description 0", "UserA", "Feb2020"),
    Question(1, "Question 1", "Description 1", "UserA", "Feb2020"),
    Question(2, "Question 2", "Description 2", "UserB", "Feb2020"),
    Question(3, "Question 3", "Description 3", "UserA", "Feb2020"),
  ];

  static List<Answer> answers = [
    Answer(0, "Answer 0 explanation. Some More Text. Even more text so it goes across more than one line.", "UserW", "Feb2022", 1),
    Answer(1, "Answer 1 explanation. Some More Text. Even more text so it goes across more than one line.", "UserX", "Feb2022", 1),
    Answer(2, "Answer 2 explanation. Some More Text. Even more text so it goes across more than one line.", "UserY", "Feb2022", 1),
    Answer(3, "Answer 3 explanation. Some More Text. Even more text so it goes across more than one line.", "UserX", "Feb2022", 2),
    Answer(4, "Answer 4 explanation. Some More Text. Even more text so it goes across more than one line.", "UserZ", "Feb2022", 2),
    Answer(5, "Answer 5 explanation. Some More Text. Even more text so it goes across more than one line.", "UserZ", "Feb2022", 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar.getAppBar(context),
        body: ListView.builder(
            itemCount: answers.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Card( // Card class template: https://api.flutter.dev/flutter/material/Card-class.html
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: TextButton(
                          child: Text(questions[widget.questionID].title),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AnswerPage(questions[widget.questionID].id)),
                            );
                          },
                        ),
                        subtitle: Text(questions[widget.questionID].description),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(questions[widget.questionID].user),
                          const SizedBox(width: 10),
                          Text(questions[widget.questionID].date)
                        ],
                      )
                    ],
                  ),
                );
              }
              index -= 1;
              if(index == answers.length) {
                return const TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Add Reply...',
                  ),
                );
              } else if(widget.questionID == answers[index].questionID) {
                return Card( // Card class template: https://api.flutter.dev/flutter/material/Card-class.html
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: const Text('Answer'),
                        subtitle: Text(answers[index].answer),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(answers[index].user),
                          const SizedBox(width: 10),
                          Text(answers[index].date)
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }
        )
    );
  }
}