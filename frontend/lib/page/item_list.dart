// ignore_for_file: sized_box_for_whitespace
// It is easier for type check to pass if we just use containers

import 'package:csi5112_frontend/dataModal/item.dart';
import 'package:csi5112_frontend/dataModal/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../component/app_bar.dart';
import '../component/centered_text.dart';
import '../component/divider.dart';

class ItemList extends StatefulWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final items = Item.getDefaultFakeData();

  // states
  Map<Item, int> selectedItems = {};
  int perPage = 10;
  double total = 0;
  bool isReviewStage = false;
  bool isRevisit = false;
  bool isInvoice = false;
  User user = User.getRandomUser();
  DateTime? invoiceTime;

  updateTotal(double delta) {
    setState(() {
      total = total + delta;
    });
  }

  updateMap(Item item, int count) {
    setState(() {
      selectedItems[item] = count;
    });
  }

  Map<Item, int> getMinSelectedItems() {
    // If a user switch the count from X to 0, we do not want to count them in the items
    selectedItems.removeWhere((key, value) => value == 0);
    return selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int countWidth = screenWidth >= 1600
        ? 4
        : screenWidth >= 800
            ? 2
            : 1;
    return Scaffold(
        appBar: DefaultAppBar.getAppBar(context),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              isInvoice ? buildInvoiceHeader() : Container(width: 0, height: 0),
              Text('Checkout what you want!',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Color(0xff525151),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.none),
                  )),
              Expanded(
                  flex: 7,
                  child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: countWidth, childAspectRatio: 1.9),
                      children:
                          // if the user is not actively selecting items, we just display what they already selected
                          (isReviewStage || isInvoice
                                  ? getMinSelectedItems().keys.toList()
                                  : items)
                              .sublist(
                                  0,
                                  isReviewStage || isInvoice
                                      ? getMinSelectedItems().length
                                      : perPage)
                              .map<Widget>((item) {
                        return ListItem(
                            item: item,
                            // Passing some of the parent functions so children can notify parent for state update
                            updateTotal: updateTotal,
                            isReviewStage: isReviewStage,
                            updateMap: updateMap,
                            // carry-over or restore already selected count
                            count: isReviewStage || isInvoice
                                ? (selectedItems[item] ?? 0)
                                : (isRevisit ? (selectedItems[item] ?? 0) : 0),
                            isInvoice: isInvoice);
                      }).toList())),
              Expanded(
                  flex: 1,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          // This button can only be shown on the first selecting page
                          child: perPage < items.length &&
                                  (!isReviewStage && !isInvoice)
                              ? buildLoadButton()
                              // Empty placeholder to prevent itemList change grid
                              : buildLoadButtonPlaceholder(),
                        ),

                        Container(
                            padding: const EdgeInsets.all(50),
                            child: buildTotalText()),
                        // Show buttons at different stage
                        isReviewStage
                            ? Row(children: [
                                buildGoBackButton(),
                                buildConfirmButton()
                              ])
                            : isInvoice
                                ? buildPrintButton()
                                : buildReviewButton()
                      ]))
            ],
          ),
        ));
  }

  // Center(
  //         child: Column(
  //             // Set grid alignment
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: header +
  //                 [
  //                   Expanded(
  //                       // most useful component, take 5 unit space
  //                       flex: 5,
  //                       child: buildItemList()),
  //                   Expanded(
  //                       flex: 2,
  //                       // Only display the load button if there are more to load
  //                       child: Row(
  //                         children: [
  //                           Expanded(child: Container(), flex: 2),
  //                           Expanded(
  //                               flex: 4,
  //                               child: Center(
  //                                 // This button can only be shown on the first selecting page
  //                                 child: perPage < items.length &&
  //                                         (!isReviewStage && !isInvoice)
  //                                     ? buildLoadButton()
  //                                     // Empty placeholder to prevent itemList change grid
  //                                     : buildLoadButtonPlaceholder(),
  //                               )),
  //                           Expanded(
  //                               flex: 2,
  //                               child: Column(
  //                                 children: [
  //                                   Container(
  //                                       padding: const EdgeInsets.all(50),
  //                                       child: buildTotalText()),
  //                                   // Show buttons at different stage
  //                                   isReviewStage
  //                                       ? Row(children: [
  //                                           buildGoBackButton(),
  //                                           buildConfirmButton()
  //                                         ])
  //                                       : isInvoice
  //                                           ? buildPrintButton()
  //                                           : buildReviewButton()
  //                                 ],
  //                               ))
  //                         ],
  //                       )),
  //                 ])),

  Row buildInvoiceHeader() {
    return Row(children: [
      Container(
          padding: const EdgeInsets.all(20),
          child: Text(
            getInvoiceHeaderText(),
            textAlign: TextAlign.left,
          ))
    ]);
  }

  String getInvoiceHeaderText() =>
      "User: " + user.name + "   " + "Time: " + invoiceTime.toString();

  Container buildPrintButton() {
    // Unfortunately Chrome cannot print the webpage as it is because there is no DOM
    // So we have to generate a printable and provide user a button to do it
    return Container(
      width: 120,
      height: 50,
      child: ElevatedButton(
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
        child: const Text("Print"),
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
                      pw.Text(getInvoiceHeaderText()),
                    ] +
                    printableItemChildren +
                    [pw.Text("Total: " + total.toStringAsFixed(2))]),
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
        onPressed: () {
          setState(() {
            isInvoice = true;
            isReviewStage = false;
            invoiceTime = DateTime.now();
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
    return Center(
        child:
            CenteredText.getCenteredText("Total: " + total.toStringAsFixed(2)));
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
          child: CenteredText.getCenteredText('Load more...'),
          onPressed: () {
            setState(() {
              perPage = perPage + 5;
            });
          },
        ));
  }

  ListView buildItemList() {
    // The logic here is kinda complex because we have to account for different stage and revisit
    return ListView.separated(
      itemCount:
          // if the user is not actively selecting items, we just display what they already selected
          isReviewStage || isInvoice ? getMinSelectedItems().length : perPage,
      separatorBuilder: (BuildContext context, int index) =>
          DefaultDivider.getDefaultDivider(context),
      itemBuilder: (BuildContext context, int index) {
        selectedItems = getMinSelectedItems();
        return ListItem(
            // if the user is not actively selecting items, we just display what they already selected
            item: isReviewStage || isInvoice
                ? selectedItems.keys.elementAt(index)
                : items[index],
            // Passing some of the parent functions so children can notify parent for state update
            updateTotal: updateTotal,
            isReviewStage: isReviewStage,
            updateMap: updateMap,
            // carry-over or restore already selected count
            count: isReviewStage || isInvoice
                ? (selectedItems[selectedItems.keys.elementAt(index)] ?? 0)
                : (isRevisit ? (selectedItems[items[index]] ?? 0) : 0),
            isInvoice: isInvoice);
      },
    );
  }
}

