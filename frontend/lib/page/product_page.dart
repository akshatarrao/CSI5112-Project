import 'dart:convert';

import 'package:csi5112_frontend/component/theme_data.dart';
import 'package:csi5112_frontend/dataModel/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// The state values are not intended to be final
//ignore: must_be_immutable
class ProductPage extends StatefulWidget {
  static const routeName = '/product-setup';

  ProductPage({Key? key}) : super(key: key);
  List<Item> itemss = <Item>[
    Item(
        category: "category",
        name: "nullFlagHackItem",
        description: "description",
        price: 0,
        imageUrl: "imageUrl",
        id: 0)
  ];

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Item> items = <Item>[
    Item(
        category: "category",
        name: "nullFlagHackItem",
        description: "description",
        price: 0,
        id: 0,
        imageUrl: "imageUrl")
  ];

  void fetchItems() async {
    List<Item> fetchedItems = [];

    var url = Uri.parse('https://localhost:7156/api/Item?page=0&per_page=10');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var itemsJson = json.decode(response.body);
      for (var item in itemsJson) {
        fetchedItems.add(Item.fromJson(item));
      }
      setState(() {
        items = fetchedItems;
      });
    }
  }

  void deleteItem(id) async {
    var url = Uri.parse('https://localhost:7156/api/Item/' "$id");
    var response = await http.delete(url);
    if (response.statusCode == 200) {
      // var itemsJson = json.decode(response.body);
      // for (var item in itemsJson) {
      //   fetchedItems.add(Item.fromJson(item));
      // }
      setState(() {});
    }
  }

  @override
  void initState() {
    fetchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    List<Item> products = items;

    int countWidth = screenWidth >= 1600
        ? 4
        : screenWidth >= 800
            ? 2
            : 1;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xffE5E5E5),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: <Widget>[
              Expanded(
                child: buildGrid(countWidth, products, context),
              )
            ],
          ),
        ),
      ),
    );
  }

  GridView buildGrid(
      int countWidth, List<Item> products, BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: countWidth, childAspectRatio: 1.9),
      children: items.map<Widget>((product) {
            return buildCard(product, context);
          }).toList() +
          [buildAddButton(context)],
    );
  }

  Container buildCard(Item product, BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
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
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(children: <Widget>[
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildProductInfo(product),
                buildProductImage(product.imageUrl)
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildEditButton(context, product),
                buildDeleteButton(context, product)
              ],
            ),
          ),
        ]));
  }

  Padding buildEditButton(BuildContext context, Item product) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 40,
              width: 80,
              child: ElevatedButton(
                child: const Text('Details'),
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xff161616),
                    shadowColor: Colors.white,
                    shape: const StadiumBorder()),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        itemDetail(context, product),
                  );
                },
              )),
        ],
      ),
    );
  }

  Padding buildAddButton(BuildContext context) {
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
              child: const Text('Add'),
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xff161616),
                  shadowColor: Colors.white,
                  shape: const StadiumBorder()),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => itemDetail(context, null),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding buildDeleteButton(BuildContext context, Item product) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            width: 80,
            child: ElevatedButton(
                child: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shadowColor: Colors.white,
                    shape: const StadiumBorder()),
                onPressed: () => {deleteItem(product.id)} //deleteItem()
                ),
          ),
        ],
      ),
    );
  }

  Container buildProductImage(String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(top: 25, right: 30),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(imageUrl),
        ),
      ),
    );
  }

  Padding buildProductInfo(Item product) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(product.name.toString(),
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: CustomColors.textColorSecondary, fontSize: 16),
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none)),
          ),
          Text(product.category,
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: CustomColors.textColorPrimary, fontSize: 12),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none)),
        ],
      ),
    );
  }

  Widget itemDetail(BuildContext context, Item? product) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
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
      // Unnecessary logic to make lint pass
      title:
          product != null ? Text("Edit " + (product.name)) : const Text("Add"),
      content: buildEditPopup(product),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: const Color(0xff161616),
              shadowColor: Colors.white,
              shape: const StadiumBorder()),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
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

  Column buildEditPopup(Item? item) {
    String name = item?.name ?? "";
    double price = item?.price ?? 0;
    String category = item?.category ?? "";
    String description = item?.description ?? "";
    String imageUrl = item?.imageUrl ?? "";

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          initialValue: name,
          decoration: const InputDecoration(
            hintText: "Enter Item Name",
            labelText: 'Item Name',
          ),
          onChanged: (value) {
            setState(() {
              name = value;
            });
          },
        ),
        TextFormField(
          initialValue: price.toStringAsFixed(2),
          decoration: const InputDecoration(
            hintText: 'Enter Item Price...',
            labelText: 'Price',
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
          ],
          onChanged: (value) {
            setState(() {
              price = double.parse(value);
            });
          },
        ),
        TextFormField(
            initialValue: description,
            decoration: const InputDecoration(
              hintText: 'Enter a description...',
              labelText: 'Description',
            ),
            onChanged: (value) {
              description = value;
            }),
        TextFormField(
          initialValue: category,
          decoration: const InputDecoration(
            hintText: 'Enter Category...',
            labelText: 'Category',
          ),
          onChanged: (value) {
            setState(() {
              category = value;
            });
          },
        ),
        TextFormField(
          initialValue: imageUrl,
          decoration: const InputDecoration(
            hintText: 'Enter image URL...',
            labelText: 'Image URL',
          ),
          onChanged: (value) {
            setState(() {
              imageUrl = value;
            });
          },
        ),
      ],
    );
  }
}
