import 'package:csi5112_frontend/component/theme_data.dart';
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
                        decoration: BoxDecoration(
                            color: Color(0xffD9F3E3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.message,
                              size: 14,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 0)),
                            Text(" " + questions[index].replies.toString(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xff40C075), fontSize: 14),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none)),
                          ],
                        ),
                      ),
                    ),
                  )

                  // child: Container(
                  //     margin: const EdgeInsets.only(
                  //         top: 8, bottom: 8, left: 8, right: 8),
                  //     height: 180,
                  //     width: 580,
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withOpacity(0.25),
                  //           blurRadius: 4,
                  //           spreadRadius: 0,
                  //           offset: const Offset(0, 4),
                  //         ),
                  //       ],
                  //       borderRadius:
                  //           const BorderRadius.all(Radius.circular(25)),
                  //     ),
                  //     child: Column(children: <Widget>[
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Padding(
                  //                 padding:
                  //                     const EdgeInsets.only(top: 24, left: 30),
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     Text(questions[index].user,
                  //                         textAlign: TextAlign.left,
                  //                         style: GoogleFonts.poppins(
                  //                             textStyle: const TextStyle(
                  //                                 color: CustomColors
                  //                                     .textColorPrimary,
                  //                                 fontSize: 10),
                  //                             fontWeight: FontWeight.w500,
                  //                             decoration: TextDecoration.none)),

                  //                     // Text("#" + order.orderId.toString(),
                  //                     //     textAlign: TextAlign.left,
                  //                     //     style: GoogleFonts.poppins(
                  //                     //         textStyle: const TextStyle(
                  //                     //             color: CustomColors
                  //                     //                 .textColorSecondary,
                  //                     //             fontSize: 22),
                  //                     //         fontWeight: FontWeight.w700,
                  //                     //         decoration: TextDecoration.none)),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 1, left: 30),
                  //               child: Flexible(
                  //                 child: Text(questions[index].title,
                  //                     textAlign: TextAlign.left,
                  //                     style: GoogleFonts.poppins(
                  //                         textStyle: const TextStyle(
                  //                             color:
                  //                                 CustomColors.textColorPrimary,
                  //                             fontSize: 14),
                  //                         fontWeight: FontWeight.w500,
                  //                         decoration: TextDecoration.none)),
                  //               )),
                  //         ],
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 1, left: 30),
                  //               child: Flexible(
                  //                 child: Text(
                  //                     questions[index].description +
                  //                         "Description 0Description 0Description 0Description 0Description 0",
                  //                     textAlign: TextAlign.left,
                  //                     style: GoogleFonts.poppins(
                  //                         textStyle: const TextStyle(
                  //                             color:
                  //                                 CustomColors.textColorPrimary,
                  //                             fontSize: 14),
                  //                         fontWeight: FontWeight.w500,
                  //                         decoration: TextDecoration.none)),
                  //               )),
                  //         ],
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Container(
                  //             margin: EdgeInsets.only(top: 40, left: 26),
                  //             height: 30,
                  //             width: 60,
                  //             decoration: BoxDecoration(
                  //                 color: Color(0xffD9F3E3),
                  //                 borderRadius:
                  //                     BorderRadius.all(Radius.circular(40))),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: <Widget>[
                  //                 Icon(
                  //                   Icons.message,
                  //                   size: 20,
                  //                 ),
                  //                 Padding(
                  //                     padding: const EdgeInsets.only(
                  //                         top: 18, left: 4)),
                  //                 Text(questions[index].replies.toString(),
                  //                     textAlign: TextAlign.center,
                  //                     style: GoogleFonts.poppins(
                  //                         textStyle: TextStyle(
                  //                             color: Color(0xff40C075),
                  //                             fontSize: 18),
                  //                         fontWeight: FontWeight.w500,
                  //                         decoration: TextDecoration.none)),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ]))
                  );
              // return Card(
              //   // Card class template: https://api.flutter.dev/flutter/material/Card-class.html
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: <Widget>[
              //       ListTile(
              //         title: TextButton(
              //           child: Text(questions[index].title),
              //           onPressed: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) =>
              //                       AnswerPage(questions[index].id)),
              //             );
              //           },
              //         ),
              //         subtitle: Text(questions[index].description),
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.end,
              //         children: <Widget>[
              //           Text(questions[index].user),
              //           const SizedBox(width: 10),
              //           Text(questions[index].date)
              //         ],
              //       )
              //     ],
              //   ),
              // );
            }));
  }
}
