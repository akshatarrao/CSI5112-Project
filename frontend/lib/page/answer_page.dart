import 'package:avatars/avatars.dart';
import 'package:csi5112_frontend/dataModel/answer.dart';
import 'package:csi5112_frontend/dataModel/question.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

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
              if (index == 0) {
                // Card class template: https://api.flutter.dev/flutter/material/Card-class.html
                return Card(
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
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none)),
                        ],
                      ),
                    ),
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
                // Card class template: https://api.flutter.dev/flutter/material/Card-class.html
                return Card(
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
                );
              } else {
                return Container();
              }
            }));
  }
}
