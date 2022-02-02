import 'package:csi5112_frontend/component/app_bar.dart';
import 'package:csi5112_frontend/page/item_list.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar.getAppBar(),
      // TODO: Add more team/project info
      body: Center(
        child: ElevatedButton(
          child: const Text('Login'),
          onPressed: () {
            // navigate to item list page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ItemList()),
            );
          },
        ),
      ),
    );
  }
}
