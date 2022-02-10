import 'dart:math';

import 'package:csi5112_frontend/component/theme_data.dart';
import 'package:csi5112_frontend/dataModel/product_page_model.dart';
import 'package:csi5112_frontend/page/edit_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final f = DateFormat('yMMMd');
    String imageUrl =
        'https://picsum.photos/250?image=' + Random().nextInt(250).toString();

    List<ProductPageModel> products = [
      ProductPageModel("123", "Product 1", "Electronics", 3),
      ProductPageModel("456", "Product 2", "Footwear", 4),
      ProductPageModel("dsf32", "Product 3", "Clothes", 12),
      ProductPageModel("342rfe", "Product 4", "Smartphones", 33),
    ];
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
                  children: products.map((product) {
                    return InkWell(
                        onTap: () {},
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
                                flex: 5,
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
                                              Text(product.product.toString(),
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
                                              Text(product.category,
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 25, right: 30),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(imageUrl),
                                        ),
                                      ),
                                    )
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
                                              top: 5, left: 40),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 40,
                                                  width: 100,
                                                  child: ElevatedButton(
                                                    child: const Text('Edit'),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.blueGrey,
                                                            shadowColor:
                                                                Colors.white),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            itemDetail(context,
                                                                product),
                                                      );
                                                    },
                                                  )),
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

  Widget itemDetail(BuildContext context, ProductPageModel product) {
    return AlertDialog(
      backgroundColor: CustomColors.cardColor,
      contentTextStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
              color: CustomColors.textColorPrimary, fontSize: 20),
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.none),
      titleTextStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
              color: CustomColors.textColorPrimary, fontSize: 16),
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.none),
      title: Text("Edit " + product.product),
      content: EditItem(),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey, shadowColor: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey, shadowColor: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
