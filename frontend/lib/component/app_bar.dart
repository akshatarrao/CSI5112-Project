import 'package:csi5112_frontend/page/discussion_forum.dart';
import 'package:csi5112_frontend/page/item_list.dart';
import 'package:csi5112_frontend/page/order_history.dart';
import 'package:flutter/material.dart';

class DefaultAppBar {
  static getAppBar(BuildContext context) {
    // TODO: hide active tab
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    // Extracted app bar to avoid code copy paste
    return AppBar(
      //TODO: name the app
      title: const Text("TBD text"),
      actions: <Widget>[
        TextButton(
          style: style,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DiscussionForum()),
            );
          },
          child: const Text('Discussion Forum'),
        ),
        TextButton(
          style: style,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ItemList()),
            );
          },
          child: const Text('Item List'),
        ),
        TextButton(
          style: style,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderHistory()),
            );
          },
          child: const Text('Order History'),
        )
      ],
    );
  }
}
