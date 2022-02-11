import 'package:avatars/avatars.dart';
import 'package:csi5112_frontend/dataModel/answer.dart';
import 'package:csi5112_frontend/dataModel/question.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../component/theme_data.dart';

class AnswerPage extends StatefulWidget {
  final int questionID;

  const AnswerPage(this.questionID, {Key? key}) : super(key: key);

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  List<Question> questions = Question.getFakeQuestionData();
  List<Answer> answers = Answer.getFakeAnswerData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.backgrounColor,
        appBar: AppBar(),
        body: ListView.builder(
            itemCount: answers.length + 2,
            itemBuilder: (BuildContext context, int index) {

              // In the first index (row) the question is written,
              // In middle indexs (rows) if the answer at (index - 1) is for the question it is printed
              // In the last index (row) a reply text field is printed
              //
              // Notice: trick of index = index-1 so that in fact there are two cases where index = 0

              if (index == 0) {
                // Card class template: https://api.flutter.dev/flutter/material/Card-class.html
                return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: Card(
                      child: GFListTile(
                        title: Text(questions[widget.questionID].title,
                            style: CustomText.textTitle),
                        subTitle: Text(questions[widget.questionID].description,
                            style: CustomText.textDescription),
                        avatar: Avatar(
                            name: questions[widget.questionID].user,
                            shape: AvatarShape.circle(16)),
                        icon: Container(
                          height: 30,
                          width: 60,
                          decoration: const BoxDecoration(
                              color: CustomColors.accentColors,
                              borderRadius: BorderRadius.all(Radius.circular(40))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                Icons.message,
                                size: 14,
                                color: Colors.white,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(top: 18, left: 0)),
                              Text(
                                  " " +
                                      questions[widget.questionID]
                                          .replies
                                          .toString(),
                                  textAlign: TextAlign.center,
                                  style: CustomText.customText),
                            ],
                          ),
                        ),
                      ),
                    )
                );
              }
              index -= 1;
              if (index == answers.length) {
                return const Padding(
                        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        child: TextField(
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Add Reply...',
                            suffixIcon: (Icon(Icons.send)))
                      )
                  );
              } else if (widget.questionID == answers[index].questionID) {
                // Card class template: https://api.flutter.dev/flutter/material/Card-class.html
                return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text("Reply By: " + answers[index].user,
                                style: CustomText.textSubTitle),
                            subtitle: Text(answers[index].answer,
                                style: CustomText.textDescription),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(answers[index].date.toString().substring(0, 19)),
                              const SizedBox(width: 10),
                            ],
                          ),
                          Row(children: const [SizedBox(height: 10)],)
                        ],
                      ),
                    )
                );
              } else {
                return Container();
              }
            }));
  }
}
