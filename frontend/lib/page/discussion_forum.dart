import 'package:avatars/avatars.dart';
import 'package:csi5112_frontend/dataModel/question.dart';
import 'package:csi5112_frontend/page/answer_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:convert';
import 'package:http/http.dart';

import '../component/theme_data.dart';

int numQuestions = 0;

class DiscussionForum extends StatefulWidget {
  const DiscussionForum({Key? key}) : super(key: key);

  @override
  State<DiscussionForum> createState() => _DiscussionForumState();
}

class _DiscussionForumState extends State<DiscussionForum> {
  late Future<List<Question>> futureQuestions;

  //List<Question> questions = Question.getFakeQuestionData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.backgrounColor,
        body: FutureBuilder(
            builder:(context, snapshot) {
            if (snapshot.hasData == false) {
              return const CircularProgressIndicator();
            }
            List<Question> questions = (snapshot.data as List<Question>);
            numQuestions = questions.length;
            return ListView.builder(
              itemCount: questions.length + 2,
              itemBuilder: (BuildContext context, int index) {

                // In the first index (row) a search field is printed,
                // In middle indexs (rows) all of the questions are printed
                // In the last index (row) an add question button is returned
                // 
                // Notice: trick of index = index-1 so that in fact there are two cases where index = 0 

                if (index == 0) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 6, 10, 2),
                      child: CupertinoSearchTextField(onChanged: (value) {})
                    );
                }
                index -= 1;
                if (index == questions.length) {
                  return newQuestionButton(context);
                } else {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AnswerPage(questions[index].id)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                      child: Card(
                          child: GFListTile(
                        title: Text(questions[index].title,
                            style: CustomText.textTitle),
                        subTitle: Text(questions[index].description,
                            style: CustomText.textDescription),
                        avatar: Avatar(
                            name: questions[index].user,
                            shape: AvatarShape.circle(16)),
                        icon: Container(
                          height: 30,
                          width: 60,
                          decoration: const BoxDecoration(
                              color: CustomColors.accentColors,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
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
                              Text(" " + questions[index].replies.toString(),
                                  textAlign: TextAlign.center,
                                  style: CustomText.customText),
                            ],
                          ),
                        ),
                      )),
                    ));
                }
              });
            },
            future: futureQuestions,
          ));
}

// Button to make New Question Popup Form appear
Padding newQuestionButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, left: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: 40,
            width: 100,
            child: ElevatedButton(
              child: const Text('New'),
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xff161616), 
                  shadowColor: Colors.white,
                  shape: const StadiumBorder()),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      newQuestionPopup(context),
                );
              },
            )),
      ],
    ),
  );
}

// New Question Popup 
// Used the code from Add Product so that it has same style
Widget newQuestionPopup(BuildContext context) {
    final _qTitle = TextEditingController();
    final _qDescription = TextEditingController();

    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: CustomColors.cardColor,
      contentTextStyle: CustomText.textTitle,
      titleTextStyle: CustomText.textSubTitle,
      title: const Text("New Question"),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _qTitle,
              //initialValue: "",
              decoration: const InputDecoration(
                hintText: 'Enter Question Title',
                labelText: 'Question Title',
              ),
            ),
            TextFormField(
                controller: _qDescription,
                //initialValue: "",
                decoration: const InputDecoration(
                  hintText: 'Enter a description...',
                  labelText: 'Description',
                )
            )
          ],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: const Color(0xff161616), 
              shadowColor: Colors.white,
              shape: const StadiumBorder()),
          onPressed: () {
            postQuestion(_qTitle.text, _qDescription.text);
            Navigator.of(context).pop();
            Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const DiscussionForum())
            );              
          },
          child: const Text('Submit'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey, 
              shadowColor: Colors.white,
              shape: const StadiumBorder()),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
  
  void postQuestion(String qTitle, String qDescription) {

    // This code was initially generated from postman code snippet and then modified to be more general 
    // Also, used this method to get the submitted text:
    // https://stackoverflow.com/questions/51390824/capture-data-from-textformfield-on-flutter-for-http-post-request
    var headers = {
      'Content-Type': 'application/json'
    };

    var request = Request('POST', Uri.parse('https://localhost:7156/api/question'));
    request.body = json.encode({
        "title": qTitle,
        "description": qDescription,
        "user": {
          "username": "admin@gmail.com",
          "password": "admin",
          "userType": "buyer",
          "id": 0
        },
        "time": "2058-05-01T08:34:42-04:00",
        "replies": 0,
        "id": numQuestions
    });

    request.headers.addAll(headers);

    request.send();

    //StreamedResponse response = await request.send();
    //
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
      throw Exception('Failed to get Question Date from Service');
    }

  }

  @override
  void initState() {
    super.initState();
    futureQuestions = getQuestions();
  }

}
