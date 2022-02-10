import 'package:csi5112_frontend/page/add_item.dart';
import 'package:csi5112_frontend/page/product_page.dart';
import 'package:csi5112_frontend/page/order_history.dart';
import 'package:flutter/material.dart';

class SellerHome extends StatefulWidget {
  final String? header;

  const SellerHome({Key? key, this.header}) : super(key: key);

  @override
  _SellerHome createState() => _SellerHome();
}

class _SellerHome extends State<SellerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.2, 0.7],
                      colors: [
                        Color(0xff00b2bb),
                        Color(0xff79d296),
                      ],
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * .20,
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Total Sales",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        r"$15,990.00",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 34.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .27,
                  right: 20.0,
                  left: 20.0),
              child: GridView(
                primary: false,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 2.5),
                ),
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProductPage()));
                    },
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(
                                2.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 1.0,
                            ),
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            const EdgeInsets.only(top: 30, left: 25, right: 20),
                        child: Column(
                          children: const [
                            Icon(Icons.inventory, size: 48.0),
                            Text(
                              "Inventory",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OrderHistory()));
                    },
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(
                                2.0,
                                2.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 1.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            const EdgeInsets.only(top: 30, left: 25, right: 20),
                        child: Column(
                          children: const [
                            Icon(Icons.task, size: 48.0),
                            Text(
                              "Orders",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 620, bottom: 8, left: 0, right: 20),
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                onPressed: () => {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AddItem()))
                },
              ),
              alignment: const Alignment(1.0, 1.0),
            )
          ],
        ),
      ),
    );
  }
}
