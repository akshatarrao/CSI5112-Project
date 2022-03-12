// ignore_for_file: sized_box_for_whitespace
// It is easier for type check to pass if we just use containers

import 'dart:convert';
import 'dart:math';

import 'package:csi5112_frontend/dataModel/item.dart';
import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/order_history.dart';
import 'package:csi5112_frontend/util/custom_route.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../component/centered_text.dart';
import '../component/theme_data.dart';
import 'customer_home.dart';
import 'package:http/http.dart' as http;

import 'merchant_home.dart';

// The state values are not intended to be final
//ignore: must_be_immutable
class ItemList extends StatefulWidget {
  static const routeName = '/itemlist';
  Map<Item, int> selectedItems;

  double total;
  bool isInvoice;
  User user;
  DateTime invoiceTime;
  String orderId;
  bool? unitTest;
  bool fromOrderHistory;

  // It is unfortunate that we have to input lots of optional data, but nullable check is just impossible to deal with in a clean way
  ItemList(
      {Key? key,
      required this.selectedItems,
      required this.total,
      required this.isInvoice,
      required this.user,
      required this.invoiceTime,
      required this.orderId,
        required this.fromOrderHistory,
      this.unitTest})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemListState();

  /// Easy way to get clean state page with default inputs
  static ItemList getDefaultEmptyPage(User user, unitTest) {
    return ItemList(
      // {} is changing
      //ignore: prefer_const_literals_to_create_immutables
      selectedItems: {},
      total: 0,
      isInvoice: false,
      user: user,
      invoiceTime: DateTime.fromMillisecondsSinceEpoch(0),
      orderId: "",
      fromOrderHistory: false,
      unitTest: unitTest,
    );
  }
}

class _ItemListState extends State<ItemList> {
  //final items = Item.getDefaultFakeData();
  List<Item> items = <Item>[
    Item(
        category: "category",
        name: "nullFlagHackItem",
        description: "description",
        price: 0,
        imageUrl: "imageUrl",
        id: 0)
  ];

