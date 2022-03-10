import 'package:avatars/avatars.dart';
import 'package:csi5112_frontend/dataModel/question.dart';
import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/answer_page.dart';
import 'package:csi5112_frontend/page/customer_home.dart';
import 'package:csi5112_frontend/page/merchant_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:convert';
import 'package:http/http.dart';

import '../component/theme_data.dart';

int numQuestions = 0;

// ignore: must_be_immutable
class DiscussionForum extends StatefulWidget {
  bool isCustomer;
  bool unitTest;
  String searchPhrase;
  User currentUser;

  DiscussionForum({Key? key, required this.isCustomer, this.searchPhrase = "", this.unitTest = false, required this.currentUser}) : super(key: key);

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
                  return searchRow();
                }
                index -= 1;
                if (index == questions.length) {
                  return newQuestionButton(context);
                } else {
                  return InkWell(
                    key: const Key('QuestionCard'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AnswerPage(questions[index].id,widget.currentUser, unitTest: widget.unitTest)),
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

// Making the Search row - submit by pressing <enter>
Widget searchRow() {
  // Help from: https://api.flutter.dev/flutter/cupertino/CupertinoSearchTextField-class.html
  // If you want to overwrite the default text 

  TextEditingController _searchController;
  if (widget.searchPhrase == "") {
    _searchController  = TextEditingController();  
  } else {
    _searchController  = TextEditingController(text: widget.searchPhrase);
  }

  return Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 2),
          child: CupertinoSearchTextField(
            controller: _searchController,
            onSubmitted: (String searchValue) {
              bool isCustomer = widget.isCustomer;
              //Navigator.of(context).pop();
              Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => isCustomer
                            ? MyHomePage(currentUser:widget.currentUser,redirected: DiscussionForum(isCustomer: isCustomer, searchPhrase: searchValue, currentUser:widget.currentUser))
                            : MerchantPage(currentUser:widget.currentUser,redirected: DiscussionForum(isCustomer: isCustomer, searchPhrase: searchValue,currentUser:widget.currentUser))
                          )
              );
          })
        );
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
                      newQuestionPopup(context, widget.isCustomer),
                );
              },
            )),
      ],
    ),
  );
}

// New Question Popup 
// Used the code from Add Product so that it has same style
Widget newQuestionPopup(BuildContext context, isCustomer) {
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
                        MaterialPageRoute(builder: (context) => isCustomer
                          ? MyHomePage(redirected: DiscussionForum(isCustomer: isCustomer,currentUser:widget.currentUser),currentUser:widget.currentUser)
                          : MerchantPage(redirected: DiscussionForum(isCustomer: isCustomer,currentUser:widget.currentUser),currentUser:widget.currentUser)
                        )
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
          key: const Key('CloseForm'),
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
    User user = widget.currentUser;
    request.body = json.encode({
        "title": qTitle,
        "description": qDescription,
        "user": {
          "username": user.name,
          "password": user.password,
          "userType": user.userType,
          "id": user.id
        },
        "time": DateTime.now().toIso8601String(),
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

  Future<List<Question>> getQuestions(String searchPhrase) async {
    final Response response;
    if (widget.unitTest == true) {
      return Question.getFakeQuestionData();
    } else if (searchPhrase == "") {
      response = await get(Uri.parse('https://localhost:7156/api/question'));
    } else {
      response = await get(Uri.parse('https://localhost:7156/api/question/__search__/' + searchPhrase));
    }
    
    
    if(response.statusCode == 200) {
      return Question.fromListJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get Question Date from Service');
    }

  }

  @override
  void initState() {
    super.initState();
    futureQuestions = getQuestions(widget.searchPhrase);
  }

}
