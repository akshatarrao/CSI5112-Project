import 'package:csi5112_frontend/dataModal/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  Map<Item, int> selectedItems = {};
  int perPage = 10;
  double total = 0;
  bool isReviewStage = false;

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
    selectedItems.removeWhere((key, value) => value == 0);
    return selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar.getAppBar(),
      body: Center(
          child: Column(
              // Set grid alignment
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Expanded(
                // most useful component, take 5 unit space
                flex: 5,
                child: ListView.separated(
                  itemCount:
                      isReviewStage ? getMinSelectedItems().length : perPage,
                  separatorBuilder: (BuildContext context, int index) =>
                      DefaultDivider.getDefaultDivider(context),
                  itemBuilder: (BuildContext context, int index) {
                    selectedItems = getMinSelectedItems();
                    return ListItem(
                        item: isReviewStage
                            ? selectedItems.keys.elementAt(index)
                            : items[index],
                        updateTotal: updateTotal,
                        isReviewStage: isReviewStage,
                        updateMap: updateMap,
                        count: isReviewStage
                            ? selectedItems[
                                    selectedItems.keys.elementAt(index)] ??
                                0
                            : 0);
                  },
                )),
            Expanded(
                flex: 2,
                // Only display the load button if there are more to load
                child: Row(
                  children: [
                    Center(
                      child: perPage < items.length && !isReviewStage
                          ? Container(
                              padding:
                                  const EdgeInsets.fromLTRB(400, 50, 200, 50),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    maximumSize: Size(120, 50)),
                                child: CenteredText.getCenteredText(
                                    'Load more...'),
                                onPressed: () {
                                  setState(() {
                                    perPage = perPage + 5;
                                  });
                                },
                              ))
                          // Empty placeholder to prevent itemList change grid
                          : Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.fromLTRB(520, 50, 200, 50),
                            ),
                    ),
                    Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(50),
                            child: Center(
                                child: CenteredText.getCenteredText(
                                    "Total: " + total.toStringAsFixed(2)))),
                        isReviewStage
                            ? Container()
                            : ElevatedButton(
                                onPressed: () {
                                  if (true) {
                                    setState(() {
                                      isReviewStage = true;
                                    });
                                  } else {
                                    //  TODO: add popup for empty cart
                                  }
                                },
                                child: CenteredText.getCenteredText("Review"),
                              )
                      ],
                    )
                  ],
                )),
          ])),
    );
  }
}

class ListItem extends StatefulWidget {
  ListItem(
      {Key? key,
      required this.item,
      required this.updateTotal,
      required this.isReviewStage,
      required this.updateMap,
      required this.count})
      : super(key: key);
  final Item item;
  bool isReviewStage;
  int count;

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
    if (widget.count != 0) {
      controller.text = widget.count.toString();
    }
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Default grid side to 4
            Expanded(
                flex: 4, child: CenteredText.getCenteredText(widget.item.name)),
            Expanded(
                flex: 4,
                child: CenteredText.getCenteredText(widget.item.category)),
            Expanded(
              flex: 4,
              child: ElevatedButton(
                child: Text('Details'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        itemDetail(context, widget.item),
                  );
                },
              ),
            ),
            Expanded(flex: 4, child: CenteredText.getCenteredText(
                // price format X.XX
                widget.item.price.toStringAsFixed(2))),
            // The add + remove + input together take 4 unit space
            Expanded(
                flex: 1,
                // Only display if the count is larger than 0
                child: count != 0 && !widget.isReviewStage
                    ? IconButton(
                        onPressed: () => setState(() {
                              count--;
                              widget.updateTotal(0 - widget.item.price);
                              // Ideally we want to map count value automatically to the field. However, due to in-place count value update. The trigger is messed up so we have to manually set them everywhere
                              controller.text = count.toString();
                              widget.updateMap(widget.item, count);
                            }),
                        icon: const Icon(Icons.remove))
                    : Container()),
            Expanded(
                flex: 2,
                child: TextField(
                  controller: controller,
                  enabled: !widget.isReviewStage,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter a number'),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (String value) async {
                    if (value.isNotEmpty) {
                      widget.updateTotal(
                          (int.parse(value) - count) * widget.item.price);
                      count = int.parse(value);
                      controller.text = count.toString();
                      widget.updateMap(widget.item, count);
                    } else {
                      widget.updateTotal((0 - count) * widget.item.price);
                      count = 0;
                      controller.text = count.toString();
                      widget.updateMap(widget.item, count);
                    }
                    controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.text.length));
                  },
                  // Only allow number input for user experience
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                )),
            Expanded(
                flex: 1,
                child: !widget.isReviewStage
                    ? IconButton(
                        onPressed: () => setState(() {
                              count++;
                              widget.updateTotal(widget.item.price);
                              controller.text = count.toString();
                              widget.updateMap(widget.item, count);
                            }),
                        icon: const Icon(Icons.add))
                    : Container())
          ],
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
        Text(" "),
        Text(item.description),
        Text(" "),
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