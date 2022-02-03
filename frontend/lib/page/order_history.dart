import 'package:csi5112_frontend/component/app_bar.dart';
import 'package:csi5112_frontend/page/item_list.dart';
import 'package:flutter/material.dart';
import 'package:csi5112_frontend/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final f = new DateFormat('yMMMd');

    int countWidth = screenWidth >= 1200 ? 4 : 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: <Widget>[
          Text('Order History',
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
                  crossAxisCount: countWidth, childAspectRatio: 1.75),
              //gridDelegate:
              //  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
              children: orders.map((order) {
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
                                    const EdgeInsets.only(top: 32, left: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Order Fulfilled By:",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 10),
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none)),
                                    Text(order.merchant,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 22),
                                            fontWeight: FontWeight.w700,
                                            decoration: TextDecoration.none)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 16),
                            height: 28,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Color(0xffD9F3E3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(order.ispaid,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xff40C075),
                                            fontSize: 8),
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
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 32, left: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("# of items",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 10),
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none)),
                                    Text(order.itemsCount.toString(),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 16),
                                            fontWeight: FontWeight.w700,
                                            decoration: TextDecoration.none)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 32, left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Total Amount:",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 10),
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none)),
                                    Text(order.amount.toString(),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 16),
                                            fontWeight: FontWeight.w700,
                                            decoration: TextDecoration.none)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 32, left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Order Date:",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 10),
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none)),
                                    Text(f.format(order.orderDate).toString(),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 16),
                                            fontWeight: FontWeight.w700,
                                            decoration: TextDecoration.none)),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
