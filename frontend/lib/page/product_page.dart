import 'dart:convert';
import 'dart:math';

import 'package:csi5112_frontend/component/theme_data.dart';
import 'package:csi5112_frontend/dataModel/item.dart';
import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/merchant_home.dart';
import 'package:csi5112_frontend/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// The state values are not intended to be final
//ignore: must_be_immutable
class ProductPage extends StatefulWidget {
  static const routeName = '/product-setup';
  User currentUser;

  ProductPage({Key? key, required this.currentUser}) : super(key: key);

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
        imageUrl: 'https://i.picsum.photos/id/157/250/250.jpg?hmac=HXuLMXMrCQQDtUchnRYfnQELipdHzy9Dnoq3cNvs7l8')
  ];
  int perPage = 10;
  void fetchItems(_perpage) async {
    List<Item> fetchedItems = [];

    var url = Uri.parse(
        Constants.baseApi+'/Item?page=0&per_page=' "$_perpage");
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

  void deleteItem(context, id) async {
    var url = Uri.parse(Constants.baseApi+'/Item/' "$id");
    var response = await http.delete(url);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                MerchantPage(currentUser: widget.currentUser)));
    if (response.statusCode == 200) {
      // var itemsJson = json.decode(response.body);
      // for (var item in itemsJson) {
      //   fetchedItems.add(Item.fromJson(item));
      // }

    }
  }

  void addItem(context, name, description, category, price, imageUrl) async {
    var headers = {'Content-Type': 'application/json'};
    var rng = Random();
    var rand = rng.nextInt(20) + 40;
    var request =
        http.Request('POST', Uri.parse(Constants.baseApi+'/Item/'));

    request.body = json.encode({
      "name": name,
      "category": category,
      "description": description,
      "imageUrl": imageUrl,
      "price": price,
      "id": rand
    });
    request.headers.addAll(headers);

    request.send();
  }

  void updateItem(
      context, id, name, description, category, price, imageUrl) async {
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request(
        'PUT', Uri.parse(Constants.baseApi +'/Item/' + id.toString()));

    request.body = json.encode({
      "name": name,
      "category": category,
      "description": description,
      "imageUrl": imageUrl,
      "price": price,
      "id": id
    });
    request.headers.addAll(headers);

    request.send();
  }

  @override
  void initState() {
    fetchItems(perPage);
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
          [buildAddButton(context), buildLoadMoreButton(context)],
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

  Padding buildLoadMoreButton(BuildContext context) {
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
              child: const Text('Load More'),
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xff161616),
                  shadowColor: Colors.white,
                  shape: const StadiumBorder()),
              onPressed: () {
                fetchItems(perPage + 6);
                setState(() {
                  perPage = perPage + 6;
                });
              },
            ),
          ),
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
                onPressed: () =>
                    {deleteItem(context, product.id)} //deleteItem()
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
    String name = product?.name ?? "";
    double price = product?.price ?? 0;
    String category = product?.category ?? "";
    String description = product?.description ?? "";
    String imageUrl = product?.imageUrl ?? "";
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
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            // controller: _name,
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
            //controller: _price,
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
              //controller: _description,
              initialValue: description,
              decoration: const InputDecoration(
                hintText: 'Enter a description...',
                labelText: 'Description',
              ),
              onChanged: (value) {
                description = value;
              }),
          TextFormField(
            //controller: _category,
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
            //controller: _imageUrl,
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
      ),
      //buildEditPopup(product),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: const Color(0xff161616),
              shadowColor: Colors.white,
              shape: const StadiumBorder()),
          onPressed: () {
            if (product == null) {
              addItem(context, name, description, category, price, imageUrl);
            } else {
              updateItem(context, product.id, name, description, category,
                  price, imageUrl);
            }

            Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MerchantPage(currentUser: widget.currentUser)));
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
