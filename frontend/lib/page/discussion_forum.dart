import 'package:flutter/material.dart';
import 'package:csi5112_frontend/dataModal/question.dart';
import 'package:csi5112_frontend/page/answer_page.dart';

class DiscussionForum extends StatefulWidget {
  const DiscussionForum({Key? key}) : super(key: key);

  @override
  State<DiscussionForum> createState() => _DiscussionForumState();
}

class _DiscussionForumState extends State<DiscussionForum> {
  static List<Question> questions = [
    Question(0, "Question 0", "Description 0", "UserA", "Feb2020"),
    Question(1, "Question 1", "Description 1", "UserA", "Feb2020"),
    Question(2, "Question 2", "Description 2", "UserB", "Feb2020"),
    Question(3, "Question 3", "Description 3", "UserA", "Feb2020"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffE5E5E5),
        body: ListView.builder(
            itemCount: questions.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return const TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search here...',
                  ),
                );
              }
              index -= 1;
              return Card(
                // Card class template: https://api.flutter.dev/flutter/material/Card-class.html
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: TextButton(
                        child: Text(questions[index].title),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AnswerPage(questions[index].id)),
                          );
                        },
                      ),
                      subtitle: Text(questions[index].description),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(questions[index].user),
                        const SizedBox(width: 10),
                        Text(questions[index].date)
                      ],
                    )
                  ],
                ),
              );
            }));
  }
}
