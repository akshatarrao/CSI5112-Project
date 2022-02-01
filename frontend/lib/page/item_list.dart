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
  final items = List<Item>.generate(
      25, (i) => Item(name: "No. " + i.toString(), cost: i.toDouble()));
  int perPage = 5;

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
                  itemCount: perPage,
                  separatorBuilder: (BuildContext context, int index) =>
                      DefaultDivider.getDefaultDivider(context),
                  itemBuilder: (BuildContext context, int index) {
                    return ListItem(
                        name: items[index].name, cost: items[index].cost);
                  },
                )),
            // Only display the load button if there are more to load

            Expanded(
              flex: 1,
              child: perPage != items.length
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: ElevatedButton(
                        child: const Text('Load the next 5 items...'),
                        onPressed: () {
                          setState(() {
                            perPage = perPage + 5;
                          });
                        },
                      ))
                  // Empty placeholder to prevent itemList change grid
                  : Container(),
            )
          ])),
    );
  }
}

class ListItem extends StatefulWidget {
  const ListItem({
    Key? key,
    required this.name,
    required this.cost,
  }) : super(key: key);
  final String name;
  final double cost;

  @override
  State<StatefulWidget> createState() => _ListItem();
}

class _ListItem extends State<ListItem> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Default grid side to 4
            Expanded(flex: 4, child: CenteredText.getCenteredText(widget.name)),
            Expanded(flex: 4, child: CenteredText.getCenteredText(
                // price format X.XX
                widget.cost.toStringAsFixed(2))),
            // The add + remove + input together take 4 unit space
            Expanded(
                flex: 1,
                // Only display if the count is larger than 0
                child: count != 0
                    ? IconButton(
                        onPressed: () => setState(() {
                              count--;
                            }),
                        icon: const Icon(Icons.remove))
                    : Container()),
            Expanded(
                flex: 2,
                child: TextField(
                  controller: TextEditingController(text: count.toString()),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter a number'),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  // Only allow number input for user experience
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                )),
            Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () => setState(() {
                          count++;
                        }),
                    icon: const Icon(Icons.add)))
          ],
        ));
  }
}
