import 'package:csi5112_frontend/component/app_bar.dart';
import 'package:csi5112_frontend/page/discussion_forum.dart';
import 'package:csi5112_frontend/page/item_list.dart';
import 'package:csi5112_frontend/page/order_history.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar.getAppBar(context),
      // TODO: Add more team/project info
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                // navigate to item list page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemList()),
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Discussion Forum (to be deleted)'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DiscussionForum()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Order History (to be deleted)'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderHistory()),
                );
              },
            ),
          ])),
    );
  }
}
