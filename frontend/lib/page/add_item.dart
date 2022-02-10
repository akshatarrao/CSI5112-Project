// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//import 'package:image_picker/image_picker.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  double price = 0;
  String category = "";
  String description = "";
  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(
          height: 30,
          child: Text("Add Item"),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...[
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter Item Name...',
                            labelText: 'Item Name',
                          ),
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter Item Price...',
                            labelText: 'Price',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              price = double.parse(value);
                            });
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter a description...',
                            labelText: 'Description',
                          ),
                          onChanged: (value) {
                            description = value;
                          },
                          maxLines: 5,
                        ),
                        TextFormField(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FloatingActionButton(
                              child: const Icon(Icons.arrow_back),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              onPressed: () => {Navigator.pop(context)},
                            ),
                            FloatingActionButton(
                              child: const Icon(Icons.check),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              onPressed: () => {},
                            ),
                          ],
                        ),
                      ].expand(
                        (widget) => [
                          widget,
                          const SizedBox(
                            height: 24,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