class ListItem extends StatefulWidget {
  const ListItem(
      {Key? key,
      required this.item,
      required this.updateTotal,
      required this.isReviewStage,
      required this.updateMap,
      required this.count,
      required this.isInvoice})
      : super(key: key);
  final Item item;
  final bool isReviewStage;
  final bool isInvoice;
  final int count;

  // This is passed down so ListItem can update ItemList's state
  final Function(double) updateTotal;
  final Function(Item, int) updateMap;

  @override
  State<StatefulWidget> createState() => _ListItem();
}

class _ListItem extends State<ListItem> {
  int count = 0;

  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // This whole text field is not working as expected. Lots of hacks and random code made it work
    // It is magical, do not change unless you know what you are doing
    if (widget.count != 0) {
      controller.text = widget.count.toString();
    }
    //   return Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: buildRow(context),
    //       ));
    // }
    return buildCard(context);
  }

  Widget buildCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      width: 480,
      decoration: BoxDecoration(
          color: Color(0xff1E273C),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(widget.item.category,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xffffffff), fontSize: 10),
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none)),
                        Container(
                          height: 14,
                          width: 14,
                        ),
                        Text(widget.item.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xffffffff), fontSize: 16),
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none)),
                        Container(
                          height: 20,
                          width: 14,
                        ),
                        buildDetailsButton(context),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.item.price.toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xffffffff), fontSize: 16),
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none),
                            // price format X.XX
                          ),
                          Container(
                            height: 14,
                            width: 14,
                          ),
                          buildCountTextField(),
                          Container(
                            height: 14,
                            width: 14,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: count != 0 &&
                                          !widget.isReviewStage &&
                                          !widget.isInvoice
                                      ? buildMinusButton()
                                      : Container(
                                          width: 6,
                                        )),
                              Expanded(
                                  child:
                                      !widget.isReviewStage && !widget.isInvoice
                                          ? buildPlusIconButton()
                                          : Container())
                            ],
                          )
                        ],
                      ))
                ],
              ))
        ],
      ),
    );
  }

  List<Widget> buildRow(BuildContext context) {
    return [
      // Default grid side to 4
      Expanded(flex: 4, child: CenteredText.getCenteredText(widget.item.name)),
      Expanded(
          flex: 4, child: CenteredText.getCenteredText(widget.item.category)),
      Expanded(
        flex: 4,
        child: buildDetailsButton(context),
      ),
      Expanded(flex: 4, child: CenteredText.getCenteredText(
          // price format X.XX
          widget.item.price.toStringAsFixed(2))),
      // The add + remove + input together take 4 unit space
      Expanded(
          flex: 1,
          // Only display if the count is larger than 0
          child: count != 0 && !widget.isReviewStage && !widget.isInvoice
              ? buildMinusButton()
              : Container()),
      Expanded(flex: 2, child: buildCountTextField()),
      Expanded(
          flex: 1,
          child: !widget.isReviewStage && !widget.isInvoice
              ? buildPlusIconButton()
              : Container())
    ];
  }

  IconButton buildPlusIconButton() {
    return IconButton(
        onPressed: () => setState(() {
              count++;
              widget.updateTotal(widget.item.price);
              // Ideally we want to map count value automatically to the field. However, due to
              // in-place count value update. The trigger is messed up so we have to manually set them everywhere
              controller.text = count.toString();
              widget.updateMap(widget.item, count);
            }),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ));
  }

  Widget buildCountTextField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      enabled: !widget.isReviewStage,
      decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.white)),
          focusedBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.white)),
          hintText: 'Enter a number'),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      onChanged: (String value) async {
        if (value.isNotEmpty) {
          // This code would be much easier and maintainable if we just get rid of the +/- buttons
          // Possible future refactor
          widget.updateTotal((int.parse(value) - count) * widget.item.price);
          count = int.parse(value);
          controller.text = count.toString();
          widget.updateMap(widget.item, count);
        } else {
          widget.updateTotal((0 - count) * widget.item.price);
          count = 0;
          controller.text = count.toString();
          widget.updateMap(widget.item, count);
        }
        // hack, no idea why it works, but it make sure the cursor does not jump
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
      },
      // Only allow number input for user experience
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }

  IconButton buildMinusButton() {
    return IconButton(
        onPressed: () => setState(() {
              count--;
              widget.updateTotal(0 - widget.item.price);
              controller.text = count.toString();
              widget.updateMap(widget.item, count);
            }),
        icon: const Icon(
          Icons.remove,
          color: Colors.white,
        ));
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
    title: Text(item.name),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(item.category),
        const Text(" "),
        Text(item.description),
        const Text(" "),
        Text(item.price.toStringAsFixed(2))
      ],
    ),
    actions: <Widget>[
      ElevatedButton(
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
    title: const Text("Please select at least one item"),
    actions: <Widget>[
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close'),
      ),
    ],
  );
}
