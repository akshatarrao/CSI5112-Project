// ignore_for_file: sized_box_for_whitespace
// It is easier for type check to pass if we just use containers

import 'dart:math';

import 'package:csi5112_frontend/dataModal/item.dart';
import 'package:csi5112_frontend/dataModal/user.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../component/centered_text.dart';
import '../component/theme_data.dart';

class ItemList extends StatefulWidget {
  static const routeName = '/itemlist';
  Map<Item, int> selectedItems;

  double total;
  bool isInvoice;
  User user;
  DateTime invoiceTime;
  String orderId;

  // It is unfortunate that we have to input lots of optional data, but nullable check is just impossible to deal with in a clean way
  ItemList(
      {Key? key,
      required this.selectedItems,
      required this.total,
      required this.isInvoice,
      required this.user,
      required this.invoiceTime,
      required this.orderId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemListState();

  static ItemList getDefaultEmptyPage() {
    return ItemList(
      selectedItems: {},
      total: 0,
      isInvoice: false,
      user: User.getRandomUser(),
      invoiceTime: DateTime.fromMillisecondsSinceEpoch(0),
      orderId: "",
    );
  }
}

class _ItemListState extends State<ItemList> {
  final items = Item.getDefaultFakeData();
  // states

  int perPage = 10;
  bool isReviewStage = false;
  bool isRevisit = false;

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

  getItemCount(Item item) {
    return widget.selectedItems.containsKey(item)
        ? widget.selectedItems[item]
        : 0;
  }

  updateTotal(double delta) {
    setState(() {
      widget.total = widget.total + delta;
    });
  }

  Map<Item, int> getMinSelectedItems() {
    // If a user switch the count from X to 0, we do not want to display them at checkout and invoice
    widget.selectedItems.removeWhere((key, value) => value == 0);
    return widget.selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    widget.selectedItems = widget.selectedItems;
    widget.user = widget.user;
    final screenWidth = MediaQuery.of(context).size.width;
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
              children: [
                buildHeader(),
                Expanded(flex: 7, child: buildItemListGridView(countWidth)),
                Expanded(flex: 1, child: buildFooter())
              ],
            ),
          )),
    );
  }

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
              ? buildPrintButton()
              : buildReviewButton()
    ]);
  }

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
                            : perPage)
                    .map<Widget>((item) {
                  return ListItem(
                      item: item,
                      // Passing some of the parent functions/fields so children can read state and notify parent for state update
                      updateTotal: updateTotal,
                      isReviewStage: isReviewStage,
                      isInvoice: widget.isInvoice,
                      getItemCount: getItemCount,
                      updateItemCount: updateItemCount);
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

  String getInvoiceHeaderText() =>
      "User: " +
      widget.user.name +
      "\n" +
      "Time: " +
      widget.invoiceTime.toString() +
      "\n" +
      "Order ID: " +
      widget.orderId;

  Container buildPrintButton() {
    // Unfortunately Chrome cannot print the webpage as it is because there is no DOM
    // So we have to generate a printable and provide user a button to do it
    return Container(
      width: 120,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey, shadowColor: Colors.white),
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

  Container buildConfirmButton() {
    return Container(
      width: 160,
      height: 90,
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey, shadowColor: Colors.white),
        onPressed: () {
          setState(() {
            widget.isInvoice = true;
            isReviewStage = false;
            widget.invoiceTime = DateTime.now();
            widget.orderId = Faker().guid.guid();
          });
        },
        child: CenteredText.getCenteredText("Confirm"),
      ),
    );
  }

  Container buildGoBackButton() {
    return Container(
        padding: const EdgeInsets.all(20),
        width: 160,
        height: 90,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey, shadowColor: Colors.white),
            onPressed: () {
              setState(() {
                isRevisit = true;
                isReviewStage = false;
              });
            },
            child: CenteredText.getCenteredText("Go Back")));
  }

  Container buildReviewButton() {
    return Container(
        height: 50,
        width: 120,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey, shadowColor: Colors.white),
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

  Center buildTotalText() {
    return Center(child: Text("Total: " + widget.total.toStringAsFixed(2)));
  }

  Container buildLoadButtonPlaceholder() {
    return Container(
      height: 50,
      width: 120,
    );
  }

  Container buildLoadButton() {
    return Container(
        height: 50,
        width: 120,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey, shadowColor: Colors.white),
          child: CenteredText.getCenteredText('Load more...'),
          onPressed: () {
            setState(() {
              perPage = perPage + 5;
            });
          },
        ));
  }
}

class ListItem extends StatefulWidget {
  ListItem(
      {Key? key,
      required this.item,
      required this.updateTotal,
      required this.isReviewStage,
      required this.updateItemCount,
      required this.getItemCount,
      required this.isInvoice})
      : super(key: key);
  final Item item;
  final bool isReviewStage;
  final bool isInvoice;

  // This is passed down so ListItem can update ItemList's state
  final Function(double) updateTotal;
  final Function(Item, int) updateItemCount;
  final Function(Item) getItemCount;

  @override
  State<StatefulWidget> createState() => _ListItem();
}

class _ListItem extends State<ListItem> {
  String imageUrl =
      'https://picsum.photos/250?image=' + Random().nextInt(250).toString();

  @override
  Widget build(BuildContext context) {
    return buildCard(context);
  }

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

  Column buildCardRightSide(int count, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildItemNameText(),
        buildCategoryText(),
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
              child: Image.network(imageUrl, fit: BoxFit.fill)),
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
                color: CustomColors.textColorSecondary, fontSize: 8),
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
                    widget.updateTotal(0 - widget.item.price);
                    widget.updateItemCount(widget.item, -1);
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
        height: 40,
        width: 100,
        child: ElevatedButton(
          child: const Text('Details'),
          style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey, shadowColor: Colors.white),
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
            primary: Colors.blueGrey, shadowColor: Colors.white),
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
