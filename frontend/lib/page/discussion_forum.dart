import 'package:flutter/material.dart';
import 'package:csi5112_frontend/dataModal/question.dart';
import 'package:csi5112_frontend/page/answer_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:avatars/avatars.dart';

//import 'package:flutter_initicon/flutter_initicon.dart';

class DiscussionForum extends StatefulWidget {
  const DiscussionForum({Key? key}) : super(key: key);

  @override
  State<DiscussionForum> createState() => _DiscussionForumState();
}

class _DiscussionForumState extends State<DiscussionForum> {
  static List<Question> questions = [
    Question(0, "Question 0", "Description 0", "A", "Feb2020", 0),
    Question(1, "Question 1", "Description 1", "A", "Feb2020", 3),
    Question(2, "Question 2", "Description 2", "UserB", "Feb2020", 3),
    Question(3, "Question 3", "Description 3", "UserA", "Feb2020", 0),
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
              return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AnswerPage(questions[index].id)),
                    );
                  },
                  child: Card(
                    child: GFListTile(
                      titleText: questions[index].title,
                      subTitleText: questions[index].description,
                      avatar: Avatar(
                          name: questions[index].user,
                          shape: AvatarShape.circle(16)),
                      icon: Container(
                        height: 30,
                        width: 60,
                        decoration: const BoxDecoration(
                            color: Color(0xffD9F3E3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.message,
                              size: 14,
                            ),
                            const Padding(
                                padding: EdgeInsets.only(top: 18, left: 0)),
                            Text(" " + questions[index].replies.toString(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Color(0xff40C075), fontSize: 14),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none)),
                          ],
                        ),
                      ),
                    ),
                  ));
            }));
  }
}