  void fetchItems() async {
    if (widget.unitTest == true) {
      items = Item.getDefaultFakeData();
      return;
    }
    List<Item> fetchedItems = [];
    var url = Uri.parse('https://localhost:7156/api/Item?page=0&per_page=20');
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

  @override
  void initState() {
    fetchItems();
    super.initState();
  }

  int perPage = 10;
  bool isReviewStage = false;
  bool isRevisit = false;

  /// Update state to track item and its count
  updateItemCount(Item item, int delta) {
    setState(() {
      if (widget.selectedItems.containsKey(item)) {
        // ?? 0 is only for type check
        widget.selectedItems[item] = (widget.selectedItems[item] ?? 0) + delta;
      } else {
        widget.selectedItems[item] = delta;
      }
    });
  }

  /// getter for the item count
  getItemCount(Item item) {
    return widget.selectedItems.containsKey(item)
        ? widget.selectedItems[item]
        : 0;
  }

  /// update total price
  updateTotal(double delta) {
    setState(() {
      widget.total = widget.total + delta;
    });
  }

  /// reduce state size
  Map<Item, int> getMinSelectedItems() {
    // If a user switch the count from X to 0, we do not want to display them at checkout and invoice
    widget.selectedItems.removeWhere((key, value) => value == 0);
    return widget.selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    // Since fetch is done async and Future is just not woking. I hacked
    // the items to have a default value and use that as a flag to check
    // if the value is retrived to avoid out of range loading error
    if (items.first.name == "nullFlagHackItem") {
      return const CircularProgressIndicator();
    }
    widget.selectedItems = widget.selectedItems;
    widget.user = widget.user;
    final screenWidth = MediaQuery.of(context).size.width;
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
              children: [
                buildHeader(),
                !(isReviewStage || widget.isInvoice)
                    ? CupertinoSearchTextField(
                        onChanged: (value) {},
                      )
                    : Container(),
                Expanded(flex: 7, child: buildItemListGridView(countWidth)),
                Expanded(flex: 1, child: buildFooter())
              ],
            ),
          )),
    );
  }

  /// build footer buttons
  Row buildFooter() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 20,
      ),
      buildTotalText(),
      Container(
        width: 20,
      ),
      // Show buttons at different stage
      isReviewStage
          ? Row(children: [buildGoBackButton(), buildConfirmButton()])
          : widget.isInvoice
              ? Row(
                  children: [buildPrintButton(), widget.fromOrderHistory?buildBackToHistoryPageButton():buildResetButton()],
                )
              : buildReviewButton()
    ]);
  }

  /// build the main list
  GridView buildItemListGridView(int countWidth) {
    return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: countWidth, childAspectRatio: 1.9),
        children:
            // if the user is not actively selecting items, we just display what they already selected
            (isReviewStage || widget.isInvoice
                        ? getMinSelectedItems().keys.toList()
                        : items)
                    .sublist(
                        0,
                        isReviewStage || widget.isInvoice
                            ? getMinSelectedItems().length
                            : min(perPage,items.length))
                    .map<Widget>((item) {
                  return ListItem(
                      item: item,
                      // Passing some of the parent functions/fields so children can read state and notify parent for state update
                      updateTotal: updateTotal,
                      isReviewStage: isReviewStage,
                      isInvoice: widget.isInvoice,
                      getItemCount: getItemCount,
                      updateItemCount: updateItemCount,
                      unitTest: widget.unitTest);
                }).toList() +
                [
                  Center(
                    // This button can only be shown on the first selecting page
                    child: perPage < items.length &&
                            (!isReviewStage && !widget.isInvoice)
                        ? buildLoadButton()
                        // Empty placeholder to prevent itemList change grid
                        : buildLoadButtonPlaceholder(),
                  ),
                ]);
  }

  /// Build header text
  Text buildHeader() {
    return Text(
        widget.isInvoice ? getInvoiceHeaderText() : 'Buy what you want!',
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
              color: CustomColors.textColorPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.none),
        ));
  }

  /// easy way to get a set of header text with formatting
  String getInvoiceHeaderText() =>
      "User: " +
      widget.user.name +
      "\n" +
      "Time: " +
      widget.invoiceTime.toString() +
      "\n" +
      "Order ID: " +
      widget.orderId;

  /// Build print button
  Container buildPrintButton() {
    // Unfortunately Chrome cannot print the webpage as it is because there is no DOM
    // So we have to generate a printable and provide user a button to do it
    return Container(
      padding: const EdgeInsets.all(20),
      width: 160,
      height: 90,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xff161616),
            shadowColor: Colors.white,
            shape: const StadiumBorder()),
        onPressed: () async {
          Map<Item, int> itemList = getMinSelectedItems();
          List<pw.Text> printableItemChildren = [];
          for (MapEntry e in itemList.entries) {
            printableItemChildren
                .add(pw.Text(e.key.name + "  " + e.value.toString()));
          }

          // All printing code from https://pub.dev/packages/printing (package example)
          pw.Document doc = generatePrintableDoc(printableItemChildren);
          await Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async => doc.save()); //
        },
        child: const Text("Print Invoice"),
      ),
    );
  }

  /// build reset/restart button
  Container buildResetButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 160,
      height: 90,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xff161616),
            shadowColor: Colors.white,
            shape: const StadiumBorder()),
        onPressed: () {
          Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => MyHomePage(
              redirected:
                  ItemList.getDefaultEmptyPage(widget.user, widget.unitTest),
              currentUser: widget.user,
            ),
            settings: const RouteSettings(name: ItemList.routeName),
          ));
        },
        child: const Text("Restart"),
      ),
    );
  }

  Container buildBackToHistoryPageButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 160,
      height: 90,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xff161616),
            shadowColor: Colors.white,
            shape: const StadiumBorder()),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.user.userType=="buyer"
              ? MyHomePage(redirected: OrderHistoryPage(isCustomer: true, currentUser: widget.user), currentUser: widget.user)
              : MerchantPage(redirected: OrderHistoryPage(isCustomer: false, currentUser: widget.user), currentUser: widget.user)
            )
          );
        },
        child: const Text("Back to Order History"),
      ),
    );
  }

  /// Generate a printable invoice
  pw.Document generatePrintableDoc(List<pw.Text> printableItemChildren) {
    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
                children: [
                      // We probably can style this, but most printed invoices/receipts do not have design.
                      // It is cheaper and quicker to print with large volume.
                      // That is why this is plain text format
                      pw.Text("Invoice"),
                      pw.Container(height: 20),
                      pw.Text(getInvoiceHeaderText()),
                      pw.Container(height: 20),
                    ] +
                    printableItemChildren +
                    [
                      pw.Container(height: 20),
                      pw.Text("Total: " + widget.total.toStringAsFixed(2))
                    ]),
          ); // Center
        }));
    return doc;
  }

  /// confirm button
  Container buildConfirmButton() {
    return Container(
      width: 160,
      height: 90,
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xff161616),
            shadowColor: Colors.white,
            shape: const StadiumBorder()),
        onPressed: () {
          setState(() {
            widget.isInvoice = true;
            isReviewStage = false;
            widget.invoiceTime = DateTime.now();
            widget.orderId = Faker().guid.guid();
            postOrder();
          });
        },
        child: CenteredText.getCenteredText("Confirm"),
      ),
    );
  }

  // build go back button
  Container buildGoBackButton() {
    return Container(
        padding: const EdgeInsets.all(20),
        width: 160,
        height: 90,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: const Color(0xff161616),
                shadowColor: Colors.white,
                shape: const StadiumBorder()),
            onPressed: () {
              setState(() {
                isRevisit = true;
                isReviewStage = false;
              });
            },
            child: CenteredText.getCenteredText("Go Back")));
  }

  // build review button
  Container buildReviewButton() {
    return Container(
        height: 50,
        width: 120,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: const Color(0xff161616),
              shadowColor: Colors.white,
              shape: const StadiumBorder()),
          onPressed: () {
            // Guard against zero item cart
            if (getMinSelectedItems().isNotEmpty) {
              setState(() {
                isReviewStage = true;
              });
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) => emptyCartErrorPopup(context),
              );
            }
          },
          child: CenteredText.getCenteredText("Review"),
        ));
  }

  /// build total text
  Center buildTotalText() {
    return Center(child: Text("Total: " + widget.total.toStringAsFixed(2)));
  }

  /// build placehoder, not sure if it is still useful, future refactor TODO
  Container buildLoadButtonPlaceholder() {
    return Container(
      height: 50,
      width: 120,
    );
  }

  // build load button
  Container buildLoadButton() {
    return Container(
        height: 50,
        width: 120,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: const Color(0xff161616),
              shadowColor: Colors.white,
              shape: const StadiumBorder()),
          child: CenteredText.getCenteredText('Load more...'),
          onPressed: () {
            setState(() {
              perPage = perPage + 5;
            });
          },
        ));
  }

  void postOrder() {
    // This code was initially generated from postman code snippet and then modified to be more general
    // Also, used this method to get the submitted text:
    // https://stackoverflow.com/questions/51390824/capture-data-from-textformfield-on-flutter-for-http-post-request
    var headers = {'Content-Type': 'application/json'};

    var request =
        Request('POST', Uri.parse('https://localhost:7156/api/OrderHistory'));
    request.body = json.encode({
      "isPaid": true,
      "amount": widget.total.toStringAsFixed(2),
      "user": {
        "username": widget.user.name,
        "password": widget.user.password,
        "userType": widget.user.userType,
        "id": widget.user.id
      },
      "items": createItemData(getMinSelectedItems()),
      "time": DateTime.now().toIso8601String(),
      "id": Random().nextInt(100),
    });
    request.headers.addAll(headers);

    request.send();
  }

  String createItemData(Map<Item, int> selectedItem) {
    String itemSnapshot = "";
    for (var k in selectedItem.keys) {
      itemSnapshot = itemSnapshot +
          "\"" +
          k.name +
          ";" +
          k.category +
          ";" +
          k.description +
          ";" +
          k.imageUrl +
          ";" +
          k.price.toString() +
          "\"" +
          ":" +
          selectedItem[k].toString() +
          ",";
    }
    return "{" + itemSnapshot.substring(0,itemSnapshot.length-1) + "}";
  }
}

