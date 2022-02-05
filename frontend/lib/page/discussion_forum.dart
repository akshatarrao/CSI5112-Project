import 'package:flutter/material.dart';
import '../dataModal/question.dart';
import 'package:csi5112_frontend/data.dart';

import 'package:csi5112_frontend/component/app_bar.dart';
import 'package:csi5112_frontend/page/item_list.dart';
import 'package:flutter/material.dart';
import 'package:csi5112_frontend/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DiscussionForum extends StatefulWidget {
  const DiscussionForum({Key? key}) : super(key: key);

  @override
  State<DiscussionForum> createState() => _DiscussionForumState();
}

class _DiscussionForumState extends State<DiscussionForum> {
  static List<Question> questions = [
    Question(
        "Question 1",
        "Description 1 Description 1Description 1Description 1Description 1Description 1",
        "UserA",
        "Feb2020",
        2),
    Question("Question 2", "Description 2", "UserB", "Feb2020", 7),
    Question("Question 3", "Description 3", "UserA", "Feb2020", 0),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final f = new DateFormat('yMMMd');

    int countWidth = screenWidth >= 1200 ? 4 : 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: <Widget>[
          Text('Discussions',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Color(0xff525151),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.none),
              )),
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: countWidth, childAspectRatio: 1.9),
              //gridDelegate:
              //  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
              children: questions.map((question) {
                return Container(
                    margin: const EdgeInsets.only(
                        top: 8, bottom: 8, left: 8, right: 8),
                    //height: 180,
                    width: 480,
                    decoration: BoxDecoration(
                        color: Color(0xff1E273C),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 24, left: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(question.user,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 10),
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none)),
                                    Text(question.title,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 18),
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 16),
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Color(0xffD9F3E3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.message,
                                  size: 20,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 18, left: 4)),
                                Text(question.replies.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xff40C075),
                                            fontSize: 18),
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.none)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 18, left: 40),
                              child: Flexible(
                                  child: Text(
                                      "Long text  hdnsfjkhsdjkfbdjshnvjhdsajvdsivbsdib 123456789",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xff40C075),
                                              fontSize: 18),
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.none)))),
                        ],
                      ),
                    ]));
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
