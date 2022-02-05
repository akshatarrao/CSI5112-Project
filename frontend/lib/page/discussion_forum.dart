import 'package:csi5112_frontend/component/app_bar.dart';
import 'package:flutter/material.dart';
import '../dataModal/question.dart';

class DiscussionForum extends StatefulWidget{
  const DiscussionForum({Key? key}) : super(key: key);

  @override
  State<DiscussionForum> createState() => _DiscussionForumState();
}

class _DiscussionForumState extends State<DiscussionForum> {

  static List<Question> questions = [
    Question("Question 1", "Description 1", "UserA", "Feb2020", 2),
    Question("Question 2", "Description 2", "UserB", "Feb2020", 7),
    Question("Question 3", "Description 3", "UserA", "Feb2020", 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar.getAppBar(context),
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
                return Card( // Card class template: https://api.flutter.dev/flutter/material/Card-class.html
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: TextButton(
                          child: Text(questions[index].title),
                          onPressed: () {},
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
              }
          )
    );
  }

}