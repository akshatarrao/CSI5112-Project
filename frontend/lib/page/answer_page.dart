import 'package:flutter/material.dart';
import 'package:csi5112_frontend/data.dart';

class AnswerPage extends StatefulWidget {
  final int questionID;
  const AnswerPage(this.questionID, {Key? key}) : super(key: key);

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
            itemCount: answers.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Card(
                  // Card class template: https://api.flutter.dev/flutter/material/Card-class.html
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: const Text('Question'),
                        subtitle: Text(
                          questions[widget.questionID].title,
                        ),
                      ),
                    ],
                  ),
                );
              }
              index -= 1;
              if (index == answers.length) {
                return const TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Add Reply...',
                    suffixIcon: (Icon(Icons.send)),
                  ),
                );
              } else if (widget.questionID == answers[index].questionID) {
                return Card(
                  // Card class template: https://api.flutter.dev/flutter/material/Card-class.html
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
            }));
  }
}
