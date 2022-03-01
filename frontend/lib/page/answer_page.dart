import 'dart:convert';

import 'package:avatars/avatars.dart';
import 'package:csi5112_frontend/dataModel/answer.dart';
import 'package:csi5112_frontend/dataModel/question.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart';

import '../component/theme_data.dart';

int numAnswers = 0;

class AnswerPage extends StatefulWidget {
  final int questionID;

  const AnswerPage(this.questionID, {Key? key}) : super(key: key);

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  late Future<List<Question>> futureQuestions;
  late Future<List<Answer>> futureAnswers;

  //List<Question> questions = Question.getFakeQuestionData();
  //List<Answer> answers = Answer.getFakeAnswerData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.backgrounColor,
        appBar: AppBar(),
        body: FutureBuilder(
            builder:(context, snapshot) {
            if (snapshot.hasData == false) {
              return const CircularProgressIndicator();
            }
            List<List<Object>> temp = (snapshot.data as List<List<Object>>);
            List<Question> questions = (temp[0] as List<Question>);
            List<Answer> answers = (temp[1] as List<Answer>);
            numAnswers = answers.length;
            return ListView.builder(
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

                  return newAnswerRow(context);

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
              });
            },
            future: Future.wait([
              futureQuestions,
              futureAnswers
            ])
          ));
  }

Widget newAnswerRow(BuildContext context) {
  final _aDescription = TextEditingController();
  
  return Padding(padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children:<Widget>[
                      Flexible(child: TextFormField(
                          controller: _aDescription,
                          //obscureText: false,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Add Reply...')
                      )),
                      Padding(padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: const Color(0xff161616), 
                                    shadowColor: Colors.white,
                                    shape: const StadiumBorder()),
                                onPressed: () {
                                  postAnswer(_aDescription.text);
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                        AnswerPage(widget.questionID)),
                                  );              
                                },
                                child: const Text('Submit'),
                        ))
                      ]
                 )
                 
               );
}


void postAnswer(String aDescription) {

    // This code was initially generated from postman code snippet and then modified to be more general 
    // Also, used this method to get the submitted text:
    // https://stackoverflow.com/questions/51390824/capture-data-from-textformfield-on-flutter-for-http-post-request
    var headers = {
      'Content-Type': 'application/json'
    };

    var request = Request('POST', Uri.parse('https://localhost:7156/api/answer'));
    request.body = json.encode({
      "answer": aDescription,
      "user": {
        "username": "merchant@gmail.com",
        "password": "merchant",
        "userType": "merchant",
        "id": 1
      },
      "time": DateTime.now().toIso8601String(),
      "questionId": widget.questionID,
      "id": numAnswers
    });
    request.headers.addAll(headers);

    request.send();

    //StreamedResponse response = await request.send();

    //if (response.statusCode == 200) {
    //  print(await response.stream.bytesToString());
    //}
    //else {
    //  print(response.reasonPhrase);
    //}

  }

  Future<List<Question>> getQuestions() async {
    final response = await get(Uri.parse('https://127.0.0.1:7156/api/question'));
    
    if(response.statusCode == 200) {
      return Question.fromListJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get Question Data from Service');
    }

  }

  Future<List<Answer>> getAnswers() async {
    final response = await get(Uri.parse('https://127.0.0.1:7156/api/answer'));
    
    if(response.statusCode == 200) {
      return Answer.fromListJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get Answer Data from Service');
    }

  }

  @override
  void initState() {
    super.initState();
    futureQuestions = getQuestions();
    futureAnswers = getAnswers();
  }

}
