import 'package:csi5112_frontend/dataModal/inventoryModel.dart';
import 'package:csi5112_frontend/page/edit_item.dart';
import 'package:flutter/material.dart';
import 'package:csi5112_frontend/dataModal/question.dart';
import 'package:csi5112_frontend/page/answer_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:avatars/avatars.dart';

//import 'package:flutter_initicon/flutter_initicon.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  static List<InventoryModel> inventory = [
    InventoryModel("123", "Product 1", "Electronics", "A", 3),
    InventoryModel("456", "Product 2", "Footwear", "A", 4),
    InventoryModel("dsf32", "Product 3", "Clothes", "A", 12),
    InventoryModel("342rfe", "Product 4", "Smartphones", "A", 33),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffE5E5E5),
        body: ListView.builder(
            itemCount: inventory.length + 1,
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
                          builder: (context) => EditItem(inventory[index].id)),
                    );
                  },
                  child: Card(
                    child: GFListTile(
                      titleText: inventory[index].product,
                      subTitleText: inventory[index].category,
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
                              Icons.inventory,
                              size: 14,
                            ),
                            const Padding(
                                padding: EdgeInsets.only(top: 18, left: 0)),
                            Text(" " + inventory[index].stock.toString(),
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
