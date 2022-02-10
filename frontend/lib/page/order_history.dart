import 'package:csi5112_frontend/component/theme_data.dart';
import 'package:csi5112_frontend/data.dart';
import 'package:csi5112_frontend/dataModal/item.dart';
import 'package:csi5112_frontend/dataModal/user.dart';
import 'package:csi5112_frontend/util/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'home.dart';
import 'item_list.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final f = DateFormat('yMMMd');

    int countWidth = screenWidth >= 1600
        ? 4
        : screenWidth >= 800
            ? 2
            : 1;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xffE5E5E5),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: <Widget>[
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: countWidth, childAspectRatio: 1.9),
                  //gridDelegate:
                  //  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                  children: orders.map((order) {
                    return InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(FadePageRoute(
                            builder: (context) => MyHomePage(
                              redirected: ItemList(
                                invoiceTime: order.orderDate,
                                isInvoice: true,
                                selectedItems: {
                                  Item.getDefaultFakeData()[1]: 2
                                },
                                total: Item.getDefaultFakeData()[1].price * 2,
                                user: User.getRandomUser(),
                                orderId: order.orderId.toString(),
                              ),
                            ),
                            settings:
                                const RouteSettings(name: ItemList.routeName),
                          ));
                        },
                        child: Container(
                            margin: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 8, right: 8),
                            //height: 180,
                            width: 480,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Column(children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 24, left: 40),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Order Number:",
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                          color: CustomColors
                                                              .textColorPrimary,
                                                          fontSize: 12),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration:
                                                          TextDecoration.none)),
                                              Text(
                                                  "#" +
                                                      order.orderId.toString(),
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                          color: CustomColors
                                                              .textColorSecondary,
                                                          fontSize: 26),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      decoration:
                                                          TextDecoration.none)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 16),
                                      height: 28,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.pink.shade900,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(order.ispaid,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Color(0xffffffff),
                                                      fontSize: 8),
                                                  fontWeight: FontWeight.w500,
                                                  decoration:
                                                      TextDecoration.none)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 32, left: 40),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("# of items",
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                          color: CustomColors
                                                              .textColorPrimary,
                                                          fontSize: 12),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration:
                                                          TextDecoration.none)),
                                              Text(order.itemsCount.toString(),
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                          color: CustomColors
                                                              .textColorSecondary,
                                                          fontSize: 18),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      decoration:
                                                          TextDecoration.none)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 32, left: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Total Amount:",
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                          color: CustomColors
                                                              .textColorPrimary,
                                                          fontSize: 12),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration:
                                                          TextDecoration.none)),
                                              Text(
                                                  "\$" +
                                                      order.amount.toString(),
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                          color: CustomColors
                                                              .textColorSecondary,
                                                          fontSize: 18),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      decoration:
                                                          TextDecoration.none)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 32, left: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Order Date:",
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                          color: CustomColors
                                                              .textColorPrimary,
                                                          fontSize: 12),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration:
                                                          TextDecoration.none)),
                                              Text(
                                                  f
                                                      .format(order.orderDate)
                                                      .toString(),
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          const TextStyle(
                                                              color: CustomColors
                                                                  .textColorSecondary,
                                                              fontSize: 18),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      decoration:
                                                          TextDecoration.none)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ])));
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