// Build card item
// The state values are not intended to be final
//ignore: must_be_immutable
class ListItem extends StatefulWidget {
  ListItem(
      {Key? key,
      required this.item,
      required this.updateTotal,
      required this.isReviewStage,
      required this.updateItemCount,
      required this.getItemCount,
      required this.isInvoice,
      this.unitTest})
      : super(key: key);
  final Item item;
  final bool isReviewStage;
  final bool isInvoice;

  // This is passed down so ListItem can update ItemList's state
  final Function(double) updateTotal;
  final Function(Item, int) updateItemCount;
  final Function(Item) getItemCount;
  bool? unitTest;

  @override
  State<StatefulWidget> createState() => _ListItem();
}

class _ListItem extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return buildCard(context);
  }

  // build the card
  Widget buildCard(BuildContext context) {
    int count = widget.getItemCount(widget.item);
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      width: 480,
      decoration: const BoxDecoration(
          color: CustomColors.cardColor,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 12, top: 16, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: buildCardLeftSide(context),
                  ),
                  Expanded(flex: 5, child: buildCardRightSide(count, context))
                ],
              ))
        ],
      ),
    );
  }

  // build price and counting stuff
  Column buildCardRightSide(int count, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildItemNameText(),
        //buildCategoryText(),
        buildDetailsButton(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildPriceText(),
            Row(
              children: [buildCountEditRow(count)],
            ),
          ],
        )
      ],
    );
  }

  Row buildCountEditRow(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        !widget.isReviewStage && !widget.isInvoice
            ? buildMinusButton(true)
            : buildMinusButton(false),
        buildCountTextLabel(),
        !widget.isReviewStage && !widget.isInvoice
            ? buildPlusIconButton(true)
            : buildPlusIconButton(false)
      ],
    );
  }

  Text buildPriceText() {
    return Text(
      widget.item.price.toStringAsFixed(2),
      textAlign: TextAlign.left,
      style: GoogleFonts.poppins(
          textStyle: const TextStyle(
              color: CustomColors.textColorPrimary, fontSize: 16),
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.none),
      // price format X.XX
    );
  }

  Column buildCardLeftSide(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: widget.unitTest == true
                  ? const Text("placeholder")
                  : Image.network(widget.item.imageUrl, fit: BoxFit.fill)),
        ),
      ],
    );
  }

  Text buildItemNameText() {
    CrossAxisAlignment.start;
    return Text(widget.item.name,
        textAlign: TextAlign.left,
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                color: CustomColors.textColorPrimary, fontSize: 20),
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.none));
  }

  Text buildCategoryText() {
    CrossAxisAlignment.start;
    return Text(widget.item.category,
        textAlign: TextAlign.left,
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                color: CustomColors.textColorSecondary, fontSize: 12),
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none));
  }

  Visibility buildPlusIconButton(bool visible) {
    return Visibility(
        visible: visible,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: IconButton(
            onPressed: () => setState(() {
                  if (visible) {
                    widget.updateTotal(widget.item.price);
                    widget.updateItemCount(widget.item, 1);
                  }
                }),
            icon: Icon(Icons.add_circle,
                color: Colors.pink.shade900, size: 30.0)));
  }

  Widget buildCountTextLabel() {
    return Text(
      widget.getItemCount(widget.item).toString(),
      textAlign: TextAlign.left,
      style: GoogleFonts.poppins(
          textStyle: const TextStyle(
              color: CustomColors.textColorPrimary, fontSize: 16),
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.none),
    );
  }

  Visibility buildMinusButton(bool visible) {
    return Visibility(
        visible: visible,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: IconButton(
            onPressed: () => setState(() {
                  if (visible) {
                    if (widget.getItemCount(widget.item) > 0) {
                      widget.updateTotal(0 - widget.item.price);
                      widget.updateItemCount(widget.item, -1);
                    }
                  }
                }),
            icon: Icon(
              Icons.remove_circle,
              color: Colors.pink.shade900,
              size: 30.0,
            )));
  }

  Widget detailText() {
    return Text(
      widget.item.description,
      textAlign: TextAlign.left,
      style: GoogleFonts.poppins(
          textStyle: const TextStyle(
              color: CustomColors.textColorSecondary, fontSize: 8),
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.none),
    );
  }

  Container buildDetailsButton(BuildContext context) {
    return Container(
        height: 30,
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
                  itemDetail(context, widget.item),
            );
          },
        ));
  }
}

Widget itemDetail(BuildContext context, Item item) {
  return AlertDialog(
    backgroundColor: CustomColors.cardColor,
    contentTextStyle: GoogleFonts.poppins(
        textStyle:
            const TextStyle(color: CustomColors.textColorPrimary, fontSize: 20),
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.none),
    titleTextStyle: GoogleFonts.poppins(
        textStyle:
            const TextStyle(color: CustomColors.textColorPrimary, fontSize: 16),
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.none),
    title: Text(item.category),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(item.name),
        const Text(" "),
        Text(item.description),
        const Text(" "),
        Text(item.price.toStringAsFixed(2))
      ],
    ),
    actions: <Widget>[
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xff161616), shadowColor: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close'),
      ),
    ],
  );
}

Widget emptyCartErrorPopup(BuildContext context) {
  return AlertDialog(
    backgroundColor: CustomColors.cardColor,
    titleTextStyle: GoogleFonts.poppins(
        textStyle:
            const TextStyle(color: CustomColors.textColorPrimary, fontSize: 16),
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.none),
    title: const Text("Please select at least one item"),
    actions: <Widget>[
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
